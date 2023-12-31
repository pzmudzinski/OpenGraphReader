# OpenGraphReader

[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
![Tests](https://github.com/pzmudzinski/OpenGraphReader/actions/workflows/tests.yml/badge.svg)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/pzmudzinski/OpenGraphReader/blob/main/LICENSE)

OpenGraphReader is a Swift library that allows you to easily extract OpenGraph metadata from HTML content. OpenGraph metadata provides structured information about a web page's content when shared on social media platforms.

## Features

- Fetches OpenGraph metadata from a URL or a URLRequest.
- Parses HTML content to extract various OpenGraph properties such as title, type, description, URL, images, site name, and more.
- Provides convenient extensions for accessing OpenGraph properties in a structured manner.

## Installation

### Installing via Swift Package Manager (SPM)

You can easily integrate OpenGraphReader into your project using Swift Package Manager:

1. Open your Xcode project.
2. Click on "File" > "Swift Packages" > "Add Package Dependency..."
3. Enter the URL of this repository: `https://github.com/pzmudzinski/OpenGraphReader.git`
4. Choose "Up To Next Major Version": 1.0.0
5. Click "Add Package"

## Usage

### Fetching OpenGraph Metadata

To fetch and parse OpenGraph metadata from a URL:

```swift
import OpenGraphReader

let reader = OpenGraphReader()
do {
    let openGraphResponse = try await reader.fetch(url: .init(string: "https://www.imdb.com/title/tt15398776/?ref_=ext_shr_lnk"))
    // Access OpenGraph properties using openGraphResponse properties
    print("Title: \(openGraphResponse.title ?? "")")
    print("Description: \(openGraphResponse.description ?? "")")
    // ...
} catch {
    print("Error: \(error)")
}
```

### Using HTML directly

If you already have HTML you can pass it to reader as well:

```swift
let response = try reader.parse(html: "...")

```

### Getting non default meta tags

If `OpenGraphResponse` does not have all properties you need you can directly access all meta tags (including those not being part of OpenGraph specification) by using one of those helper methods:

```swift
response.stringValue("twitter:image")
response.arrayValue("twitter:tag")
response.doubleValue("twitter:image:height")
response.urlValue("twitter:image:url")
```

## Requirements

- iOS 15.0+ / macOS 12.0+
- Swift 5+

## Contributions

Contributions to OpenGraphReader are welcome! Feel free to submit issues or pull requests for improvements or bug fixes.

## License

OpenGraphReader is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
