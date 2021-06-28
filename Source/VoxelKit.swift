//
//  VoxelKit.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit
import MetalKit

/// overrides the default metal lib
public var pixelKitMetalLibURL: URL?

public class VoxelKit: EngineDelegate, LoggerDelegate {

    public static let main = VoxelKit()
    
    // MARK: Signature
    
    #if os(macOS)
    let kBundleId = "se.hexagons.voxelkit.macos"
    let kMetalLibName = "VoxelKitShaders-macOS"
    #elseif os(iOS)
    let kBundleId = "se.hexagons.voxelkit"
    #if targetEnvironment(macCatalyst)
    let kMetalLibName = "VoxelKitShaders-macCatalyst"
    #else
    #if targetEnvironment(simulator)
    let kMetalLibName = "VoxelKitShaders-iOS-Simulator"
    #else
    let kMetalLibName = "VoxelKitShaders-iOS"
    #endif
    #endif
    #elseif os(tvOS)
    let kBundleId = "se.hexagons.voxelkit.tvos"
    #if targetEnvironment(simulator)
    let kMetalLibName = "VoxelKitShaders-tvOS-Simulator"
    #else
    let kMetalLibName = "VoxelKitShaders-tvOS"
    #endif
    #endif
    
    public var tileResolution: Resolution3D = .cube(32)
    
    public let render: Render
    public let logger: Logger

    init() {
        
        if let url = pixelKitMetalLibURL {
            render = Render(metalLibURL: url)
        } else {
            let metalLibURL: URL = Bundle.module.url(forResource: kMetalLibName, withExtension: "metallib", subdirectory: "Metal")!
            render = Render(metalLibURL: metalLibURL)
        }
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
        var resourceCustom: Bool = false
        var inputTexture: MTLTexture? = nil
        var secondInputTexture: MTLTexture? = nil
        if let nodeContent = node as? NODEContent {
            if let nodeResource = nodeContent as? NODEResource {
                guard let pixelBuffer = nodeResource.pixelBuffer else {
                    throw Engine.RenderError.texture("Pixel Buffer is nil.")
                }
                inputTexture = try Texture.makeTexture(from: pixelBuffer, with: commandBuffer, force8bit: false, on: render.metalDevice)
            } else if nodeContent is NODEResourceCustom {
                resourceCustom = true
            } else if nodeContent is NODEGenerator {
                generator = true
            }
        } else if let nodeIn = node as? NODE & NODEInIO {
            guard let nodeOut = nodeIn.inputList.first else {
                throw Engine.RenderError.texture("input not connected.")
            }
            var feed = false
            if let feedbackNode = nodeIn as? FeedbackVOX {
                if feedbackNode.readyToFeed && feedbackNode.feedActive {
                    guard let feedTexture = feedbackNode.feedTexture else {
                        throw Engine.RenderError.texture("Feed Texture not avalible.")
                    }
                    inputTexture = feedTexture
                    feed = true
                }
            }
            if !feed {
                guard let nodeOutTexture = nodeOut.texture else {
                    throw Engine.RenderError.texture("IO Texture not found for: \(nodeOut)")
                }
                inputTexture = nodeOutTexture // CHECK copy?
                if node is NODEInMerger {
                    let nodeOutB = nodeIn.inputList[1]
                    guard let nodeOutTextureB = nodeOutB.texture else {
                        throw Engine.RenderError.texture("IO Texture B not found for: \(nodeOutB)")
                    }
                    secondInputTexture = nodeOutTextureB // CHECK copy?
                }
            }
        }

        guard generator || resourceCustom || inputTexture != nil else {
            throw Engine.RenderError.texture("Input Texture missing.")
        }
        
        // Mipmap

//        if inputTexture != nil {
//            try Texture.mipmap(texture: inputTexture!, with: commandBuffer)
//        }
//        if secondInputTexture != nil {
//            try Texture.mipmap(texture: secondInputTexture!, with: commandBuffer)
//        }

        return (inputTexture, secondInputTexture, nil)

    }
    
    public func tileTextures(from node: NODE & NODETileable, at tileIndex: TileIndex, with commandBuffer: MTLCommandBuffer) throws -> (a: MTLTexture?, b: MTLTexture?, custom: MTLTexture?) {
        
        var generator: Bool = false
        var inputTexture: MTLTexture? = nil
        var secondInputTexture: MTLTexture? = nil
        if let nodeContent = node as? NODEContent {
            if nodeContent is NODEGenerator {
                generator = true
            }
        } else if let nodeIn = node as? NODE & NODEInIO {
            guard let nodeOut = nodeIn.inputList.first else {
                throw Engine.RenderError.texture("input not connected.")
            }
            guard let nodeOutTileable3d = nodeOut as? NODE & NODETileable3D else {
                 throw Engine.RenderError.nodeNotTileable
            }
            var feed = false
            if let feedbackNode = nodeIn as? FeedbackVOX {
                if feedbackNode.readyToFeed && feedbackNode.feedActive {
                    guard let feedTexture = feedbackNode.tileFeedTexture(at: tileIndex) else {
                        throw Engine.RenderError.texture("Feed Texture not avalible.")
                    }
                    inputTexture = feedTexture
                    feed = true
                }
            }
            if !feed {
                guard let nodeOutTexture = nodeOutTileable3d.tileTextures?[tileIndex.z][tileIndex.y][tileIndex.x] else {
                    throw Engine.RenderError.texture("Tile IO Texture not found for: \(nodeOut)")
                }
                inputTexture = nodeOutTexture // CHECK copy?
                if node is NODEInMerger {
                    let nodeOutB = nodeIn.inputList[1]
                    guard let nodeOutBTileable3d = nodeOutB as? NODE & NODETileable3D else {
                         throw Engine.RenderError.nodeNotTileable
                    }
                    guard let nodeOutTextureB = nodeOutBTileable3d.tileTextures?[tileIndex.z][tileIndex.y][tileIndex.x] else {
                        throw Engine.RenderError.texture("Tile IO Texture B not found for: \(nodeOutB)")
                    }
                    secondInputTexture = nodeOutTextureB // CHECK copy?
                }
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

        return (inputTexture, secondInputTexture, nil)

    }
    

}
