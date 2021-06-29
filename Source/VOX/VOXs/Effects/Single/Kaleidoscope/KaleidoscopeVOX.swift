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
    
    override open var shaderName: String { return "effectSingleKaleidoscopeVOX" }
    
    // MARK: - Public Properties
    
    @LiveInt("divisions", range: 1...24) public var divisions: Int = 12
    @LiveBool("mirror") public var mirror: Bool = true
    @LiveFloat("rotation", range: -0.5...0.5) public var rotation: CGFloat = 0.0
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
    
    public required init() {
        super.init(name: "Kaleidoscope", typeName: "vox-effect-single-kaleidoscope")
        extend = .mirror
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
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
