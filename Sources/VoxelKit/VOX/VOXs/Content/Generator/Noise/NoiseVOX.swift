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
    
    public typealias Model = NoiseVoxelModel
    
    private var model: Model {
        get { generatorModel as! Model }
        set { generatorModel = newValue }
    }
    
    override open var shaderName: String { "contentGeneratorNoiseVOX" }
    
    // MARK: - Public Properties
    
    @LiveInt("seed", range: 0...10) public var seed: Int = 0
    @LiveInt("octaves", range: 1...10) public var octaves: Int = 1
    @LiveVector("position") public var position: SIMD3<Double> = .zero
    @LiveFloat("motion") public var motion: CGFloat = 0.0
    @LiveFloat("zoom") public var zoom: CGFloat = 1.0
    @LiveBool("colored") public var colored: Bool = false
    @LiveBool("random") public var random: Bool = false
    @LiveBool("includeAlpha") public var includeAlpha: Bool = false
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        super.liveList + [_seed, _octaves, _position, _motion, _zoom, _colored, _random, _includeAlpha]
    }
    
    public override var values: [Floatable] {
        [seed, octaves, position, motion, zoom, colored, random, includeAlpha]
    }
    
    // MARK: - Life Cycle -
    
    public init(model: Model) {
        super.init(model: model)
    }
    
    public required init(at resolution: Resolution3D = .default) {
        let model = Model(resolution: resolution)
        super.init(model: model)
    }
    
    // MARK: - Live Model
    
    public override func modelUpdateLive() {
        super.modelUpdateLive()
        
        seed = model.seed
        octaves = model.octaves
        position = model.position
        motion = model.motion
        zoom = model.zoom
        colored = model.colored
        random = model.random
        includeAlpha = model.includeAlpha
        
        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        
        model.seed = seed
        model.octaves = octaves
        model.position = position
        model.motion = motion
        model.zoom = zoom
        model.colored = colored
        model.random = random
        model.includeAlpha = includeAlpha
        
        super.liveUpdateModelDone()
    }
    
}
