//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct TransformVoxelModel: VoxelSingleEffectModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Transform"
    public var typeName: String = "vox-effect-single-transform"
    public var bypass: Bool = false
    
    public var inputNodeReferences: [NodeReference] = []
    public var outputNodeReferences: [NodeReference] = []

    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .zero
    
    // MARK: Local
    
    public var position: SIMD3<Double> = .zero
    public var rotation: SIMD3<Double> = .zero
    public var scale: CGFloat = 1.0
    public var size: SIMD3<Double> = SIMD3<Double>(x: 1.0, y: 1.0, z: 1.0)
}

extension TransformVoxelModel {
    
    public func isEqual(to nodeModel: NodeModel) -> Bool {
        guard let voxelModel = nodeModel as? Self else { return false }
        guard isVoxelSingleEffectEqual(to: voxelModel) else { return false }
        guard position == voxelModel.position else { return false }
        guard rotation == voxelModel.rotation else { return false }
        guard scale == voxelModel.scale else { return false }
        guard size == voxelModel.size else { return false }
        return true
    }
}
