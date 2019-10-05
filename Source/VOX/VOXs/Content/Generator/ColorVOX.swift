//
//  ColorVOX.swift
//  VoxelKit
//
//  Created by Hexagons on 2019-10-05.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import LiveValues
import RenderKit

public class ColorVOX: VOXGenerator {
    
    override open var shaderName: String { return "contentGeneratorColorVOX" }
    
    // MARK: - Property Helpers
    
    override public var liveValues: [LiveValue] {
        return [super.color]
    }
    
    // MARK: - Life Cycle
    
    public required init(at resolution: Resolution3D) {
        super.init(at: resolution)
        name = "color"
    }
    
}
