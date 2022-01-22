//
//  ResolutionVOX.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-08-03.
//  Open Source - MIT License
//

import RenderKit
import CoreGraphics
import Resolution

@available(iOS 11.3, *)
public class ResolutionVOX: VOXSingleEffect, NODEResolution3D/*, CustomRenderDelegate*/ {

    public typealias Model = ResolutionVoxelModel
    
    private var model: Model {
        get { singleEffectModel as! Model }
        set { singleEffectModel = newValue }
    }
    
    override open var shaderName: String { return "effectSingleResolutionVOX" }
    
    // MARK: - Public Properties
    
    @LiveResolution3D("resolution") public var resolution: Resolution3D = .cube(8)
    
    public override var liveList: [LiveWrap] {
        [_resolution]
    }
    
    // MARK: - Life Cycle -
    
    public init(model: Model) {
        super.init(model: model)
    }
    
    public required init() {
        let model = Model()
        super.init(model: model)
    }
    
    required public init(at resolution: Resolution3D) {
        self.resolution = resolution
        let model = Model(resolution: resolution)
        super.init(model: model)
    }
    
    // MARK: - Live Model
    
    public override func modelUpdateLive() {
        super.modelUpdateLive()
        
        resolution = model.resolution
        
        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        
        model.resolution = resolution
        
        super.liveUpdateModelDone()
    }
    
}

@available(iOS 11.3, *)
public extension NODEOut {
    
    func _reRes(to resolution: Resolution3D) -> ResolutionVOX {
        let resPix = ResolutionVOX(at: resolution)
        resPix.name = "reRes:res"
        resPix.input = self as? VOX & NODEOut
        return resPix
    }
    
}
