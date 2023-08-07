//
//  File.swift
//  
//
//  Created by Piotr Żmudziński on 07/08/2023.
//

import Foundation

class MockURLProtocol: URLProtocol {
    enum MockedResponse {
        case error(Error)
        case data(Data)
        case urlResponse(HTTPURLResponse)
    }
    typealias ResponseMapping = [URL: MockedResponse]
    
    private static var mockURLs: ResponseMapping = [:]
    
    public static func add(_ mockedResponse: MockedResponse, forURL url: URL) {
        MockURLProtocol.mockURLs[url] = mockedResponse
    }
    
    public static func clearResponses() {
        MockURLProtocol.mockURLs.removeAll()
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        if let url = request.url {
            if let mockedResponse = MockURLProtocol.mockURLs[url] {
                
                switch mockedResponse {
                case let .data(data):
                    client?.urlProtocol(self, didLoad: data)
                    let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
                    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                case let .error(error):
                    client?.urlProtocol(self, didFailWithError: error)
                case let .urlResponse(response):
                    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }
            } else {
                client?.urlProtocol(self, didReceive: .notFound(url: url), cacheStoragePolicy: .notAllowed)
            }
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}

private extension URLResponse {
    static func notFound(url: URL) -> HTTPURLResponse { .init(url: url, statusCode: 404, httpVersion: nil, headerFields: [:])! }
}
