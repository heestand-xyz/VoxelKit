//
//  ColorVOX.swift
//  VoxelKit
//
//  Created by Hexagons on 2019-10-05.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit
import CoreGraphics
import Resolution

public class ColorVOX: VOXGenerator {
    
    override open var shaderName: String { return "contentGeneratorColorVOX" }
    
    // MARK: - Property Helpers
    
    public override var values: [Floatable] {
        [super.color]
    }
    
    // MARK: - Life Cycle
    
    public required init(at resolution: Resolution3D) {
        super.init(at: resolution, name: "Color", typeName: "vox-content-generator-color")
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
}
