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
        source["og:title"]?.first
    }
    
    var description: String? {
        source["og:description"]?.first
    }
    
    var imageURL: URL? {
        guard let string = source["og:image"]?.first else {
            return nil
        }
        return URL(string: string)
    }
    
    var siteName: String? {
        source["og:site_name"]?.first
    }
}
