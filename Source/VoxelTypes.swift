//
//  VoxelTypes.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit

public enum Axis {
    case x
    case y
    case z
    var index: Int {
        switch self {
        case .x: return 0
        case .y: return 1
        case .z: return 2
        }
    }
}

public struct Polygon {
    var vertexIndecies: [Int]
    var normalIndecies: [Int]
    var uvIndecies: [Int]
    init(vertexIndecies: [Int] = [], normalIndecies: [Int] = [], uvIndecies: [Int] = []) {
        self.vertexIndecies = vertexIndecies
        self.normalIndecies = normalIndecies
        self.uvIndecies = uvIndecies
    }
}

public struct Geometry {
    let vertecies: [Vector]
    let normals: [Vector]
    let uvs: [CGVector]
    let polygons: [Polygon]
}
