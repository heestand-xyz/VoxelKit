//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct GradientVoxelModel: VoxelGeneratorModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Gradient"
    public var typeName: String = "vox-content-generator-gradient"
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
    
    public var colorStops: [ColorStep] = [ColorStep(0.0, .black), ColorStep(1.0, .white)]
    public var direction: GradientVOX.Direction = .linear(.x)
    public var scale: CGFloat = 1.0
    public var offset: CGFloat = 0.0
    public var position: SIMD3<Double> = .zero
    public var extendMode: ExtendMode = .hold
}
