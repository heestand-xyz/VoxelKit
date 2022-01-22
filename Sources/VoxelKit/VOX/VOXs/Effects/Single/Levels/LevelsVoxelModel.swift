//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct LevelsVoxelModel: VoxelSingleEffectModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Levels"
    public var typeName: String = "vox-effect-single-levels"
    public var bypass: Bool = false
    
    public var inputNodeReferences: [NodeReference] = []
    public var outputNodeReferences: [NodeReference] = []

    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .zero
    
    // MARK: Local
    
    public var brightness: CGFloat = 1.0
    public var darkness: CGFloat = 0.0
    public var contrast: CGFloat = 0.0
    public var gamma: CGFloat = 1.0
    public var inverted: Bool = false
    public var opacity: CGFloat = 1.0
    public var offset: CGFloat = 0.0
}
