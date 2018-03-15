// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "DeSServer",
    products: [
        .library(name: "App", targets: ["App"]),
        .executable(name: "Run", targets: ["Run"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/vapor/fluent-provider.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/vapor/leaf-provider.git", .upToNextMajor(from: "1.1.0")),
        .package(url: "https://github.com/vapor/postgresql-provider.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "0.8.3")),
        .package(url: "https://github.com/Zewo/gzip.git", .exact("0.8.0")),
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "FluentProvider", "LeafProvider", "PostgreSQLProvider", "CryptoSwift", "gzip"],
                exclude: [
                    "Config",
                    "Public",
                    "Resources",
                ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App", "Testing"])
    ]
)
