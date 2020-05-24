// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PersistanceManager",
    platforms: [
        .macOS(.v10_12), .iOS(.v10)
    ],
    products: [
        .library(
            name: "PersistanceManager",
            targets: ["PersistanceManager"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PersistanceManager",
            dependencies: []),
        .testTarget(
            name: "PersistanceManagerTests",
            dependencies: ["PersistanceManager"])
    ]
)
