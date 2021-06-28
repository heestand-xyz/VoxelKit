//
//  TransformVOX.swift
//  VoxelKit
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
    public var rotation: LiveVec = .zero
    public var scale: LiveFloat = LiveFloat(1.0, max: 2.0)
    public var size: LiveVec = LiveVec(x: 1.0, y: 1.0, z: 1.0)
    
    // MARK: - Property Helpers
    
    override public var liveValues: [LiveValue] {
        return [position, rotation, scale, size]
    }
    
    // MARK: - Life Cycle
    
    public required init() {
        super.init(name: "Transform", typeName: "vox-effect-single-transform")
    }
      
}

public extension NODEOut {
    
    func _move(by position: LiveVec) -> TransformVOX {
        let transformVox = TransformVOX()
        transformVox.name = "position:transform"
        transformVox.input = self as? VOX & NODEOut
        transformVox.position = position
        return transformVox
    }
    
    func _move(x: LiveFloat = 0.0, y: LiveFloat = 0.0, z: LiveFloat = 0.0) -> TransformVOX {
        return (self as! VOX & NODEOut)._move(by: LiveVec(x: x, y: y, z: z))
    }
    
    func _rotatate(x: LiveFloat, y: LiveFloat, z: LiveFloat) -> TransformVOX {
        let transformVox = TransformVOX()
        transformVox.name = "rotatate:transform"
        transformVox.input = self as? VOX & NODEOut
        transformVox.rotation = LiveVec(x: x, y: y, z: z)
        return transformVox
    }
    
    func _rotatate(by rotation: LiveFloat, on axis: Axis) -> TransformVOX {
        let transformVox = TransformVOX()
        transformVox.name = "rotatate:transform"
        transformVox.input = self as? VOX & NODEOut
        transformVox.rotation = LiveVec(x: axis == .x ? rotation : 0.0,
                                        y: axis == .y ? rotation : 0.0,
                                        z: axis == .z ? rotation : 0.0)
        return transformVox
    }
    
    func _rotatate(by360 rotation: LiveFloat, on axis: Axis) -> TransformVOX {
        return (self as! VOX & NODEOut)._rotatate(by: rotation / 360, on: axis)
    }
    
    func _rotatate(by2pi rotation: LiveFloat, on axis: Axis) -> TransformVOX {
        return (self as! VOX & NODEOut)._rotatate(by: rotation / (.pi * 2), on: axis)
    }
    
    func _scale(by scale: LiveFloat) -> TransformVOX {
        let transformVox = TransformVOX()
        transformVox.name = "scale:transform"
        transformVox.input = self as? VOX & NODEOut
        transformVox.scale = scale
        return transformVox
    }
    
    func _scale(size: LiveVec) -> TransformVOX {
        let transformVox = TransformVOX()
        transformVox.name = "scale:transform"
        transformVox.input = self as? VOX & NODEOut
        transformVox.size = size
        return transformVox
    }
    
    func _scale(x: LiveFloat = 1.0, y: LiveFloat = 1.0, z: LiveFloat = 1.0) -> TransformVOX {
        return _scale(size: LiveVec(x: x, y: y, z: z))
    }
    
}
