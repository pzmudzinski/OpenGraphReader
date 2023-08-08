//
//  File.swift
//  
//
//  Created by Piotr Żmudziński on 07/08/2023.
//

import Foundation
import XCTest

extension MockURLProtocol {
    static func addMockResponse(forURL url: URL, withLocalFile localFile: String, extension: String? = "html") {
        func loadFileFromLocalPath(_ localFilePath: String) throws -> Data {
            guard let url = Bundle.module.url(forResource: localFilePath, withExtension: `extension`) else {
                throw NSError(domain: "XCTestCase", code: 0, userInfo: ["reason": "file \(localFile) not found."])
            }
            let data = try Data(contentsOf: url)
            return data
        }
        
        do {
            let localFile = try loadFileFromLocalPath(localFile)
            MockURLProtocol.add(.data(localFile), forURL: url)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

extension XCTest {
    func addMockResponse(forURL url: URL, withLocalFile localFile: String, extension: String? = "html") {
        MockURLProtocol.addMockResponse(forURL: url, withLocalFile: localFile, extension: `extension`)
    }
}
