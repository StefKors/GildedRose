// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "GildedRose",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "GildedRose",
            targets: ["GildedRose"]
        ),
    ],
    targets: [
        .target(
            name: "GildedRose",
            dependencies: []
        ),
        .executableTarget(
            name: "GildedRoseApp",
            dependencies: ["GildedRose"]
        ),
        .testTarget(
            name: "GildedRoseTests",
            dependencies: ["GildedRose"],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
