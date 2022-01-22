//
//  KaleidoscopeVOX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-18.
//  Open Source - MIT License
//

import RenderKit
import CoreGraphics
import simd

public class KaleidoscopeVOX: VOXSingleEffect {
    
    public typealias Model = KaleidoscopeVoxelModel
    
    private var model: Model {
        get { singleEffectModel as! Model }
        set { singleEffectModel = newValue }
    }
    
    override open var shaderName: String { return "effectSingleKaleidoscopeVOX" }
    
    // MARK: - Public Properties
    
    @LiveInt("divisions", range: 1...24) public var divisions: Int = 12
    @LiveBool("mirror") public var mirror: Bool = true
    @LiveFloat("rotation", range: -0.5...0.5, increment: 0.125) public var rotation: CGFloat = 0.0
    @LiveVector("position") public var position: SIMD3<Double> = .zero
    @LiveEnum("axis") public var axis: Axis = .z
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        [_divisions, _mirror, _rotation, _position, _axis]
    }
    
    public override var values: [Floatable] {
        [divisions, mirror, rotation, position]
    }
    
    public override var extraUniforms: [CGFloat] {
        [CGFloat(axis.index)]
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
        
        divisions = model.divisions
        mirror = model.mirror
        rotation = model.rotation
        position = model.position
        axis = model.axis
        
        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        
        model.divisions = divisions
        model.mirror = mirror
        model.rotation = rotation
        model.position = position
        model.axis = axis
        
        super.liveUpdateModelDone()
    }
    
}

public extension NODEOut {
    
    func _kaleidoscope(divisions: Int = 12, mirror: Bool = true) -> KaleidoscopeVOX {
        let kaleidoscopePix = KaleidoscopeVOX()
        kaleidoscopePix.name = ":kaleidoscope:"
        kaleidoscopePix.input = self as? VOX & NODEOut
        kaleidoscopePix.divisions = divisions
        kaleidoscopePix.mirror = mirror
        return kaleidoscopePix
    }
    
}
