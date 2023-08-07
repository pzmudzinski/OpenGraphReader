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
    
    public func parse(url: URL) async throws -> OpenGraphResponse {
        let (data, response) = try await urlSession.data(for: .init(url: url))
        
        guard let htmlResponse = response as? HTTPURLResponse, htmlResponse.ok else {
            throw OpenGraphError.invalidResponse
        }
        
        guard let html = String(data: data, encoding: .utf8) else {
            throw OpenGraphError.invalidResponse
        }
        
        do {
            let doc = try SwiftSoup.parse(html)

            let metas = try doc.select("meta[property]")
            var result: [String: [String]] = [:]
            
            metas.forEach { meta in
                guard let propertyName = try? meta.attr("property"), let content = try? meta.attr("content") else { return }
                var currentValues = result[propertyName, default: []]
                currentValues.append(content)
                result.updateValue(currentValues, forKey: propertyName)
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
