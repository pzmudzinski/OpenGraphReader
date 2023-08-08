import XCTest
import Foundation
@testable import OpenGraphReader

final class OpenGraphReaderTests: XCTestCase {
    
    var reader: OpenGraphReader!
    
    override func setUp() {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        
        addMockResponse(forURL: .spotifyPlaylist, withLocalFile: "spotifyPlaylist")
        addMockResponse(forURL: .imdb, withLocalFile: "imdb")
        addMockResponse(forURL: .google, withLocalFile: "google")
        
        reader = OpenGraphReader(sessionConfiguration: sessionConfiguration)
        
        continueAfterFailure = false
    }
    
    func testThrowsErrorWhen404() async {
        await XCTAssertThrowsError(try await reader.fetch(url: .nonExisting)) { error in
            guard let openGraphError = error as? OpenGraphError, case .fetchError = openGraphError else {
                XCTFail("Error not instance of invalidRespone")
                return
            }
        }
    }
    
    func testPlaylistTitle() async throws {
        let parsed = try await reader.fetch(url: .spotifyPlaylist)
        
        XCTAssertEqual(parsed.title, "Fierce | Women\'s Empowerment 💪🏽💋")
    }
    
    func testPlaylistImage() async throws {
        let expectedImageURL = URL(string: "https://mosaic.scdn.co/640/ab67616d00001e022318bbb0586903290db2b270ab67616d00001e024148fc1af9294805e35e9446ab67616d00001e028b3b51ce7fb80055c85c71e6ab67616d00001e02ccd9af18cc83991382c9ab9a")
        
        let parsed = try await reader.fetch(url: .spotifyPlaylist)
        
        XCTAssertEqual(parsed.imageURL, expectedImageURL)
    }
    
    func testPlaylistDescription() async throws {
        let expectedDescription = "Fierce | Women\'s Empowerment 💪🏽💋 · Playlist · 151 songs · 9.2K likes"
        
        let parsed = try await reader.fetch(url: .spotifyPlaylist)
        
        XCTAssertEqual(parsed.description, expectedDescription)
    }
    
    func testPlaylistCountriesAllowed() async throws {
        let parsed = try await reader.fetch(url: .spotifyPlaylist)
        XCTAssertEqual(parsed.restrictionsCountriesAllowed?.count, 184)
    }
    
    func testPlaylistType() async throws {
        let parsed = try await reader.fetch(url: .spotifyPlaylist)
        XCTAssertEqual(parsed.type, "music.playlist")
    }
    
    func testIMDBTitle() async throws {
        let parsed = try await reader.fetch(url: .imdb)
        XCTAssertEqual(parsed.title, "Gorączka (1995) ⭐ 8.3 | Action, Crime, Drama")
    }
    
    func testIMDBSiteName() async throws {
        let parsed = try await reader.fetch(url: .imdb)
        XCTAssertEqual(parsed.siteName, "IMDb")
    }
    
    func testIMDBImageSize() async throws {
        let parsed = try await reader.fetch(url: .imdb)
        XCTAssertEqual(1500, parsed.imageHeight)
        XCTAssertEqual(1000, parsed.imageWidth)
    }
    
    func testGoogleTitle() async throws {
        let parsed = try await reader.fetch(url: .google)
        XCTAssertEqual(parsed.title, "Google")
    }
    
    func testParseNameContentTag() throws {
        let html = "<meta content=\"origin\" name=\"referrer\" />"
        let parsed = try reader.parse(html: html)
        XCTAssertEqual(parsed.stringValue("referrer"), "origin")
    }
}

final class OpenGraphReaderParseTests: XCTestCase {
    var reader: OpenGraphReader!
    
    override func setUp() {
        reader = OpenGraphReader()
        
        continueAfterFailure = false
    }
    
    func testParseNameContentTag() throws {
        let html = "<meta content=\"origin\" name=\"referrer\" />"
        let parsed = try reader.parse(html: html)
        XCTAssertEqual(parsed.stringValue("referrer"), "origin")
    }
    
    func testParseDoubleQuote() throws {
        let html = "<meta content='Something something double quote \" Something' property='og:title' />"
        let parsed = try reader.parse(html: html)
        
        XCTAssertEqual(parsed.title, "Something something double quote \" Something")
    }
    
    func testParseCanonicalURL() throws {
        let html = "<meta content='https://www.google.com' property='og:url' />"
        let parsed = try reader.parse(html: html)
        
        XCTAssertEqual(parsed.url, URL(string: "https://www.google.com"))
    }
    
    func testParseEmptyString() throws {
        let parsed = try reader.parse(html: "")
        
        XCTAssertNil(parsed.description)
    }
    
    func testParseJSON() throws {
        let parsed = try reader.parse(html: "{a:1}")
        XCTAssertNil(parsed.description)
    }
}

extension URL {
    static let nonExisting = URL(string: "https://open.spotify.com/playlist/notExisting")!
    static let spotifyPlaylist = URL(string: "https://open.spotify.com/playlist/0x4Ke4SArwRpODWyM3Azp0?si=QrIusGwiQoSnEqo3n7JaMg")!
    static let imdb = URL(string: "https://m.imdb.com/title/tt0113277")!
    static let google = URL(string: "https://google.com")!
}


