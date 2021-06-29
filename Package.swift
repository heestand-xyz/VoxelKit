// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "VoxelKit",
    platforms: [
        .iOS(.v13),
        .tvOS(.v14),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "VoxelKit", targets: ["VoxelKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hexagons/RenderKit.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "VoxelKit", dependencies: ["RenderKit"], path: "Source", exclude: [
            "Shaders/README.md",
        ]),
    ]
)
