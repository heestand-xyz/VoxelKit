//
//  ObjectVOX.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-09.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import Foundation
import RenderKit
import CoreGraphics
import Resolution

public class ObjectVOX: VOXResource {
    
    override open var shaderName: String { return "contentResourceObjectVOX" }
    
    public var geometry: Geometry? { didSet { render() } }
    
    public enum Mode: String, Enumable {
        case solid
        case edge
        public var index: Int {
            switch self {
            case .solid: return 0
            case .edge: return 1
            }
        }
        public var name: String {
            switch self {
            case .solid:
                return "Solid"
            case .edge:
                return "Edge"
            }
        }
        public var typeName: String { rawValue }
    }
    @LiveEnum("mode") public var mode: Mode = .edge
    
    var minVertex: Vector {
        guard let geo = geometry else { return Vector(x: 0.0, y: 0.0, z: 0.0) }
        guard !geo.vertecies.isEmpty else { return Vector(x: 0.0, y: 0.0, z: 0.0) }
        var x: CGFloat?
        var y: CGFloat?
        var z: CGFloat?
        for vertex in geo.vertecies {
            if x == nil {
                x = vertex.x
                y = vertex.y
                z = vertex.z
            } else {
                if vertex.x < x! {
                    x = vertex.x
                }
                if vertex.y < y! {
                    y = vertex.y
                }
                if vertex.z < z! {
                    z = vertex.z
                }
            }
        }
        return Vector(x: x!, y: y!, z: z!)
    }
    
    var maxVertex: Vector {
        guard let geo = geometry else { return Vector(x: 0.0, y: 0.0, z: 0.0) }
        guard !geo.vertecies.isEmpty else { return Vector(x: 0.0, y: 0.0, z: 0.0) }
        var x: CGFloat?
        var y: CGFloat?
        var z: CGFloat?
        for vertex in geo.vertecies {
            if x == nil {
                x = vertex.x
                y = vertex.y
                z = vertex.z
            } else {
                if vertex.x > x! {
                    x = vertex.x
                }
                if vertex.y > y! {
                    y = vertex.y
                }
                if vertex.z > z! {
                    z = vertex.z
                }
            }
        }
        return Vector(x: x!, y: y!, z: z!)
    }
    
    var centerVertex: Vector {
        Vector(x: (maxVertex.x + minVertex.x) / 2,
               y: (maxVertex.y + minVertex.y) / 2,
               z: (maxVertex.z + minVertex.z) / 2)
    }
    
    var scaleVertex: Vector {
        Vector(x: maxVertex.x - minVertex.x,
               y: maxVertex.y - minVertex.y,
               z: maxVertex.z - minVertex.z)
    }
    
    var translation: Vector {
        Vector(x: -centerVertex.x,
               y: -centerVertex.y,
               z: -centerVertex.z)
    }
    
    public var scale: CGFloat = 1.0
    var transformScale: CGFloat {
        let x = (1.0 / scaleVertex.x) * scale
        let y = (1.0 / scaleVertex.y) * scale
        let z = (1.0 / scaleVertex.z) * scale
        return min(x, y, z)
    }
    
    public override var liveList: [LiveWrap] {
        super.liveList + [_mode]
    }
    
    // MARK: - Uniforms
    
    public override var uniforms: [CGFloat] {
        [CGFloat(mode.index), translation.x, translation.y, translation.z, transformScale, CGFloat(geometry?.vertecies.count ?? 0), CGFloat(geometry?.polygons.count ?? 0)]
    }
    
    // MARK: - Uniform Arrays
    
    public override var uniformArray: [[CGFloat]] {
        geometry?.vertecies.map({ vector -> [CGFloat] in
            [vector.x, vector.y, vector.z]
        }) ?? []
    }
    public override var uniformArrayMaxLimit: Int? { 10_000 }
    
    public override var uniformArrayLength: Int? { 3 }

    public override var uniformIndexArray: [[Int]] {
        geometry?.polygons.map({ polygon -> [Int] in
            polygon.vertexIndecies
        }) ?? []
    }
    public override var uniformIndexArrayMaxLimit: Int? { 10_000 }
    
    // MARK: - Life Cycle
    
