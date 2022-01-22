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
    
    public typealias Model = ThresholdVoxelModel
    
    private var model: Model {
        get { singleEffectModel as! Model }
        set { singleEffectModel = newValue }
    }
    
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
    
    // MARK: - Life Cycle -
    
    public init(model: Model) {
        super.init(model: model)
    }
    
    public required init() {
        let model = Model()
        super.init(model: model)
    }
    
    // MARK: - Live Model
    
    public override func modelUpdateLive() {
        super.modelUpdateLive()
        
        threshold = model.threshold
        
        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        
        model.threshold = threshold
        
        super.liveUpdateModelDone()
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
