//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct BlurVoxelModel: VoxelSingleEffectModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Blur"
    public var typeName: String = "vox-effect-single-blur"
    public var bypass: Bool = false
    
    public var inputNodeReferences: [NodeReference] = []
    public var outputNodeReferences: [NodeReference] = []

    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .hold
    
    // MARK: Local
    
    public var style: BlurVOX.BlurStyle = .box
    public var radius: CGFloat = 0.5
    public var quality: BlurVOX.SampleQualityMode = .mid
    public var position: SIMD3<Double> = .zero
}

extension BlurVoxelModel {
    
    public func isEqual(to nodeModel: NodeModel) -> Bool {
        guard let voxelModel = nodeModel as? Self else { return false }
        guard isVoxelSingleEffectEqual(to: voxelModel) else { return false }
        guard style == voxelModel.style else { return false }
        guard radius == voxelModel.radius else { return false }
        guard quality == voxelModel.quality else { return false }
        guard position == voxelModel.position else { return false }
        return true
    }
}
