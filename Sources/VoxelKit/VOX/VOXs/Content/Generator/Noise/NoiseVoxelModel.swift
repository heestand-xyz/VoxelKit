//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct NoiseVoxelModel: VoxelGeneratorModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Noise"
    public var typeName: String = "vox-content-generator-noise"
    public var bypass: Bool = false
    
    public var outputNodeReferences: [NodeReference] = []

    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .zero
    
    public var premultiply: Bool = true
    public var resolution: Resolution3D = .default

    public var backgroundColor: PixelColor = .black
    public var color: PixelColor = .white
    
    // MARK: Local
    
    public var seed: Int = 1
    public var octaves: Int = 1
    public var position: SIMD3<Double> = .zero
    public var motion: CGFloat = 0.0
    public var zoom: CGFloat = 1.0
    public var colored: Bool = false
    public var random: Bool = false
    public var includeAlpha: Bool = false
}

extension NoiseVoxelModel {
    
    public func isEqual(to nodeModel: NodeModel) -> Bool {
        guard let voxelModel = nodeModel as? Self else { return false }
        guard isVoxelGeneratorEqual(to: voxelModel) else { return false }
        guard seed == voxelModel.seed else { return false }
        guard octaves == voxelModel.octaves else { return false }
        guard position == voxelModel.position else { return false }
        guard motion == voxelModel.motion else { return false }
        guard zoom == voxelModel.zoom else { return false }
        guard colored == voxelModel.colored else { return false }
        guard random == voxelModel.random else { return false }
        guard includeAlpha == voxelModel.includeAlpha else { return false }
        return true
    }
}
