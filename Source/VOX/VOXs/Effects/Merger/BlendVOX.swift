//
//  BlendVOX.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-08-23.
//  Open Source - MIT License
//

import LiveValues
import RenderKit
import CoreGraphics

public class BlendVOX: VOXMergerEffect {
    
    override open var shaderName: String { return "effectMergerBlendVOX" }
    
    // MARK: - Public Properties
    
    public var blendMode: BlendMode = .add { didSet { setNeedsRender() } }
    
    // MARK: - Property Helpers
    
    open override var uniforms: [CGFloat] {
        return [CGFloat(blendMode.index)]
    }
    
    public required init() {
        super.init(name: "Blend", typeName: "vox-effect-merger-blend")
    }
    
}

public func blend(_ mode: BlendMode, _ voxA: VOX & NODEOut, _ voxB: VOX & NODEOut) -> BlendVOX {
    let blendPix = BlendVOX()
    blendPix.inputA = voxA
    blendPix.inputB = voxB
    blendPix.blendMode = mode
    return blendPix
}
