//
//  File.swift
//  
//
//  Created by Piotr Żmudziński on 07/08/2023.
//

import Foundation

/// Represents the response containing OpenGraph data extracted from a source.
public struct OpenGraphResponse {
    private let source: [String: [String]]
    
    /// Initializes an instance of `OpenGraphResponse`.
    /// - Parameter source: The source dictionary containing OpenGraph data.
    public init(source: [String: [String]]) {
        self.source = source
    }
}

// MARK: - Properties and Extensions

public extension OpenGraphResponse {
    /// The title of the OpenGraph content.
    var title: String? {
        source.stringValue("og:title") ?? source.stringValue("title")
    }
    
    /// The type of the OpenGraph content.
    var type: String? {
        source.stringValue("og:type")
    }
    
    /// The description of the OpenGraph content.
    var description: String? {
        source.stringValue("og:description")
    }
    
    /// The URL of the OpenGraph content.
    var url: URL? {
        source.urlValue("og:url")
    }
    
    /// The URL of the main image associated with the OpenGraph content.
    var imageURL: URL? {
        source.urlValue("og:image")
    }
    
    /// The alt text of the main image associated with the OpenGraph content.
    var imageAlt: String? {
        source.stringValue("og:image:alt")
    }
    
    /// The secure URL of the main image associated with the OpenGraph content.
    var imageSecureURL: URL? {
        source.urlValue("og:image:secure_url")
    }
    
    /// The MIME type of the main image associated with the OpenGraph content.
    var imageType: String? {
        source.stringValue("og:image:type")
    }
    
    /// The width of the main image associated with the OpenGraph content.
    var imageWidth: Double? {
        source.doubleValue("og:image:width")
    }
    
    /// The height of the main image associated with the OpenGraph content.
    var imageHeight: Double? {
        source.doubleValue("og:image:height")
    }
    
    /// The site name associated with the OpenGraph content.
    var siteName: String? {
        source.stringValue("og:site_name")
    }
    
    /// The list of allowed countries for accessing the OpenGraph content.
    var restrictionsCountriesAllowed: [String]? {
        source["og:restrictions:country:allowed"]
    }
    
    /// The URL of the audio associated with the OpenGraph content.
    var audioURL: URL? {
        source.urlValue("og:audio")
    }
    
    /// The determiner of the OpenGraph content.
    var determiner: String? {
        source.stringValue("og:determiner")
    }
    
    /// The locale of the OpenGraph content.
    var locale: String? {
        source.stringValue("og:locale")
    }
    
    /// The list of alternate locales for the OpenGraph content.
    var localeAlternate: [String]? {
        source["og:locale:alternate"]
    }
    
    /// The URL of the video associated with the OpenGraph content.
    var videoURL: URL? {
        source.urlValue("og:video")
    }
}

public extension OpenGraphResponse {
    /// Retrieves an array of values associated with the specified key from the source.
    /// - Parameter key: The key for which to retrieve the array of values.
    /// - Returns: An array of values associated with the key, if present; otherwise, `nil`.
    func arrayValue(_ key: String) -> [String]? {
        source[key]
    }
    
    /// Retrieves a string value associated with the specified key from the source.
    /// - Parameter key: The key for which to retrieve the string value.
    /// - Returns: A string value associated with the key, if present; otherwise, `nil`.
    func stringValue(_ key: String) -> String? {
        source.stringValue(key)
    }
    
    /// Retrieves a double value associated with the specified key from the source.
    /// - Parameter key: The key for which to retrieve the double value.
    /// - Returns: A double value associated with the key, if present; otherwise, `nil`.
    func doubleValue(_ key: String) -> Double? {
        source.doubleValue(key)
    }
    
    /// Retrieves a URL value associated with the specified key from the source.
    /// - Parameter key: The key for which to retrieve the URL value.
    /// - Returns: A URL value associated with the key, if present; otherwise, `nil`.
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
