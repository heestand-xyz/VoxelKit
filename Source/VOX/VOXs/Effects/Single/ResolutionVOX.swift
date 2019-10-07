//
//  ResolutionVOX.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-08-03.
//  Open Source - MIT License
//

import RenderKit
import CoreGraphics
//import MetalPerformanceShaders

@available(iOS 11.3, *)
public class ResolutionVOX: VOXSingleEffect, NODEResolution3D/*, CustomRenderDelegate*/ {

    override open var shaderName: String { return "effectSingleResolutionVOX" }
    
    // MARK: - Public Properties
    
    public var resolution: Resolution3D { didSet { applyResolution { self.setNeedsRender() } } }
    public var resMultiplier: CGFloat = 1 { didSet { applyResolution { self.setNeedsRender() } } }
    public var inheritInResolution: Bool = false { didSet { applyResolution { self.setNeedsRender() } } }
    
    // MARK: - Life Cycle
    
    required public init(at resolution: Resolution3D) {
        self.resolution = resolution
        super.init()
        name = "res"
//        customRenderDelegate = self
//        customRenderActive = true
    }
    
    required init() {
        self.resolution = ._128
        super.init()
    }
    
//    public func customRender(_ texture: MTLTexture, with commandBuffer: MTLCommandBuffer) -> MTLTexture? {
//        do {
//            let destinationTexture = try Texture.emptyTexture3D(at: resolution, bits: VoxelKit.main.render.bits, on: VoxelKit.main.render.metalDevice)
//            let scaleKernel = MPSImageReduceRowMax(device: VoxelKit.main.render.metalDevice)
//            scaleKernel.clipRectSource = MTLRegion(origin: MTLOrigin(x: 0, y: 0, z: 0), size: MTLSize(width: resolution.x, height: resolution.y, depth: resolution.z))
//            scaleKernel.encode(commandBuffer: commandBuffer, sourceTexture: texture, destinationTexture: destinationTexture)
//            return destinationTexture
//        } catch {
//            VoxelKit.main.logger.log(node: self, .error, .generator, "Resolution Custom Render failed.", e: error)
//            return nil
//        }
//    }
    
}

@available(iOS 11.3, *)
public extension NODEOut {
    
    func _reRes(to resolution: Resolution3D) -> ResolutionVOX {
        let resPix = ResolutionVOX(at: resolution)
        resPix.name = "reRes:res"
        resPix.input = self as? VOX & NODEOut
        return resPix
    }
    
    func _reRes(by resMultiplier: CGFloat) -> ResolutionVOX {
        let resPix = ResolutionVOX(at: ._128)
        resPix.name = "reRes:res"
        resPix.input = self as? VOX & NODEOut
        resPix.inheritInResolution = true
        resPix.resMultiplier = resMultiplier
        return resPix
    }
    
}
