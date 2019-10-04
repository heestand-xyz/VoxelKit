//
//  VOX.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-04.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import LiveValues
import RenderKit
import Metal
import simd

public class VOX: NODE {
    
    public let id = UUID()
    public var name: String?
    
    public var delegate: NODEDelegate?
    
    public var shaderName: String { return "" }
    
    public var view: NODEView
    
    open var liveValues: [LiveValue] { return [] }
    open var preUniforms: [CGFloat] { return [] }
    open var postUniforms: [CGFloat] { return [] }
    open var uniforms: [CGFloat] {
        var vals: [CGFloat] = []
        vals.append(contentsOf: preUniforms)
        for liveValue in liveValues {
            if let liveFloat = liveValue as? LiveFloat {
                vals.append(liveFloat.uniform)
            } else if let liveInt = liveValue as? LiveInt {
                vals.append(CGFloat(liveInt.uniform))
            } else if let liveBool = liveValue as? LiveBool {
                vals.append(liveBool.uniform ? 1.0 : 0.0)
            } else if let liveColor = liveValue as? LiveColor {
                vals.append(contentsOf: liveColor.colorCorrect.uniformList)
            } else if let livePoint = liveValue as? LivePoint {
                vals.append(contentsOf: livePoint.uniformList)
            } else if let liveSize = liveValue as? LiveSize {
                vals.append(contentsOf: liveSize.uniformList)
            } else if let liveRect = liveValue as? LiveRect {
                vals.append(contentsOf: liveRect.uniformList)
            } else if let liveVec = liveValue as? LiveVec {
                vals.append(contentsOf: liveVec.uniformList)
            }
        }
        vals.append(contentsOf: postUniforms)
        return vals
    }
    
    public var liveArray: [[LiveFloat]] { return [] }
    open var uniformArray: [[CGFloat]] {
        return liveArray.map({ liveFloats -> [CGFloat] in
            return liveFloats.map({ liveFloat -> CGFloat in
                return liveFloat.uniform
            })
        })
    }
    
    public var needsRender: Bool = false {
        didSet {
            guard needsRender else { return }
            guard VoxelKit.main.render.engine.renderMode == .direct else { return }
            VoxelKit.main.render.engine.renderNODE(self, done: { _ in })
        }
    }
    public var rendering: Bool = false
    public var inRender: Bool = false
    public var renderIndex: Int = 0
    
    public var bypass: Bool = false
    
    public var contentLoaded: Bool?
    
    public var vertexUniforms: [CGFloat] { return [] }
    
    public var shaderNeedsAspect: Bool { return false }
    
    public var pipeline: MTLRenderPipelineState!
    public var sampler: MTLSamplerState!
    
    public var customRenderActive: Bool = false
    public var customRenderDelegate: CustomRenderDelegate?
    public var customMergerRenderActive: Bool = false
    public var customMergerRenderDelegate: CustomMergerRenderDelegate?
    public var customGeometryActive: Bool = false
    public var customGeometryDelegate: CustomGeometryDelegate?
    public var customMetalLibrary: MTLLibrary? { return nil }
    public var customVertexShaderName: String? { return nil }
    public var customVertexTextureActive: Bool { return false }
    public var customVertexNodeIn: (NODE & NODEOut)? { return nil }
    public var customMatrices: [matrix_float4x4] { return [] }
    public var customLinkedNodes: [NODE] = []
    
    public var destroyed: Bool = false
    
    public var texture: MTLTexture?
    
    // MARK: - Life Cycle
    
    init() {
        view = NODEView(with: VoxelKit.main.render)
    }
    
    // MARK: - Render
    
    public func setNeedsRender() {
        
    }
    
    public func didRender(texture: MTLTexture, force: Bool) {
        
    }
    
    // MARK: - Other
    
    public func checkLive() {
        
    }
    
    public func destroy() {
        
    }
    
    public func isEqual(to node: NODE) -> Bool {
        id == node.id
    }
    
}
