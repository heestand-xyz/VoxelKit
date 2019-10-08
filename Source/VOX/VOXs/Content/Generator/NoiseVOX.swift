//
//  NoiseVOX.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-08-14.
//  Open Source - MIT License
//

import LiveValues
import RenderKit

public class NoiseVOX: VOXGenerator {
    
    override open var shaderName: String { return "contentGeneratorNoiseVOX" }
    
    // MARK: - Public Properties
    
    public var seed: LiveInt = LiveInt(0, max: 10)
    public var octaves: LiveInt = LiveInt(10, min: 1, max: 10)
    public var position: LiveVec = .zero
    public var wPosition: LiveFloat = 0.0
    public var zoom: LiveFloat = 1.0
    public var colored: LiveBool = false
    public var random: LiveBool = false
    public var includeAlpha: LiveBool = false
    
    // MARK: - Property Helpers
    
    override public var liveValues: [LiveValue] {
        return [seed, octaves, position, wPosition, zoom, colored, random, includeAlpha]
    }
    
    // MARK: - Life Cycle
    
    public required init(at resolution: Resolution3D) {
        super.init(at: resolution)
        name = "noise"
    }
    
}
