import Foundation
import SwiftSoup

public struct OpenGraphData {
    public var title: String?
    public var description: String?
    public var imageURL: URL?
    // Add more OpenGraph properties as needed
}

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
    
    public func parse(url: URL) async throws -> OpenGraphData {
        let (data, response) = try await urlSession.data(for: .init(url: url))
        
        guard let htmlResponse = response as? HTTPURLResponse, htmlResponse.ok else {
            throw OpenGraphError.invalidResponse
        }
        
        guard let html = String(data: data, encoding: .utf8) else {
            throw OpenGraphError.invalidResponse
        }
        
        do {
            let doc = try SwiftSoup.parse(html)
            var openGraphData = OpenGraphData()
            
            openGraphData.title = try doc.select("meta[property=og:title]").attr("content")
            openGraphData.description = try doc.select("meta[property=og:description]").attr("content")
            let ogImageURL = try doc.select("meta[property=og:image]").attr("content")
            openGraphData.imageURL = URL(string: ogImageURL)
            
            return openGraphData
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
