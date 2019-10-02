//
//  GradientVOX.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import PixelKit

class GradientVOX: GradientPIX {
    
    override open var shader: String { return "contentGeneratorGradientVOX" }
    
    public var axis: Axis = .x { didSet { setNeedsRender() } }
    
    override var postUniforms: [CGFloat] {
        var uniforms = super.postUniforms
        uniforms.append(CGFloat(axis.index))
        return uniforms
    }
    
}
