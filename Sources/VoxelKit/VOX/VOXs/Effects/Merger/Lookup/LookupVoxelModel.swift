//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct LookupVoxelModel: VoxelMergerEffectModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Lookup"
    public var typeName: String = "vox-effect-merger-lookup"
    public var bypass: Bool = false
    
    public var inputNodeReferences: [NodeReference] = []
    public var outputNodeReferences: [NodeReference] = []

    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .hold
    
    public var placement: Placement = .fit
    
    // MARK: Local
    
    public var axis: Axis = .x
    public var holdEdge: Bool = true
}
