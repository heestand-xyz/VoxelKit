//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct KaleidoscopeVoxelModel: VoxelSingleEffectModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Kaleidoscope"
    public var typeName: String = "vox-effect-single-kaleidoscope"
    public var bypass: Bool = false
    
    public var inputNodeReferences: [NodeReference] = []
    public var outputNodeReferences: [NodeReference] = []

    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .mirror
    
    // MARK: Local
    
    public var divisions: Int = 12
    public var mirror: Bool = true
    public var rotation: CGFloat = 0.0
    public var position: SIMD3<Double> = .zero
    public var axis: Axis = .z
}

extension KaleidoscopeVoxelModel {
    
    public func isEqual(to nodeModel: NodeModel) -> Bool {
        guard let voxelModel = nodeModel as? Self else { return false }
        guard isVoxelSingleEffectEqual(to: voxelModel) else { return false }
        guard divisions == voxelModel.divisions else { return false }
        guard mirror == voxelModel.mirror else { return false }
        guard rotation == voxelModel.rotation else { return false }
        guard position == voxelModel.position else { return false }
        guard axis == voxelModel.axis else { return false }
        return true
    }
}
