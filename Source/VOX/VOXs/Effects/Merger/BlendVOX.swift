//
//  BlendVOX.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-08-23.
//  Open Source - MIT License
//

import LiveValues
import RenderKit

public class BlendVOX: VOXMergerEffect {
    
    override open var shaderName: String { return "effectMergerBlendVOX" }
    
    // MARK: - Public Properties
    
    public var blendMode: BlendMode = .add { didSet { setNeedsRender() } }
    
    // MARK: - Property Helpers
    
    open override var uniforms: [CGFloat] {
        return [CGFloat(blendMode.index)]
    }
    
    public required init() {
        super.init()
        name = "blend"
    }
    
}

public func blend(_ mode: BlendMode, _ pixA: VOX & NODEOut, _ pixB: VOX & NODEOut) -> BlendVOX {
    let blendPix = BlendVOX()
    blendPix.inputA = pixA
    blendPix.inputB = pixB
    blendPix.blendMode = mode
    return blendPix
}
