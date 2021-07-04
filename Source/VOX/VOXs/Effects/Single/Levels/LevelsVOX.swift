//
//  LevelsVOX.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-07-26.
//  Open Source - MIT License
//

import RenderKit
import CoreGraphics

public class LevelsVOX: VOXSingleEffect {
    
    override open var shaderName: String { return "effectSingleLevelsVOX" }
    
    // MARK: - Public Properties
    
    @LiveFloat("brightness", range: 0.0...2.0) public var brightness: CGFloat = 1.0
    @LiveFloat("darkness") public var darkness: CGFloat = 0.0
    @LiveFloat("contrast") public var contrast: CGFloat = 0.0
    @LiveFloat("gamma") public var gamma: CGFloat = 1.0
    @LiveBool("inverted") public var inverted: Bool = false
    @LiveFloat("opacity") public var opacity: CGFloat = 1.0
    @LiveFloat("offset", range: -1.0...1.0) public var offset: CGFloat = 0.0
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        [_brightness, _darkness, _contrast, _gamma, _inverted, _opacity, _offset]
    }
    
    public override var values: [Floatable] {
        [brightness, darkness, contrast, gamma, inverted, opacity, offset]
    }
    
    // MARK: - Life Cycle
    
    public required init() {
        super.init(name: "Levels", typeName: "vox-effect-single-levels")
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
}

public extension NODEOut {
    
    func voxBrightness(_ brightness: CGFloat) -> LevelsVOX {
        let levelsPix = LevelsVOX()
        levelsPix.name = "brightness:levels"
        levelsPix.input = self as? VOX & NODEOut
        levelsPix.brightness = brightness
        return levelsPix
    }
    
    func voxDarkness(_ darkness: CGFloat) -> LevelsVOX {
        let levelsPix = LevelsVOX()
        levelsPix.name = "darkness:levels"
        levelsPix.input = self as? VOX & NODEOut
        levelsPix.darkness = darkness
        return levelsPix
    }
    
    func voxContrast(_ contrast: CGFloat) -> LevelsVOX {
        let levelsPix = LevelsVOX()
        levelsPix.name = "contrast:levels"
        levelsPix.input = self as? VOX & NODEOut
        levelsPix.contrast = contrast
        return levelsPix
    }
    
    func voxGamma(_ gamma: CGFloat) -> LevelsVOX {
        let levelsPix = LevelsVOX()
        levelsPix.name = "gamma:levels"
        levelsPix.input = self as? VOX & NODEOut
        levelsPix.gamma = gamma
        return levelsPix
    }
    
    func voxInverted() -> LevelsVOX {
        let levelsPix = LevelsVOX()
        levelsPix.name = "invert:levels"
        levelsPix.input = self as? VOX & NODEOut
        levelsPix.inverted = true
        return levelsPix
    }
    
    func voxOpacity(_ opacity: CGFloat) -> LevelsVOX {
        let levelsPix = LevelsVOX()
        levelsPix.name = "opacity:levels"
        levelsPix.input = self as? VOX & NODEOut
        levelsPix.opacity = opacity
        return levelsPix
    }
    
}
