//
//  SphereVOX.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-07.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit
import simd
import Resolution
import PixelColor
import CoreGraphics

public class SphereVOX: VOXGenerator {
    
    override open var shaderName: String { return "contentGeneratorSphereVOX" }
    
    // MARK: - Public Properties
    
    @LiveFloat("radius", range: 0.0...0.5) public var radius: CGFloat = 0.5
    @LiveVector("position") public var position: SIMD3<Double> = .zero
    @LiveFloat("edgeRadius", range: 0.0...0.25) public var edgeRadius: CGFloat = 0.0
    @LiveColor("edgeColor") public var edgeColor: PixelColor = .gray
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        super.liveList + [_radius, _position, _edgeRadius, _edgeColor]
    }
    
    public override var values: [Floatable] {
        [radius, position, edgeRadius, super.color, edgeColor, super.backgroundColor]
    }
    
    // MARK: - Life Cycle
    
    public required init(at resolution: Resolution3D) {
        super.init(at: resolution, name: "Sphere", typeName: "vox-content-generator-sphere")
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
}
