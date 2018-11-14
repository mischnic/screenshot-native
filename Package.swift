// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "screenshot",
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "5.2.0"),
    ],
    targets: [
        .target(
            name: "screenshot",
            dependencies: ["SwiftCLI"]
        ),
    ]
)
