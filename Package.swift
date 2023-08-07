// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenGraphReader",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "OpenGraphReader",
            targets: ["OpenGraphReader"]),
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.3.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "OpenGraphReader",
            dependencies: ["SwiftSoup"]),
        .testTarget(
            name: "OpenGraphReaderTests",
            dependencies: ["OpenGraphReader"],
            resources: [
                        .copy("Resources/spotifyPlaylist.html"),
                        .copy("Resources/imdb.html"),
                        .copy("Resources/google.html")
                    ]),
    ],
    swiftLanguageVersions: [.v5]
)
