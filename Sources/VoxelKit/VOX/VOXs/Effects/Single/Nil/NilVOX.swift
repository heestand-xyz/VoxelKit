//
//  File.swift
//  
//
//  Created by Anton Heestand on 2021-06-29.
//

import Foundation
import RenderKit
import Resolution

final public class NilVOX: VOXSingleEffect {
    
    public typealias Model = NilVoxelModel
    
    private var model: Model {
        get { singleEffectModel as! Model }
        set { singleEffectModel = newValue }
    }
    
    override public var shaderName: String { return "nilVOX" }
    
    private var nilOverrideBits: Bits?
    public override var overrideBits: Bits? { nilOverrideBits }
    
    // MARK: - Life Cycle -
    
    public convenience init(overrideBits: Bits) {
        self.init()
        nilOverrideBits = overrideBits
    }
    
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
        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        super.liveUpdateModelDone()
    }
    
}

public extension NODEOut {
    
    /// bypass is `false` by *default*
    func voxNil(bypass: Bool = false) -> NilVOX {
        let nilPix = NilVOX()
        nilPix.name = ":nil:"
        nilPix.input = self as? VOX & NODEOut
        nilPix.bypass = bypass
        return nilPix
    }
    
}
