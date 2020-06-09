// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bark",
    platforms: [.iOS(.v11), .macOS(.v10_13)],
    products: [
        .library(name: "Bark", targets: ["Bark"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "Bark", dependencies: [.product(name: "Logging", package: "swift-log")]),
        .testTarget(name: "BarkTests", dependencies: ["Bark"]),
    ]
)
