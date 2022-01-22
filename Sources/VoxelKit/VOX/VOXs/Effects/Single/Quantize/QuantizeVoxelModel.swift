//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct QuantizeVoxelModel: VoxelSingleEffectModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Quantize"
    public var typeName: String = "vox-effect-single-quantize"
    public var bypass: Bool = false
    
    public var inputNodeReferences: [NodeReference] = []
    public var outputNodeReferences: [NodeReference] = []

    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .zero
    
    // MARK: Local
    
    public var fraction: CGFloat = 0.125
}