    public init(at resolution: Resolution3D, fileName: String) {
        super.init(at: resolution, name: "Object", typeName: "vox-content-resource-object")
        load(fileName)
    }
    
    public required init(at resolution: Resolution3D) {
        super.init(at: resolution, name: "Object", typeName: "vox-content-resource-object")
        self.name = "object"
        geometry = Geometry(vertecies: [
            Vector(x: 0.0, y: 0.0, z: 0.0),
            Vector(x: 1.0, y: 0.0, z: 0.0),
            Vector(x: 0.5, y: 1.0, z: 0.0),
            Vector(x: 0.5, y: 0.5, z: 1.0)
        ], normals: [], uvs: [], polygons: [
            Polygon(vertexIndecies: [0, 1, 2], normalIndecies: [], uvIndecies: []),
            Polygon(vertexIndecies: [0, 1, 3], normalIndecies: [], uvIndecies: []),
            Polygon(vertexIndecies: [1, 2, 3], normalIndecies: [], uvIndecies: []),
            Polygon(vertexIndecies: [0, 2, 3], normalIndecies: [], uvIndecies: [])
        ])
        render()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    func load(_ name: String) {
        guard let url = find(name) else {
            VoxelKit.main.logger.log(node: self, .error, .resource, "url of .obj file named \"\(name)\" could not be loaded.")
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            VoxelKit.main.logger.log(node: self, .error, .resource, "data of .obj file named \"\(name)\" could not be loaded.")
            return
        }
        guard let text = String(data: data, encoding: .utf8) else {
            VoxelKit.main.logger.log(node: self, .error, .resource, "content of .obj file named \"\(name)\" could not be loaded.")
            return
        }
        parse(text)
    }
    
    func find(_ name: String) -> URL? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "obj") else {
            VoxelKit.main.logger.log(node: self, .error, .resource, ".obj file named \"\(name)\" could not be found.")
            return nil
        }
        return url
    }
    
    func parse(_ text: String) {
        let rows = text.split { $0.isNewline }
        var verts: [Vector] = []
        var norms: [Vector] = []
        var coords: [CGVector] = []
        var polys: [Polygon] = []
        for row in rows {
            if row.starts(with: "f") {
                let content = row.split(separator: " ").dropFirst().map({ subText -> [Int?] in
                    let subSubTexts = subText.split(separator: "/", maxSplits: 3, omittingEmptySubsequences: false)
                    return subSubTexts.map { subSubText -> Int? in
                        Int(subSubText)
                    }
                })
                var polygon = Polygon()
                for subContent in content {
                    guard subContent.count >= 1 else { continue }
                    if let val = subContent[0] {
                        polygon.vertexIndecies.append(val - 1)
                    }
                    guard subContent.count >= 2 else { continue }
                    if let val = subContent[1] {
                        polygon.uvIndecies.append(val - 1)
                    }
                    guard subContent.count >= 3 else { continue }
                    if let val = subContent[2] {
                        polygon.normalIndecies.append(val - 1)
                    }
                }
                polys.append(polygon)
            } else {
                let content = row.split(separator: " ").dropFirst().map { subText -> CGFloat? in
                    guard let val = Double(subText) else { return nil }
                    return CGFloat(val)
                }
                guard !content.contains(nil) else { continue }
                if row.starts(with: "v") {
                    guard content.count >= 3 else { continue }
                    verts.append(Vector(x: content[0]!, y: content[1]!, z: content[2]!))
                } else if row.starts(with: "vn") {
                    guard content.count >= 3 else { continue }
                    norms.append(Vector(x: content[0]!, y: content[1]!, z: content[2]!))
                } else if row.starts(with: "vt") {
                    guard content.count >= 2 else { continue }
                    coords.append(CGVector(dx: content[0]!, dy: content[1]!))
                }
            }
        }
        guard !verts.isEmpty && !polys.isEmpty else {
            VoxelKit.main.logger.log(node: self, .error, .resource, ".obj file could not be parsed.")
            return
        }
        VoxelKit.main.logger.log(node: self, .detail, .resource, ".obj file has \(verts.count) vertecies and \(polys.count) polygons.")
        geometry = Geometry(vertecies: verts, normals: norms, uvs: coords, polygons: polys)
    }
    
}
