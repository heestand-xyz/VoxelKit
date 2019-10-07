//
//  ResolutionVOX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-03.
//  Open Source - MIT License
//

import RenderKit
import CoreGraphics

public class ResolutionVOX: VOXSingleEffect, NODEResolution3D {

    override open var shaderName: String { return "effectSingleResolutionVOX" }
    
    // MARK: - Public Properties
    
    public var resolution: Resolution3D { didSet { applyResolution { self.setNeedsRender() } } }
    public var resMultiplier: CGFloat = 1 { didSet { applyResolution { self.setNeedsRender() } } }
    public var inheritInResolution: Bool = false { didSet { applyResolution { self.setNeedsRender() } } }
    
    // MARK: - Life Cycle
    
    required public init(at resolution: Resolution3D) {
        self.resolution = resolution
        super.init()
        name = "res"
    }
    
    required init() {
        self.resolution = ._128
        super.init()
    }
    
}

public extension NODEOut {
    
    func _reRes(to resolution: Resolution3D) -> ResolutionVOX {
        let resPix = ResolutionVOX(at: resolution)
        resPix.name = "reRes:res"
        resPix.input = self as? VOX & NODEOut
        return resPix
    }
    
    func _reRes(by resMultiplier: CGFloat) -> ResolutionVOX {
        let resPix = ResolutionVOX(at: ._128)
        resPix.name = "reRes:res"
        resPix.input = self as? VOX & NODEOut
        resPix.inheritInResolution = true
        resPix.resMultiplier = resMultiplier
        return resPix
    }
    
}
