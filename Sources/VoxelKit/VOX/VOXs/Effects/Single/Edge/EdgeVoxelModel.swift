//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct EdgeVoxelModel: VoxelSingleEffectModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Edge"
    public var typeName: String = "vox-effect-single-edge"
    public var bypass: Bool = false
    
    public var inputNodeReferences: [NodeReference] = []
    public var outputNodeReferences: [NodeReference] = []

    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .hold
    
    // MARK: Local
    
    public var strength: CGFloat = 1.0
    public var distance: CGFloat = 1.0
}

extension EdgeVoxelModel {
    
    public func isEqual(to nodeModel: NodeModel) -> Bool {
        guard let voxelModel = nodeModel as? Self else { return false }
        guard isVoxelSingleEffectEqual(to: voxelModel) else { return false }
        guard strength == voxelModel.strength else { return false }
        guard distance == voxelModel.distance else { return false }
        return true
    }
}
