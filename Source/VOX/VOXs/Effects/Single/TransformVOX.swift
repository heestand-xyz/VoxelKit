//
//  TransformVOX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-28.
//  Open Source - MIT License
//

import LiveValues
import RenderKit

public class TransformVOX: VOXSingleEffect {
    
    override open var shaderName: String { return "effectSingleTransformVOX" }
    
    // MARK: - Public Properties
    
    public var position: LiveVec = .zero
    public var scale: LiveFloat = LiveFloat(1.0, max: 2.0)
    public var size: LiveVec = LiveVec(x: 1.0, y: 1.0, z: 1.0)
    
    // MARK: - Property Helpers
    
    override public var liveValues: [LiveValue] {
        return [position, scale, size]
    }
    
    // MARK: - Life Cycle
    
    public required init() {
        super.init()
        name = "transform"
    }
      
}

public extension NODEOut {
    
    func _move(by position: LiveVec) -> TransformVOX {
        let transformPix = TransformVOX()
        transformPix.name = "position:transform"
        transformPix.input = self as? VOX & NODEOut
        transformPix.position = position
        return transformPix
    }
    
    func _move(x: LiveFloat = 0.0, y: LiveFloat = 0.0, z: LiveFloat = 0.0) -> TransformVOX {
        return (self as! VOX & NODEOut)._move(by: LiveVec(x: x, y: y, z: z))
    }
    
    func _scale(by scale: LiveFloat) -> TransformVOX {
        let transformPix = TransformVOX()
        transformPix.name = "scale:transform"
        transformPix.input = self as? VOX & NODEOut
        transformPix.scale = scale
        return transformPix
    }
    
    func _scale(size: LiveVec) -> TransformVOX {
        let transformPix = TransformVOX()
        transformPix.name = "scale:transform"
        transformPix.input = self as? VOX & NODEOut
        transformPix.size = size
        return transformPix
    }
    
    func _scale(x: LiveFloat = 1.0, y: LiveFloat = 1.0, z: LiveFloat = 1.0) -> TransformVOX {
        return _scale(size: LiveVec(x: x, y: y, z: z))
    }
    
}
