//
//  KaleidoscopeVOX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-18.
//  Open Source - MIT License
//

import LiveValues
import RenderKit

public class KaleidoscopeVOX: VOXSingleEffect {
    
    override open var shaderName: String { return "effectSingleKaleidoscopeVOX" }
    
    // MARK: - Public Properties
    
    public var divisions: LiveInt = LiveInt(12, min: 1, max: 24)
    public var mirror: LiveBool = true
    public var rotation: LiveFloat = LiveFloat(0.0, min: -0.5, max: 0.5)
    public var position: LiveVec = .zero
    public var axis: Axis = .z { didSet { setNeedsRender() } }
    
    // MARK: - Property Helpers
    
    override public var liveValues: [LiveValue] {
        [divisions, mirror, rotation, position]
    }
    
    public override var postUniforms: [CGFloat] {
        [CGFloat(axis.index)]
    }
    
    public required init() {
        super.init()
        extend = .mirror
        name = "kaleidoscope"
    }
    
}

public extension NODEOut {
    
    func _kaleidoscope(divisions: LiveInt = 12, mirror: LiveBool = true) -> KaleidoscopeVOX {
        let kaleidoscopePix = KaleidoscopeVOX()
        kaleidoscopePix.name = ":kaleidoscope:"
        kaleidoscopePix.input = self as? VOX & NODEOut
        kaleidoscopePix.divisions = divisions
        kaleidoscopePix.mirror = mirror
        return kaleidoscopePix
    }
    
}
