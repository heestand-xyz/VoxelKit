//
//  QuantizeVOX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-18.
//  Open Source - MIT License
//

import RenderKit
import CoreGraphics

public class QuantizeVOX: VOXSingleEffect {
    
    override open var shaderName: String { return "effectSingleQuantizeVOX" }
    
    // MARK: - Public Properties
    
    @LiveFloat("fraction") public var fraction: CGFloat = 0.125
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        [_fraction]
    }
    
    public override var values: [Floatable] {
        [fraction]
    }
    
    // MARK: - Life Cycle -
    
    public required init() {
        super.init(name: "Quantize", typeName: "vox-effect-single-quantize")
    }
    
}

public extension NODEOut {
    
    func voxQuantize(_ fraction: CGFloat) -> QuantizeVOX {
        let quantizePix = QuantizeVOX()
        quantizePix.name = ":quantize:"
        quantizePix.input = self as? VOX & NODEOut
        quantizePix.fraction = fraction
        return quantizePix
    }
    
}
