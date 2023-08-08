import Foundation
import SwiftSoup

/// Represents errors that can occur during OpenGraph operations.
public enum OpenGraphError: Error {
    case invalidURL
    case fetchError
    case invalidResponse
    case parsingError(Error)
}

/// A utility class for reading OpenGraph data from a URL.
public class OpenGraphReader {
    private let urlSession: URLSession
    
    /// Initializes an instance of `OpenGraphReader`.
    /// - Parameter sessionConfiguration: The session configuration for URL requests.
    public init(sessionConfiguration: URLSessionConfiguration = .default) {
        urlSession = URLSession(configuration: sessionConfiguration)
    }
    
    /// Fetches OpenGraph data from a URL request.
    /// - Parameter request: The URL request to fetch OpenGraph data from.
    /// - Returns: An `OpenGraphResponse` containing the fetched data.
    public func fetch(request: URLRequest) async throws -> OpenGraphResponse {
        let (data, response) = try await urlSession.data(for: request)
        
        guard let htmlResponse = response as? HTTPURLResponse, htmlResponse.ok else {
            throw OpenGraphError.fetchError
        }
        
        guard let html = String(data: data, encoding: .utf8) else {
            throw OpenGraphError.invalidResponse
        }
        
        return try parse(html: html)
    }
    
    /// Fetches OpenGraph data from a URL.
    /// - Parameter url: The URL to fetch OpenGraph data from.
    /// - Returns: An `OpenGraphResponse` containing the fetched data.
    public func fetch(url: URL) async throws -> OpenGraphResponse {
        try await fetch(request: .init(url: url))
    }
    
    /// Parses the HTML content and extracts OpenGraph data.
    /// - Parameter html: The HTML content to parse.
    /// - Returns: An `OpenGraphResponse` containing the parsed OpenGraph data.
    public func parse(html: String) throws -> OpenGraphResponse {
        do {
            let doc = try SwiftSoup.parse(html)

            let metas = try doc.select("meta")
            var result: [String: [String]] = [:]
            
            metas.forEach { meta in
                guard var propertyName = try? meta.attr("property"), let content = try? meta.attr("content") else { return }
                if propertyName.isEmpty, let metaName = try? meta.attr("name") {
                    propertyName = metaName
                }
                
                var currentValues = result[propertyName, default: []]
                currentValues.append(content)
                result.updateValue(currentValues, forKey: propertyName)
            }
            if let title = try? doc.title() {
                result["title"] = [title]
            }
            
            return OpenGraphResponse(source: result)
        } catch {
            throw OpenGraphError.parsingError(error)
        }
    }
}

private extension HTTPURLResponse {
    var ok: Bool {
        (200...299).contains(statusCode)
    }
}
