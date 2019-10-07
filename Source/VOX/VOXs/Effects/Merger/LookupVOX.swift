//
//  LookupVOX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-18.
//  Open Source - MIT License
//

import RenderKit
import CoreGraphics

public class LookupVOX: VOXMergerEffect {
    
    override open var shaderName: String { return "effectMergerLookupVOX" }
    
    // MARK: - Public Properties
    
    var holdEdgeFraction: CGFloat {
        let axisRes: CGFloat
        switch axis {
        case .x: axisRes = renderedResolution3d.vector.x
        case .y: axisRes = renderedResolution3d.vector.y
        case .z: axisRes = renderedResolution3d.vector.z
        }
        return 1 / axisRes
    }
    
    public var axis: Axis = .x { didSet { setNeedsRender() } }
    public var holdEdge: Bool = true { didSet { setNeedsRender() } }
    
    // MARK: - Property Helpers
    
    open override var uniforms: [CGFloat] {
        return [axis == .x ? 0 : 1, holdEdge ? 1 : 0, holdEdgeFraction]
    }
    
    // MARK: - Life Cycle
    
    public required init() {
        super.init()
        name = "lookup"
    }
    
}

public extension NODEOut {
    
    func _lookup(with pix: VOX & NODEOut, axis: Axis) -> LookupVOX {
        let lookupPix = LookupVOX()
        lookupPix.name = ":lookup:"
        lookupPix.inputA = self as? VOX & NODEOut
        lookupPix.inputB = pix
        lookupPix.axis = axis
        return lookupPix
    }
    
}
