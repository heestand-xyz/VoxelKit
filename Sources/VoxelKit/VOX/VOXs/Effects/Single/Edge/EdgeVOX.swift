//
//  EdgeVOX.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-08-06.
//  Open Source - MIT License
//

import RenderKit
import CoreGraphics

public class EdgeVOX: VOXSingleEffect {
    
    override open var shaderName: String { return "effectSingleEdgeVOX" }
    
    // MARK: - Public Properties
    
    @LiveFloat("strength", range: 0.0...10.0) public var strength: CGFloat = 1.0
    @LiveFloat("distance", range: 0.0...10.0) public var distance: CGFloat = 1.0
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        [_strength, _distance]
    }
    
    public override var values: [Floatable] {
        [strength, distance]
    }
    
    // MARK: - Life Cycle
    
    public required init() {
        super.init(name: "Edge", typeName: "vox-effect-single-edge")
        extend = .hold
    }
    
}

public extension NODEOut {
    
    func voxEdge(_ strength: CGFloat = 1.0) -> EdgeVOX {
        let edgePix = EdgeVOX()
        edgePix.name = ":edge:"
        edgePix.input = self as? VOX & NODEOut
        edgePix.strength = strength
        return edgePix
    }
    
}
