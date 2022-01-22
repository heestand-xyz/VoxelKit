//
//  LookupVOX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-18.
//  Open Source - MIT License
//

import RenderKit
import CoreGraphics

public class LookupVOX: VOXMergerEffect {
    
    public typealias Model = LookupVoxelModel
    
    private var model: Model {
        get { mergerEffectModel as! Model }
        set { mergerEffectModel = newValue }
    }
    
    override open var shaderName: String { return "effectMergerLookupVOX" }
    
    // MARK: - Public Properties
    
    var holdEdgeFraction: CGFloat {
        let axisRes: CGFloat
        switch axis {
        case .x: axisRes = renderedResolution3d.vector.x
        case .y: axisRes = renderedResolution3d.vector.y
        case .z: axisRes = renderedResolution3d.vector.z
        }
        return 1 / axisRes
    }
    
    @LiveEnum("axis") public var axis: Axis = .x
    @LiveBool("holdEdge") public var holdEdge: Bool = true
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        super.liveList + [_axis, _holdEdge]
    }
    
    open override var uniforms: [CGFloat] {
        [axis == .x ? 0 : 1, holdEdge ? 1 : 0, holdEdgeFraction]
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
        
        axis = model.axis
        holdEdge = model.holdEdge
        
        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        
        model.axis = axis
        model.holdEdge = holdEdge
        
        super.liveUpdateModelDone()
    }
    
}

public extension NODEOut {
    
    func voxLookup(vox: VOX & NODEOut, axis: Axis) -> LookupVOX {
        let lookupPix = LookupVOX()
        lookupPix.name = ":lookup:"
        lookupPix.inputA = self as? VOX & NODEOut
        lookupPix.inputB = vox
        lookupPix.axis = axis
        return lookupPix
    }
    
}
