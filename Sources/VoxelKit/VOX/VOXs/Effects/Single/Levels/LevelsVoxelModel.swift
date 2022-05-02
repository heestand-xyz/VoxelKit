//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct LevelsVoxelModel: VoxelSingleEffectModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Levels"
    public var typeName: String = "vox-effect-single-levels"
    public var bypass: Bool = false
    
    public var inputNodeReferences: [NodeReference] = []
    public var outputNodeReferences: [NodeReference] = []

    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .zero
    
    // MARK: Local
    
    public var brightness: CGFloat = 1.0
    public var darkness: CGFloat = 0.0
    public var contrast: CGFloat = 0.0
    public var gamma: CGFloat = 1.0
    public var inverted: Bool = false
    public var opacity: CGFloat = 1.0
    public var offset: CGFloat = 0.0
}

extension LevelsVoxelModel {
    
    public func isEqual(to nodeModel: NodeModel) -> Bool {
        guard let voxelModel = nodeModel as? Self else { return false }
        guard isVoxelSingleEffectEqual(to: voxelModel) else { return false }
        guard brightness == voxelModel.brightness else { return false }
        guard darkness == voxelModel.darkness else { return false }
        guard contrast == voxelModel.contrast else { return false }
        guard gamma == voxelModel.gamma else { return false }
        guard inverted == voxelModel.inverted else { return false }
        guard opacity == voxelModel.opacity else { return false }
        guard offset == voxelModel.offset else { return false }
        return true
    }
}
