//
//  ThresholdVOX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-17.
//  Open Source - MIT License
//

import RenderKit
import CoreGraphics

public class ThresholdVOX: VOXSingleEffect {
    
    override open var shaderName: String { return "effectSingleThresholdVOX" }
    
    // MARK: - Public Properties
    
    @LiveFloat("threshold") public var threshold: CGFloat = 0.5
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        [_threshold]
    }
    
    public override var uniforms: [CGFloat] {
        [threshold, 0.0]
    }
    
    // MARK: - Life Cycle
    
    public required init() {
        super.init(name: "Threshold", typeName: "vox-effect-single-threshold")
    }
    
}

public extension NODEOut {
    
    func _threshold(_ threshold: CGFloat = 0.5) -> ThresholdVOX {
        let thresholdPix = ThresholdVOX()
        thresholdPix.name = ":threshold:"
        thresholdPix.input = self as? VOX & NODEOut
        thresholdPix.threshold = threshold
        return thresholdPix
    }
    
}
