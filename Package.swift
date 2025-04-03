// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-dwarf",
    products: [
        .library(
            name: "DWARF",
            targets: ["DWARF"]
        ),
    ],
    targets: [
        .target(
            name: "DWARF",
            dependencies: [
                "DWARFC"
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
