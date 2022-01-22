//
//  CrossVOX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-21.
//  Open Source - MIT License
//

import RenderKit
import CoreGraphics

public class CrossVOX: VOXMergerEffect {
    
    public typealias Model = CrossVoxelModel
    
    private var model: Model {
        get { mergerEffectModel as! Model }
        set { mergerEffectModel = newValue }
    }
    
    override open var shaderName: String { return "effectMergerCrossVOX" }
    
    // MARK: - Public Properties
    
    @LiveFloat("fraction") public var fraction: CGFloat = 0.5
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        super.liveList + [_fraction]
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
    
    func voxCross(vox: VOX & NODEOut, fraction: CGFloat) -> CrossVOX {
        let crossPix = CrossVOX()
        crossPix.name = ":cross:"
        crossPix.inputA = self as? VOX & NODEOut
        crossPix.inputB = vox
        crossPix.fraction = fraction
        return crossPix
    }
    
}

public func voxCross(_ voxA: VOX & NODEOut, _ voxB: VOX & NODEOut, at fraction: CGFloat) -> CrossVOX {
    let crossPix = CrossVOX()
    crossPix.name = ":cross:"
    crossPix.inputA = voxA
    crossPix.inputB = voxB
    crossPix.fraction = fraction
    return crossPix
}
