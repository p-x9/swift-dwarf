// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-dwarf",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16),
    ],
    products: [
        .library(
            name: "DWARF",
            targets: ["DWARF"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/p-x9/MachOKit.git", from: "0.44.0"),
        .package(url: "https://github.com/p-x9/swift-fileio.git", from: "0.12.0")
    ],
    targets: [
        .target(
            name: "DWARF",
            dependencies: [
                "DWARFC",
                .product(name: "MachOKit", package: "MachOKit"),
                .product(name: "FileIO", package: "swift-fileio")
            ]
        ),
        .target(
            name: "DWARFC"
        ),
        .testTarget(
            name: "DWARFTests",
            dependencies: ["DWARF"]
        ),
    ]
)
