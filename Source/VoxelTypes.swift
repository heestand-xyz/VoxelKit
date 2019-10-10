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
    public var vertexIndecies: [Int]
    public var normalIndecies: [Int]
    public var uvIndecies: [Int]
    init(vertexIndecies: [Int] = [], normalIndecies: [Int] = [], uvIndecies: [Int] = []) {
        self.vertexIndecies = vertexIndecies
        self.normalIndecies = normalIndecies
        self.uvIndecies = uvIndecies
    }
}

public struct Geometry {
    public let vertecies: [Vector]
    public let normals: [Vector]
    public let uvs: [CGVector]
    public let polygons: [Polygon]
}
