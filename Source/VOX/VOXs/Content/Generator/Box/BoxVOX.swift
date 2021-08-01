//
//  BoxVOX.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-21.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit
import simd
import CoreGraphics
import PixelColor
import Resolution

public class BoxVOX: VOXGenerator {
    
    override open var shaderName: String { return "contentGeneratorBoxVOX" }
    
    // MARK: - Public Properties
    
    @LiveVector("position") public var position: SIMD3<Double> = .zero
    @LiveVector("size") public var size: SIMD3<Double> = SIMD3<Double>(x: 0.5, y: 0.5, z: 0.5)
    @LiveFloat("edgeRadius") public var edgeRadius: CGFloat = 0.0
    @LiveColor("edgeColor") public var edgeColor: PixelColor = .gray
    @LiveFloat("cornerRadius") public var cornerRadius: CGFloat = 0.0
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        super.liveList + [_position, _size, _edgeRadius, _cornerRadius, _edgeColor]
    }
    
    public override var values: [Floatable] {
        [position, size, edgeRadius, cornerRadius, super.color, edgeColor, super.backgroundColor]
    }
    
    // MARK: - Life Cycle
    
    public required init(at resolution: Resolution3D) {
        super.init(at: resolution, name: "Sphere", typeName: "vox-content-generator-box")
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
}
