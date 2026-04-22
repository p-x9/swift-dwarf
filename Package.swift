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
        .library(
            name: "DWARFMachO",
            targets: ["DWARFMachO"]
        ),
        .library(
            name: "DWARFELF",
            targets: ["DWARFELF"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/p-x9/swift-fileio.git", from: "0.12.0"),
        .package(
            url: "https://github.com/p-x9/swift-fileio-extra.git",
            from: "0.2.2"
        ),
        .package(url: "https://github.com/p-x9/MachOKit.git", from: "0.47.0"),
        .package(url: "https://github.com/p-x9/ELFKit.git", from: "0.6.0"),
    ],
    targets: [
        .target(
            name: "DWARF",
            dependencies: [
                "DWARFC",
                .product(name: "FileIO", package: "swift-fileio"),
                .product(name: "FileIOBinary", package: "swift-fileio-extra")
            ]
        ),
        .target(
            name: "DWARFMachO",
            dependencies: [
                "DWARF",
                .product(name: "MachOKit", package: "MachOKit"),
                .product(name: "FileIO", package: "swift-fileio")
            ]
        ),
        .target(
            name: "DWARFELF",
            dependencies: [
                "DWARF",
                .product(name: "ELFKit", package: "ELFKit"),
                .product(name: "FileIO", package: "swift-fileio")
            ]
        ),
        .target(
            name: "DWARFC"
        ),
        .testTarget(
            name: "DWARFTests",
            dependencies: ["DWARF", "DWARFMachO", "DWARFELF"]
        ),
    ]
)
