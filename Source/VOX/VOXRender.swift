//
//  VOXRender.swift
//  VoxelKit
//
//  Created by Hexagons on 2019-10-06.
//

import RenderKit
import simd
import MetalKit
import Resolution
import PixelColor

public extension VOX {
    
    var renderedTexture: MTLTexture? { return texture }
    
    var renderedTileTexture: MTLTexture? {
        guard let nodeTileable3d = self as? NODETileable3D else {
            VoxelKit.main.logger.log(.error, .texture, "VOX is not tilable.")
            return nil
        }
        guard let textures = nodeTileable3d.tileTextures else {
            VoxelKit.main.logger.log(.error, .texture, "Tile textures not available.")
            return nil
        }
        do {
            return try Texture.mergeTiles3d(textures: textures, on: VoxelKit.main.render.metalDevice, in: VoxelKit.main.render.commandQueue)
        } catch {
            VoxelKit.main.logger.log(.error, .texture, "Tile texture merge failed.", e: error)
            return nil
        }
    }
    
    var dynamicTexture: MTLTexture? {
//        if VoxelKit.main.render.engine.renderMode.isTile {
//            return renderedTileTexture
//        } else {
        return renderedTexture
//        }
    }
    
    var renderedRaw8: [UInt8]? {
        guard let texture = dynamicTexture else { return nil }
        do {
            return try Texture.raw3d8(texture: texture)
        } catch {
            VoxelKit.main.logger.log(node: self, .error, .texture, "Raw 8 Bit texture failed.", e: error)
            return nil
        }
    }
    
    #if !os(macOS) && !targetEnvironment(macCatalyst)
    @available(iOS 14.0, *)
    var renderedRaw16: [Float16]? {
        guard let texture = dynamicTexture else { return nil }
        do {
            return try Texture.raw3d16(texture: texture)
        } catch {
            VoxelKit.main.logger.log(node: self, .error, .texture, "Raw 16 Bit texture failed.", e: error)
            return nil
        }
    }
    #endif
    
    var renderedRaw32: [Float]? {
        guard let texture = dynamicTexture else { return nil }
        do {
            return try Texture.raw3d32(texture: texture)
        } catch {
            VoxelKit.main.logger.log(node: self, .error, .texture, "Raw 32 Bit texture failed.", e: error)
            return nil
        }
    }
    
    var renderedRawNormalized: [CGFloat]? {
        guard let texture = dynamicTexture else { return nil }
        do {
            #if os(macOS) || targetEnvironment(macCatalyst)
            return try Texture.rawNormalizedCopy3d(texture: texture, bits: VoxelKit.main.render.bits, on: VoxelKit.main.render.metalDevice, in: VoxelKit.main.render.commandQueue)
            #else
            return try Texture.rawNormalized3d(texture: texture, bits: VoxelKit.main.render.bits)
            #endif
        } catch {
            VoxelKit.main.logger.log(node: self, .error, .texture, "Raw Normalized texture failed.", e: error)
            return nil
        }
    }
    
    func renderedRawNormalized(for tileIndex: TileIndex) -> [CGFloat]? {
        guard let nodeTileable3d = self as? NODETileable3D else {
            VoxelKit.main.logger.log(.error, .texture, "VOX is not tilable.")
            return nil
        }
        guard let textures = nodeTileable3d.tileTextures else {
            VoxelKit.main.logger.log(.error, .texture, "Tile textures not available.")
            return nil
        }
        let texture = textures[tileIndex.z][tileIndex.y][tileIndex.x]
        do {
            #if os(macOS) || targetEnvironment(macCatalyst)
            return try Texture.rawNormalizedCopy3d(texture: texture, bits: VoxelKit.main.render.bits, on: VoxelKit.main.render.metalDevice, in: VoxelKit.main.render.commandQueue)
            #else
            return try Texture.rawNormalized3d(texture: texture, bits: VoxelKit.main.render.bits)
            #endif
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
        public var average: PixelColor {
            var color: PixelColor!
            for row in raw {
                for col in row {
                    for vx in col {
                        guard color != nil else {
                            color = vx.color
                            continue
                        }
                        color = PixelColor(red: color.red + vx.color.red,
                                           green: color.green + vx.color.green,
                                           blue: color.blue + vx.color.blue,
                                           alpha: color.alpha + vx.color.alpha)
                    }
                }
            }
            let count = CGFloat(resolution.count)
            color = PixelColor(red: color.red / count,
                               green: color.green / count,
                               blue: color.blue / count,
                               alpha: color.alpha / count)
            return color
        }
        public var maximum: PixelColor {
            var color: PixelColor!
            for row in raw {
                for col in row {
                    for vx in col {
                        guard color != nil else {
                            color = vx.color
                            continue
                        }
                        if Bool(vx.color.brightness > color!.brightness) {
                            color = vx.color
                        }
                    }
                }
            }
            return color
        }
        public var minimum: PixelColor {
            var color: PixelColor!
            for row in raw {
                for col in row {
                    for vx in col {
                        guard color != nil else {
                            color = vx.color
                            continue
                        }
                        if Bool(vx.color.brightness < color!.brightness) {
                            color = vx.color
                        }
                    }
                }
            }
            return color
        }
    }
    
    var renderedVoxels: VoxelPack? {
        guard let rawVoxels = renderedRawNormalized else {
            VoxelKit.main.logger.log(node: self, .error, .texture, "Rendered voxels failed. Voxels not found.")
            return nil
        }
        guard let resolution = realResolution else {
            VoxelKit.main.logger.log(node: self, .error, .texture, "Rendered voxels failed. Resolution not found.")
            return nil
        }
        return renderedVoxels(for: rawVoxels, at: resolution)
    }
    
    func renderedVoxels(for tileIndex: TileIndex) -> VoxelPack? {
        guard let nodeTileable3d = self as? NODETileable3D else {
            VoxelKit.main.logger.log(.error, .texture, "VOX is not tilable.")
            return nil
        }
        guard let rawVoxels = renderedRawNormalized(for: tileIndex) else {
            VoxelKit.main.logger.log(node: self, .error, .texture, "Rendered voxels failed. Voxels not found.")
            return nil
        }
        return renderedVoxels(for: rawVoxels, at: nodeTileable3d.tileResolution)
    }
    
    func renderedVoxels(for rawVoxels: [CGFloat], at resolution: Resolution3D) -> VoxelPack? {
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
                        guard j < rawVoxels.count else {
                            VoxelKit.main.logger.log(node: self, .error, .texture, "Voxel index out of bounds.")
                            return nil
                        }
                        let chan = rawVoxels[j]
                        c.append(chan)
                    }
                    let color = PixelColor(floats: c)
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
