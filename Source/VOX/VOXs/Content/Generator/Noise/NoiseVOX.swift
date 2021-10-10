//
//  NoiseVOX.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-08-14.
//  Open Source - MIT License
//

import RenderKit
import simd
import CoreGraphics
import Resolution

public class NoiseVOX: VOXGenerator {
    
    override open var shaderName: String { return "contentGeneratorNoiseVOX" }
    
    // MARK: - Public Properties
    
    @LiveInt("seed", range: 0...10) public var seed: Int = 0
    @LiveInt("octaves", range: 1...10) public var octaves: Int = 1
    @LiveVector("position") public var position: SIMD3<Double> = .zero
    @LiveFloat("wPosition") public var wPosition: CGFloat = 0.0
    @LiveFloat("zoom") public var zoom: CGFloat = 1.0
    @LiveBool("colored") public var colored: Bool = false
    @LiveBool("random") public var random: Bool = false
    @LiveBool("includeAlpha") public var includeAlpha: Bool = false
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        super.liveList + [_seed, _octaves, _position, _wPosition, _zoom, _colored, _random, _includeAlpha]
    }
    
    public override var values: [Floatable] {
        [seed, octaves, position, wPosition, zoom, colored, random, includeAlpha]
    }
    
    // MARK: - Life Cycle
    
    public required init(at resolution: Resolution3D) {
        super.init(at: resolution, name: "Noise", typeName: "vox-content-generator-noise")
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
}
