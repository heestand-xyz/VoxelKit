//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct ResolutionVoxelModel: VoxelSingleEffectModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Resolution"
    public var typeName: String = "vox-effect-single-resolution"
    public var bypass: Bool = false
    
    public var inputNodeReferences: [NodeReference] = []
    public var outputNodeReferences: [NodeReference] = []

    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .zero
    
    // MARK: Local
    
    public var resolution: Resolution3D = .default
}
