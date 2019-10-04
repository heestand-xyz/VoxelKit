//
//  VoxelKit.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit

class VoxelKit {

    public static let main = VoxelKit()
    
    // MARK: Signature
    
    #if os(macOS) || targetEnvironment(macCatalyst)
    let kBundleId = "se.hexagons.voxelkit.macos"
    let kMetalLibName = "VoxelKitShaders-macOS"
    #elseif os(iOS)
    let kBundleId = "se.hexagons.voxelkit"
    let kMetalLibName = "VoxelKitShaders"
    #elseif os(tvOS)
    let kBundleId = "se.hexagons.voxelkit.tvos"
    let kMetalLibName = "VoxelKitShaders-tvOS"
    #endif
    
    public let render: Render
    let logger: Logger

    init() {
        render = Render(with: kMetalLibName)
        logger = Logger(name: "VoxelKit")
    }
    
}
