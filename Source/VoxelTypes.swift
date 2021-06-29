//
//  VoxelTypes.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit
import CoreGraphics

public enum Axis: String, Enumable {
    case x, y, z
    public var index: Int {
        switch self {
        case .x: return 0
        case .y: return 1
        case .z: return 2
        }
    }
    public var name: String { rawValue.uppercased() }
    public var typeName: String { rawValue }
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
