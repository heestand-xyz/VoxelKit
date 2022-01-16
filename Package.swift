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
        .package(url: "https://github.com/hexagons/RenderKit.git", from: "2.0.0"),
    ],
    targets: [
        .target(name: "VoxelKit", dependencies: ["RenderKit"], exclude: [
            "Shaders/README.md",
        ]),
    ]
)
