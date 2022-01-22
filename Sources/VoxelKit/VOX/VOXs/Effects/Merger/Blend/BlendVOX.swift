//
//  BlendVOX.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-08-23.
//  Open Source - MIT License
//

import RenderKit
import CoreGraphics

public class BlendVOX: VOXMergerEffect {
    
    public typealias Model = BlendVoxelModel
    
    private var model: Model {
        get { mergerEffectModel as! Model }
        set { mergerEffectModel = newValue }
    }
    
    override open var shaderName: String { return "effectMergerBlendVOX" }
    
    // MARK: - Public Properties
    
    @LiveEnum("blendMode") public var blendMode: BlendMode = .add
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        super.liveList + [_blendMode]
    }
    
    open override var uniforms: [CGFloat] {
        return [CGFloat(blendMode.index)]
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
        
        blendMode = model.blendMode
        
        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        
        model.blendMode = blendMode
        
        super.liveUpdateModelDone()
    }
    
}

public func voxBlend(_ mode: BlendMode, _ voxA: VOX & NODEOut, _ voxB: VOX & NODEOut) -> BlendVOX {
    let blendPix = BlendVOX()
    blendPix.inputA = voxA
    blendPix.inputB = voxB
    blendPix.blendMode = mode
    return blendPix
}
