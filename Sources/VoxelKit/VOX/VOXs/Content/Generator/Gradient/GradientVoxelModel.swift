//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct GradientVoxelModel: VoxelGeneratorModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Gradient"
    public var typeName: String = "vox-content-generator-gradient"
    public var bypass: Bool = false
    
    public var outputNodeReferences: [NodeReference] = []

    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .zero
    
    public var premultiply: Bool = true
    public var resolution: Resolution3D = .default

    public var backgroundColor: PixelColor = .black
    public var color: PixelColor = .white
    
    // MARK: Local
    
    public var colorStops: [ColorStep] = [ColorStep(0.0, .black), ColorStep(1.0, .white)]
    public var direction: GradientVOX.Direction = .linear(.x)
    public var scale: CGFloat = 1.0
    public var offset: CGFloat = 0.0
    public var position: SIMD3<Double> = .zero
    public var extendMode: ExtendMode = .hold
}

extension GradientVoxelModel {
    
    public func isEqual(to nodeModel: NodeModel) -> Bool {
        guard let voxelModel = nodeModel as? Self else { return false }
        guard isVoxelGeneratorEqual(to: voxelModel) else { return false }
        guard colorStops == voxelModel.colorStops else { return false }
        guard direction == voxelModel.direction else { return false }
        guard scale == voxelModel.scale else { return false }
        guard offset == voxelModel.offset else { return false }
        guard position == voxelModel.position else { return false }
        guard extendMode == voxelModel.extendMode else { return false }
        return true
    }
}
