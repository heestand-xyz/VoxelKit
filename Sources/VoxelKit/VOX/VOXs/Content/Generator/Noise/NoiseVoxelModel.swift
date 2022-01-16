//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct NoiseVoxelModel: VoxelGeneratorModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Noise"
    public var typeName: String = "vox-content-generator-noise"
    public var bypass: Bool = false
    
    public var outputNodeReferences: [NodeReference] = []

    public var viewInterpolation: ViewInterpolation = .linear
    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .zero
    
    public var premultiply: Bool = true
    public var resolution: Resolution3D = .default

    public var backgroundColor: PixelColor = .black
    public var color: PixelColor = .white
    
    // MARK: Local
    
    public var seed: Int = 1
    public var octaves: Int = 1
    public var position: SIMD3<Double> = .zero
    public var motion: CGFloat = 0.0
    public var zoom: CGFloat = 1.0
    public var colored: Bool = false
    public var random: Bool = false
    public var includeAlpha: Bool = false
}
