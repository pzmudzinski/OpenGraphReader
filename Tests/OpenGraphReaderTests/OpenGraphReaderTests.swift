import XCTest
import Foundation
@testable import OpenGraphReader

final class OpenGraphReaderTests: XCTestCase {
    
    var reader: OpenGraphReader!
    
    override func setUp() {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        
        MockURLProtocol.mockResponse(forURL: .spotifyPlaylist, withLocalFile: "spotifyPlaylist")
        MockURLProtocol.mockResponse(forURL: .imdb, withLocalFile: "imdb")
        
        reader = OpenGraphReader(sessionConfiguration: sessionConfiguration)
        
        continueAfterFailure = false
    }
    
    func testErrorWhen404() async {
        await XCTAssertThrowsError(try await reader.parse(url: .nonExisting)) { error in
            guard let openGraphError = error as? OpenGraphError, case .invalidResponse = openGraphError else {
                XCTFail("Error not instance of invalidRespone")
                return
            }
        }
    }
    
    func testPlaylistTitle() async throws {
        let parsed = try await reader.parse(url: .spotifyPlaylist)
        
        XCTAssertEqual(parsed.title, "Fierce | Women\'s Empowerment 💪🏽💋")
    }
    
    func testPlaylistImage() async throws {
        let expectedImageURL = URL(string: "https://mosaic.scdn.co/640/ab67616d00001e022318bbb0586903290db2b270ab67616d00001e024148fc1af9294805e35e9446ab67616d00001e028b3b51ce7fb80055c85c71e6ab67616d00001e02ccd9af18cc83991382c9ab9a")
        
        let parsed = try await reader.parse(url: .spotifyPlaylist)
        
        XCTAssertEqual(parsed.imageURL, expectedImageURL)
    }
    
    func testPlaylistDescription() async throws {
        let expectedDescription = "Fierce | Women\'s Empowerment 💪🏽💋 · Playlist · 151 songs · 9.2K likes"
        
        let parsed = try await reader.parse(url: .spotifyPlaylist)
        
        XCTAssertEqual(parsed.description, expectedDescription)
    }
    
    func testIMDBTitle() async throws {
        let parsed = try await reader.parse(url: .imdb)
        XCTAssertEqual(parsed.title, "Gorączka (1995) ⭐ 8.3 | Action, Crime, Drama")
    }
    
    func testIMDBSiteName() async throws {
        let parsed = try await reader.parse(url: .imdb)
        XCTAssertEqual(parsed.siteName, "IMDb")
    }
}

extension URL {
    static let nonExisting = URL(string: "https://open.spotify.com/playlist/notExisting")!
    static let spotifyPlaylist = URL(string: "https://open.spotify.com/playlist/0x4Ke4SArwRpODWyM3Azp0?si=QrIusGwiQoSnEqo3n7JaMg")!
    static let imdb = URL(string: "https://m.imdb.com/title/tt0113277")!
}

extension XCTest {
    func XCTAssertThrowsError<T: Sendable>(
        _ expression: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line,
        _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            XCTFail(message(), file: file, line: line)
        } catch {
            errorHandler(error)
        }
    }
}
