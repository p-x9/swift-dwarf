// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-dwarf",
    products: [
        .library(
            name: "DWARF",
            targets: ["DWARF"]),
    ],
    targets: [
        .target(
            name: "DWARF"
        ),
        .testTarget(
            name: "DWARFTests",
            dependencies: ["DWARF"]
        ),
    ]
)
