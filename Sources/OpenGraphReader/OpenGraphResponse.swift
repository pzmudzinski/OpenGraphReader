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
        source.stringValue("og:title") ?? source.stringValue("title")
    }
    
    var type: String? {
        source.stringValue("og:type")
    }
    
    var description: String? {
        source.stringValue("og:description")
    }
    
    var url: URL? {
        source.urlValue("og:url")
    }
    
    var imageURL: URL? {
        source.urlValue("og:image")
    }
    
    var imageAlt: String? {
        source.stringValue("og:image:alt")
    }
    
    var imageSecureURL: URL? {
        source.urlValue("og:image:secure_url")
    }
    
    var imageType: String? {
        source.stringValue("og:image:type")
    }
    
    var imageWidth: Double? {
        source.doubleValue("og:image:width")
    }
    
    var imageHeight: Double? {
        source.doubleValue("og:image:height")
    }
    
    var siteName: String? {
        source.stringValue("og:site_name")
    }
    
    var restrictionsCountriesAllowed: [String]? {
        source["og:restrictions:country:allowed"]
    }
    
    var audioURL: URL? {
        source.urlValue("og:audio")
    }
    
    var determiner: String? {
        source.stringValue("og:determiner")
    }
    
    var locale: String? {
        source.stringValue("og:locale")
    }
    
    var localeAlternate: [String]? {
        source["og:locale:alternate"]
    }
    
    var videoURL: URL? {
        source.urlValue("og:video")
    }
}

public extension OpenGraphResponse {
    func arrayValue(_ key: String) -> [String]? {
        source[key]
    }
    
    func stringValue(_ key: String) -> String? {
        source.stringValue(key)
    }
    
    func doubleValue(_ key: String) -> Double? {
        source.doubleValue(key)
    }
    
    func urlValue(_ key: String) -> URL? {
        source.urlValue(key)
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
        guard let string = self[key]?.first else {
            return nil
        }
        return URL(string: string)
    }
}
