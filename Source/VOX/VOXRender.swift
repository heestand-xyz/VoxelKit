//
//  VOXRender.swift
//  CocoaAsyncSocket
//
//  Created by Hexagons on 2019-10-06.
//

import LiveValues
import RenderKit
import simd

public extension VOX {
    
    var renderedTexture: MTLTexture? { return texture }
    
    var renderedRaw8: [UInt8]? {
        guard let texture = renderedTexture else { return nil }
        do {
            return try Texture.raw3d8(texture: texture)
        } catch {
            VoxelKit.main.logger.log(node: self, .error, .texture, "Raw 8 Bit texture failed.", e: error)
            return nil
        }
    }
    
    var renderedRaw16: [Float]? {
        guard let texture = renderedTexture else { return nil }
        do {
            return try Texture.raw3d16(texture: texture)
        } catch {
            VoxelKit.main.logger.log(node: self, .error, .texture, "Raw 16 Bit texture failed.", e: error)
            return nil
        }
    }
    
    var renderedRaw32: [float4]? {
        guard let texture = renderedTexture else { return nil }
        do {
            return try Texture.raw3d32(texture: texture)
        } catch {
            VoxelKit.main.logger.log(node: self, .error, .texture, "Raw 32 Bit texture failed.", e: error)
            return nil
        }
    }
    
    var renderedRawNormalized: [CGFloat]? {
        guard let texture = renderedTexture else { return nil }
        do {
            return try Texture.rawNormalized3d(texture: texture, bits: VoxelKit.main.render.bits)
        } catch {
            VoxelKit.main.logger.log(node: self, .error, .texture, "Raw Normalized texture failed.", e: error)
            return nil
        }
    }
    
    struct VoxelPack {
        public let resolution: Resolution3D
        public let raw: [[[Voxel]]]
        public func voxel(x: Int, y: Int, z: Int) -> Voxel {
            return raw[z][y][x]
        }
        public func voxel(uvw: Vector) -> Voxel {
            let xMax = resolution.vector.x - 1
            let yMax = resolution.vector.y - 1
            let zMax = resolution.vector.z - 1
            let x = max(0, min(Int(round(uvw.x * xMax + 0.5)), Int(xMax)))
            let y = max(0, min(Int(round(uvw.y * yMax + 0.5)), Int(yMax)))
            let z = max(0, min(Int(round(uvw.z * zMax + 0.5)), Int(zMax)))
            return voxel(pos: Vector(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z)))
        }
        public func voxel(pos: Vector) -> Voxel {
            let xMax = resolution.vector.x - 1
            let yMax = resolution.vector.y - 1
            let zMax = resolution.vector.z - 1
            let x = max(0, min(Int(round(pos.x)), Int(xMax)))
            let y = max(0, min(Int(round(pos.y)), Int(yMax)))
            let z = max(0, min(Int(round(pos.z)), Int(zMax)))
            return raw[y][x][z]
        }
        public var average: LiveColor {
            var color: LiveColor!
            for row in raw {
                for col in row {
                    for vx in col {
                        guard color != nil else {
                            color = vx.color
                            continue
                        }
                        color += vx.color
                    }
                }
            }
            color /= LiveFloat(CGFloat(resolution.count))
            return color
        }
        public var maximum: LiveColor {
            var color: LiveColor!
            for row in raw {
                for col in row {
                    for vx in col {
                        guard color != nil else {
                            color = vx.color
                            continue
                        }
                        if Bool(vx.color > color!) {
                            color = vx.color
                        }
                    }
                }
            }
            return color
        }
        public var minimum: LiveColor {
            var color: LiveColor!
            for row in raw {
                for col in row {
                    for vx in col {
                        guard color != nil else {
                            color = vx.color
                            continue
                        }
                        if Bool(vx.color < color!) {
                            color = vx.color
                        }
                    }
                }
            }
            return color
        }
    }
    
    var renderedVoxels: VoxelPack? {
        guard let resolution = realResolution else {
            VoxelKit.main.logger.log(node: self, .error, .texture, "Rendered voxels failed. Resolution not found.")
            return nil
        }
        guard let rawVoxels = renderedRawNormalized else {
            VoxelKit.main.logger.log(node: self, .error, .texture, "Rendered voxels failed. Voxels not found.")
            return nil
        }
        var voxels: [[[Voxel]]] = []
        let rx = Int(resolution.vector.x)
        let ry = Int(resolution.vector.y)
        let rz = Int(resolution.vector.z)
        for z in 0..<rz {
            let w = (CGFloat(z) + 0.5) / CGFloat(rz)
            var voxelCol: [[Voxel]] = []
            for y in 0..<ry {
                let v = (CGFloat(y) + 0.5) / CGFloat(ry)
                var voxelRow: [Voxel] = []
                for x in 0..<rx {
                    let u = (CGFloat(x) + 0.5) / CGFloat(rx)
                    var c: [CGFloat] = []
                    for i in 0..<4 {
                        let j = (z * rx * ry * 4) + (y * ry * 4) + (x * 4) + i
                        guard j < rawVoxels.count else { return nil }
                        let chan = rawVoxels[j]
                        c.append(chan)
                    }
                    let color = LiveColor(c)
                    let uvw = Vector(x: u, y: v, z: w)
                    let voxel = Voxel(x: x, y: y, z: z, uvw: uvw, color: color)
                    voxelRow.append(voxel)
                }
                voxelCol.append(voxelRow)
            }
            voxels.append(voxelCol)
        }
        return VoxelPack(resolution: resolution, raw: voxels)
    }
    
}
