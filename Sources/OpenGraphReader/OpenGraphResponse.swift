//
//  File.swift
//  
//
//  Created by Piotr Żmudziński on 07/08/2023.
//

import Foundation

public struct OpenGraphResponse {
    private let source: [String: [String]]
    public init(source: [String: [String]]) {
        self.source = source
    }
}

public extension OpenGraphResponse {
    var title: String? {
        source.stringValue("og:title")
    }
    
    var description: String? {
        source.stringValue("og:description")
    }
    
    var imageURL: URL? {
        source.urlValue("og:image")
    }
    
    var siteName: String? {
        source.stringValue("og:site_name")
    }
    
    var imageWidth: Double? {
        source.doubleValue("og:image:width")
    }
    
    var imageHeight: Double? {
        source.doubleValue("og:image:height")
    }
}

private extension Dictionary where Element == (key: String, value: [String]) {
    func stringValue(_ key: String) -> String? {
        self[key]?.first
    }
    
    func doubleValue(_ key: String) -> Double? {
        guard let doubleValue = self[key]?.first else {
            return nil
        }
        return Double(doubleValue)
    }
    
    func urlValue(_ key: String) -> URL? {
        guard let string = self["og:image"]?.first else {
            return nil
        }
        return URL(string: string)
    }
}
