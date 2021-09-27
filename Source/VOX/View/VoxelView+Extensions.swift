//
//  File.swift
//  
//
//  Created by Anton Heestand on 2021-09-25.
//

import Foundation
import simd
import ModelIO

struct InstanceConstants {
    var modelViewProjectionMatrix: float4x4
    var normalMatrix: float4x4
    var color: SIMD4<Float>
}

func radians_from_degrees(_ degrees: Float) -> Float {
    return (degrees / 180) * .pi
}

extension MDLVertexDescriptor {
    var vertexAttributes: [MDLVertexAttribute] {
        return attributes as! [MDLVertexAttribute]
    }
    var bufferLayouts: [MDLVertexBufferLayout] {
        return layouts as! [MDLVertexBufferLayout]
    }
}

extension SIMD4 where Scalar == Float {
    
    init(_ v: SIMD3<Float>, _ w: Float) {
        self.init(x: v.x, y: v.y, z: v.z, w: w)
    }
    
    var xyz: SIMD3<Float> {
        return SIMD3<Float>(x, y, z)
    }
}

extension float4x4 {
    
    init(rotationAroundAxis axis: SIMD3<Float>, by angle: Float) {
        let unitAxis = normalize(axis)
        let ct = cosf(angle)
        let st = sinf(angle)
        let ci = 1 - ct
        let x = unitAxis.x, y = unitAxis.y, z = unitAxis.z
        self.init(columns:(SIMD4<Float>(    ct + x * x * ci, y * x * ci + z * st, z * x * ci - y * st, 0),
                           SIMD4<Float>(x * y * ci - z * st,     ct + y * y * ci, z * y * ci + x * st, 0),
                           SIMD4<Float>(x * z * ci + y * st, y * z * ci - x * st,     ct + z * z * ci, 0),
                           SIMD4<Float>(                  0,                   0,                   0, 1)))
    }
    
    init(translationBy v: SIMD3<Float>) {
        self.init(columns:(SIMD4<Float>(1, 0, 0, 0),
                           SIMD4<Float>(0, 1, 0, 0),
                           SIMD4<Float>(0, 0, 1, 0),
                           SIMD4<Float>(v.x, v.y, v.z, 1)))
    }
    
    init(perspectiveProjectionRHFovY fovy: Float, aspectRatio: Float, nearZ: Float, farZ: Float) {
        let ys = 1 / tanf(fovy * 0.5)
        let xs = ys / aspectRatio
        let zs = farZ / (nearZ - farZ)
        self.init(columns:(SIMD4<Float>(xs,  0, 0,   0),
                           SIMD4<Float>( 0, ys, 0,   0),
                           SIMD4<Float>( 0,  0, zs, -1),
                           SIMD4<Float>( 0,  0, zs * nearZ, 0)))
    }
}
