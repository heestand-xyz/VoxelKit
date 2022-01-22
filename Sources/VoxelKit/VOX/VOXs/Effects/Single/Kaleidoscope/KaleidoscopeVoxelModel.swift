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
