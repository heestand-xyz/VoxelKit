//
//  TransformVOX.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-08-28.
//  Open Source - MIT License
//

import RenderKit
import CoreGraphics

public class TransformVOX: VOXSingleEffect {
    
    override open var shaderName: String { return "effectSingleTransformVOX" }
    
    // MARK: - Public Properties
    
    @LiveVector("position") public var position: SIMD3<Double> = .zero
    @LiveVector("rotation") public var rotation: SIMD3<Double> = .zero
    @LiveFloat("scale", range: 0.0...2.0) public var scale: CGFloat = 1.0
    @LiveVector("size") public var size: SIMD3<Double> = SIMD3<Double>(x: 1.0, y: 1.0, z: 1.0)
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        [_position, _rotation, _scale, _size]
    }
    
    public override var values: [Floatable] {
        [position, rotation, scale, size]
    }
    
    // MARK: - Life Cycle
    
    public required init() {
        super.init(name: "Transform", typeName: "vox-effect-single-transform")
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
}

public extension NODEOut {
    
    func voxMove(by position: SIMD3<Double>) -> TransformVOX {
        let transformVox = TransformVOX()
        transformVox.name = "position:transform"
        transformVox.input = self as? VOX & NODEOut
        transformVox.position = position
        return transformVox
    }
    
    func voxMove(x: CGFloat = 0.0, y: CGFloat = 0.0, z: CGFloat = 0.0) -> TransformVOX {
        return (self as! VOX & NODEOut).voxMove(by: SIMD3<Double>(x: x, y: y, z: z))
    }
    
    func voxRotatate(x: CGFloat, y: CGFloat, z: CGFloat) -> TransformVOX {
        let transformVox = TransformVOX()
        transformVox.name = "rotatate:transform"
        transformVox.input = self as? VOX & NODEOut
        transformVox.rotation = SIMD3<Double>(x: x, y: y, z: z)
        return transformVox
    }
    
    func voxRotatate(by rotation: CGFloat, on axis: Axis) -> TransformVOX {
        let transformVox = TransformVOX()
        transformVox.name = "rotatate:transform"
        transformVox.input = self as? VOX & NODEOut
        transformVox.rotation = SIMD3<Double>(x: axis == .x ? rotation : 0.0,
                                              y: axis == .y ? rotation : 0.0,
                                              z: axis == .z ? rotation : 0.0)
        return transformVox
    }
    
    func voxRotatate(by360 rotation: CGFloat, on axis: Axis) -> TransformVOX {
        return (self as! VOX & NODEOut).voxRotatate(by: rotation / 360, on: axis)
    }
    
    func voxRotatate(by2pi rotation: CGFloat, on axis: Axis) -> TransformVOX {
        return (self as! VOX & NODEOut).voxRotatate(by: rotation / (.pi * 2), on: axis)
    }
    
    func voxScale(by scale: CGFloat) -> TransformVOX {
        let transformVox = TransformVOX()
        transformVox.name = "scale:transform"
        transformVox.input = self as? VOX & NODEOut
        transformVox.scale = scale
        return transformVox
    }
    
    func voxScale(size: SIMD3<Double>) -> TransformVOX {
        let transformVox = TransformVOX()
        transformVox.name = "scale:transform"
        transformVox.input = self as? VOX & NODEOut
        transformVox.size = size
        return transformVox
    }
    
    func voxScale(x: CGFloat = 1.0, y: CGFloat = 1.0, z: CGFloat = 1.0) -> TransformVOX {
        return voxScale(size: SIMD3<Double>(x: x, y: y, z: z))
    }
    
}
