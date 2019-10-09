//
//  ObjectVOX.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-09.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit

public class ObjectVOX: VOXResource {
    
    override open var shaderName: String { return "nilVOX" }
    
    public var geometry: Geometry?
    
    public override var uniformArray: [[CGFloat]] {
        
    }
    public override var uniformArrayMaxLimit: Int { 10_000 }
    
    public init(name: String) {
        
        super.init()
        
        load(name)
        
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
        let rows = text.split(separator: "\n")
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
        geometry = Geometry(vertecies: verts, normals: norms, uvs: coords, polygons: polys)
    }
    
}
