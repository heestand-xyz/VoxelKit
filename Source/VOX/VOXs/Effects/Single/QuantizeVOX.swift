//
//  QuantizeVOX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-18.
//  Open Source - MIT License
//

import LiveValues
import RenderKit

public class QuantizeVOX: VOXSingleEffect {
    
    override open var shaderName: String { return "effectSingleQuantizeVOX" }
    
    // MARK: - Public Properties
    
    public var fraction: LiveFloat = LiveFloat(0.125, limit: true)
    
    // MARK: - Property Helpers
    
    override public var liveValues: [LiveValue] {
        return [fraction]
    }
    
    // MARK: - Life Cycle
    
    public required init() {
        super.init(name: "Quantize", typeName: "vox-effect-single-quantize")
    }
    
}

public extension NODEOut {
    
    func _quantize(_ fraction: LiveFloat) -> QuantizeVOX {
        let quantizePix = QuantizeVOX()
        quantizePix.name = ":quantize:"
        quantizePix.input = self as? VOX & NODEOut
        quantizePix.fraction = fraction
        return quantizePix
    }
    
}
