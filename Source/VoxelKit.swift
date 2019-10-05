//
//  VoxelKit.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit

public class VoxelKit: EngineDelegate, LoggerDelegate {

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
    public let logger: Logger

    init() {
        
        render = Render(with: kMetalLibName, in: Bundle(for: type(of: self)))
        logger = Logger(name: "VoxelKit")
        
        render.engine.deleagte = self
        logger.delegate = self
        
    }
    
    // MARK: - Logger Delegate
    
    public func loggerFrameIndex() -> Int {
        render.frame
    }
    
    public func loggerLinkIndex(of node: NODE) -> Int? {
        render.linkIndex(of: node)
    }
    
    // MARK: - Texture
    
    public func textures(from node: NODE, with commandBuffer: MTLCommandBuffer) throws -> (a: MTLTexture?, b: MTLTexture?, custom: MTLTexture?) {

        var generator: Bool = false
        var inputTexture: MTLTexture? = nil
        if let nodeContent = node as? NODEContent {
            if let nodeResource = nodeContent as? NODEResource {
                guard let pixelBuffer = nodeResource.pixelBuffer else {
                    throw Engine.RenderError.texture("Pixel Buffer is nil.")
                }
                inputTexture = try Texture.makeTexture(from: pixelBuffer, with: commandBuffer, force8bit: false, on: render.metalDevice)
            } else if nodeContent is NODEGenerator {
                generator = true
            }
        }

        guard generator || inputTexture != nil else {
            throw Engine.RenderError.texture("Input Texture missing.")
        }
        
        // Mipmap

//        if inputTexture != nil {
//            try Texture.mipmap(texture: inputTexture!, with: commandBuffer)
//        }
//        if secondInputTexture != nil {
//            try Texture.mipmap(texture: secondInputTexture!, with: commandBuffer)
//        }

        return (inputTexture, nil, nil)

    }
    
}
