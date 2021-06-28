// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "VoxelKit",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13),
        .tvOS(.v11)
    ],
    products: [
        .library(name: "VoxelKit", targets: ["VoxelKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hexagons/RenderKit.git", from: "0.5.3"),
    ],
    targets: [
        .target(name: "VoxelKit", dependencies: ["RenderKit"], path: "Source", resources: [
            .copy("Metal/"),
        ]),
    ]
)
