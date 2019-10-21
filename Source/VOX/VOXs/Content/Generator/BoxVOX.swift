//
//  BoxVOX.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-21.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import LiveValues
import RenderKit

public class BoxVOX: VOXGenerator {
    
    override open var shaderName: String { return "contentGeneratorBoxVOX" }
    
    // MARK: - Public Properties
    
    public var position: LiveVec = .zero
    public var size: LiveVec = LiveVec(0.5)
    public var edgeRadius: LiveFloat = 0.0
    public var edgeColor: LiveColor = .gray
    public var cornerRadius: LiveFloat = 0.0
    
    // MARK: - Property Helpers
    
    override public var liveValues: [LiveValue] {
        return [position, size, edgeRadius, cornerRadius, super.color, edgeColor, super.bgColor]
    }
    
    // MARK: - Life Cycle
    
    public required init(at resolution: Resolution3D) {
        super.init(at: resolution)
        name = "sphere"
    }
    
}
