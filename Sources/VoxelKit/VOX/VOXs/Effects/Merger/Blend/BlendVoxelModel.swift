//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct BlendVoxelModel: VoxelMergerEffectModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Blend"
    public var typeName: String = "vox-effect-merger-blend"
    public var bypass: Bool = false
    
    public var inputNodeReferences: [NodeReference] = []
    public var outputNodeReferences: [NodeReference] = []

    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .zero
    
    public var placement: Placement = .fit
    
    // MARK: Local
    
    public var blendMode: BlendMode = .add
}
