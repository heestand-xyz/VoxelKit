//
//  DisplaceVOX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-09-06.
//  Open Source - MIT License
//

import LiveValues
import RenderKit

public class DisplaceVOX: VOXMergerEffect {
    
    override open var shaderName: String { return "effectMergerDisplaceVOX" }
    
    // MARK: - Public Properties
    
    public var distance: LiveFloat = LiveFloat(1.0, max: 2.0)
    public var origin: LiveFloat = 0.5
    
    // MARK: - Property Helpers
    
    override public var liveValues: [LiveValue] {
        return [distance, origin]
    }
    
    // MARK: - Life Cycle
    
    public required init() {
        super.init()
        extend = .hold
        name = "displace"
    }
    
}

public extension NODEOut {
    
    func _displace(with vox: VOX & NODEOut, distance: LiveFloat) -> DisplaceVOX {
        let displacePix = DisplaceVOX()
        displacePix.name = ":displace:"
        displacePix.inputA = self as? VOX & NODEOut
        displacePix.inputB = vox
        displacePix.distance = distance
        return displacePix
    }
    
//    func _noiseDisplace(distance: LiveFloat, zPosition: LiveFloat = 0.0, octaves: LiveInt = 10) -> DisplaceVOX {
//        let vox = self as! VOX & NODEOut
//        let noisePix = NoiseVOX(at: vox.renderResolution)
//        noisePix.name = "noiseDisplace:noise"
//        noisePix.colored = true
//        noisePix.zPosition = zPosition
//        noisePix.octaves = octaves
//        return vox._displace(with: noisePix, distance: distance)
//    }
    
}
