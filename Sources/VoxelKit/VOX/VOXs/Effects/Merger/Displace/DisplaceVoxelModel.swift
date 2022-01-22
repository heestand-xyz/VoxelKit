//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct DisplaceVoxelModel: VoxelMergerEffectModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Displace"
    public var typeName: String = "vox-effect-merger-displace"
    public var bypass: Bool = false
    
    public var inputNodeReferences: [NodeReference] = []
    public var outputNodeReferences: [NodeReference] = []

    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .hold
    
    public var placement: Placement = .fit
    
    // MARK: Local
    
    public var distance: CGFloat = 1.0
    public var origin: CGFloat = 0.5
}
