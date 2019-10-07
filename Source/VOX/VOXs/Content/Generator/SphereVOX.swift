//
//  SphereVOX.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-07.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import LiveValues
import RenderKit

public class SphereVOX: VOXGenerator {
    
    override open var shaderName: String { return "contentGeneratorSphereVOX" }
    
    // MARK: - Public Properties
    
    public var radius: LiveFloat = LiveFloat(0.5, max: 0.5)
    public var position: LiveVec = .zero
    public var edgeRadius: LiveFloat = LiveFloat(0.0, max: 0.25)
    public var edgeColor: LiveColor = .gray
    
    // MARK: - Property Helpers
    
    override public var liveValues: [LiveValue] {
        return [radius, position, edgeRadius, super.color, edgeColor, super.bgColor]
    }
    
    // MARK: - Life Cycle
    
    public required init(at resolution: Resolution3D) {
        super.init(at: resolution)
        name = "sphere"
    }
    
}
