//
//  ThresholdVOX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-17.
//  Open Source - MIT License
//

import LiveValues
import RenderKit
import CoreGraphics

public class ThresholdVOX: VOXSingleEffect {
    
    override open var shaderName: String { return "effectSingleThresholdVOX" }
    
    // MARK: - Public Properties
    
    public var threshold: LiveFloat = LiveFloat(0.5, limit: true)
    
    // MARK: - Property Helpers
    
    override public var liveValues: [LiveValue] {
        return [threshold]
    }
    
    public override var uniforms: [CGFloat] {
        return [threshold.uniform, 0.0]
    }
    
    // MARK: - Life Cycle
    
    public required init() {
        super.init()
        name = "threshold"
    }
    
}

public extension NODEOut {
    
    func _threshold(_ threshold: LiveFloat = 0.5) -> ThresholdVOX {
        let thresholdPix = ThresholdVOX()
        thresholdPix.name = ":threshold:"
        thresholdPix.input = self as? VOX & NODEOut
        thresholdPix.threshold = threshold
        return thresholdPix
    }
    
//    func _mask(low: LiveFloat, high: LiveFloat) -> BlendVOX {
//        let thresholdLowPix = ThresholdVOX()
//        thresholdLowPix.name = "mask:threshold:low"
//        thresholdLowPix.input = self as? VOX & NODEOut
//        thresholdLowPix.threshold = low
//        let thresholdHighPix = ThresholdVOX()
//        thresholdHighPix.name = "mask:threshold:high"
//        thresholdHighPix.input = self as? VOX & NODEOut
//        thresholdHighPix.threshold = high
//        return thresholdLowPix - thresholdHighPix
//    }
    
}
