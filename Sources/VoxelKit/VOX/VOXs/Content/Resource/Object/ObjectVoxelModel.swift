//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct ObjectVoxelModel: VoxelResourceModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Object"
    public var typeName: String = "vox-content-resource-object"
    public var bypass: Bool = false
    
    public var outputNodeReferences: [NodeReference] = []

    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .zero
    
    public var resolution: Resolution3D = .default

    // MARK: Local
    
    public var mode: ObjectVOX.Mode = .edge
}

extension ObjectVoxelModel {
    
    public func isEqual(to nodeModel: NodeModel) -> Bool {
        guard let voxelModel = nodeModel as? Self else { return false }
        guard isVoxelResourceEqual(to: voxelModel) else { return false }
        guard mode == voxelModel.mode else { return false }
        return true
    }
}
