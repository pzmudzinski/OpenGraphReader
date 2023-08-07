import Foundation
import SwiftSoup

public enum OpenGraphError: Error {
    case invalidURL
    case invalidResponse

    case parsingError(Error)
}

public class OpenGraphReader {
    public struct OpenGraphRequest {
        let url: URL
        let headers: [String: String]
    }
    
    private let urlSession: URLSession
    
    public init(sessionConfiguration: URLSessionConfiguration = .default) {
        urlSession = URLSession(configuration: sessionConfiguration)
    }
    
    public func fetch(request: URLRequest) async throws -> OpenGraphResponse {
        let (data, response) = try await urlSession.data(for: request)
        
        guard let htmlResponse = response as? HTTPURLResponse, htmlResponse.ok else {
            throw OpenGraphError.invalidResponse
        }
        
        guard let html = String(data: data, encoding: .utf8) else {
            throw OpenGraphError.invalidResponse
        }
        
        return try parse(html: html)
    }
    
    public func fetch(url: URL) async throws -> OpenGraphResponse {
        try await fetch(request: .init(url: url))
    }
    
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
