//
//  EdgeVOX.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-08-06.
//  Open Source - MIT License
//

import LiveValues
import RenderKit

public class EdgeVOX: VOXSingleEffect {
    
    override open var shaderName: String { return "effectSingleEdgeVOX" }
    
    // MARK: - Public Properties
    
    public var strength: LiveFloat = LiveFloat(1.0, min: 0.0, max: 10.0)
    public var distance: LiveFloat = LiveFloat(1.0, min: 0.0, max: 10.0)
    
    // MARK: - Property Helpers
    
    override public var liveValues: [LiveValue] {
        return [strength, distance]
    }
    
    // MARK: - Life Cycle
    
    public required init() {
        super.init()
        name = "edge"
        extend = .hold
    }
    
}

public extension NODEOut {
    
    func _edge(_ strength: LiveFloat = 1.0) -> EdgeVOX {
        let edgePix = EdgeVOX()
        edgePix.name = ":edge:"
        edgePix.input = self as? VOX & NODEOut
        edgePix.strength = strength
        return edgePix
    }
    
}
