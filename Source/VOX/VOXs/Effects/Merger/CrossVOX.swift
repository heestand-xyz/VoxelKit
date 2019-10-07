//
//  CrossVOX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-21.
//  Open Source - MIT License
//

import LiveValues
import RenderKit

public class CrossVOX: VOXMergerEffect {
    
    override open var shaderName: String { return "effectMergerCrossVOX" }
    
    // MARK: - Public Properties
    
    public var fraction: LiveFloat = LiveFloat(0.5, limit: true)
    
    // MARK: - Property Helpers
    
    override public var liveValues: [LiveValue] {
        return [fraction]
    }
    
    // MARK: - Life Cycle
    
    public required init() {
        super.init()
        name = "cross"
    }
    
}

public extension NODEOut {
    
    func _cross(with vox: VOX & NODEOut, fraction: LiveFloat) -> CrossVOX {
        let crossPix = CrossVOX()
        crossPix.name = ":cross:"
        crossPix.inputA = self as? VOX & NODEOut
        crossPix.inputB = vox
        crossPix.fraction = fraction
        return crossPix
    }
    
}

public func cross(_ voxA: VOX & NODEOut, _ voxB: VOX & NODEOut, at fraction: LiveFloat) -> CrossVOX {
    let crossPix = CrossVOX()
    crossPix.name = ":cross:"
    crossPix.inputA = voxA
    crossPix.inputB = voxB
    crossPix.fraction = fraction
    return crossPix
}
