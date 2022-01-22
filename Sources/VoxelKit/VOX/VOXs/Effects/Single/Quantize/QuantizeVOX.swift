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
    
    public typealias Model = QuantizeVoxelModel
    
    private var model: Model {
        get { singleEffectModel as! Model }
        set { singleEffectModel = newValue }
    }
    
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
        
        fraction = model.fraction
        
        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        
        model.fraction = fraction
        
        super.liveUpdateModelDone()
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
