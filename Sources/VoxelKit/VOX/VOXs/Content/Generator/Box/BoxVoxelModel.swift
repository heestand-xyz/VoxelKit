//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct BoxVoxelModel: VoxelGeneratorModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Box"
    public var typeName: String = "vox-content-generator-box"
    public var bypass: Bool = false
    
    public var outputNodeReferences: [NodeReference] = []

    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .zero
    
    public var premultiply: Bool = true
    public var resolution: Resolution3D = .default

    public var backgroundColor: PixelColor = .black
    public var color: PixelColor = .white
    
    // MARK: Local
    
    public var position: SIMD3<Double> = .zero
    public var size: SIMD3<Double> = SIMD3<Double>(x: 0.5, y: 0.5, z: 0.5)
    public var edgeRadius: CGFloat = 0.0
    public var edgeColor: PixelColor = .gray
    public var cornerRadius: CGFloat = 0.0
}

extension BoxVoxelModel {
    
    public func isEqual(to nodeModel: NodeModel) -> Bool {
        guard let voxelModel = nodeModel as? Self else { return false }
        guard isVoxelGeneratorEqual(to: voxelModel) else { return false }
        guard position == voxelModel.position else { return false }
        guard size == voxelModel.size else { return false }
        guard edgeRadius == voxelModel.edgeRadius else { return false }
        guard edgeColor == voxelModel.edgeColor else { return false }
        guard cornerRadius == voxelModel.cornerRadius else { return false }
        return true
    }
}
