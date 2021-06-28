//
//  BlurVOX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-02.
//  Open Source - MIT License
//

import LiveValues
import RenderKit
import CoreGraphics

public class BlurVOX: VOXSingleEffect {
    
    override open var shaderName: String { return "effectSingleBlurVOX" }
    
    // MARK: - Public Properties
    
    public enum BlurStyle: String, CaseIterable {
        case box
        case zoom
        case random
        var index: Int {
            switch self {
            case .box: return 0
            case .zoom: return 1
            case .random: return 2
            }
        }
    }
    
    public enum SampleQualityMode: Int, Codable, CaseIterable {
        case low = 4
        case mid = 8
        case high = 16
        case extreme = 32
        case insane = 64
        case epic = 128
    }
    
    public var style: BlurStyle = .box { didSet { setNeedsRender() } }
    /// radius is relative. default at 0.5
    ///
    /// 1.0 at 4K is max, tho at lower resolutions you can go beyond 1.0
    public var radius: LiveFloat = LiveFloat(0.5, limit: true)
    public var quality: SampleQualityMode = .mid { didSet { setNeedsRender() } }
    public var position: LiveVec = .zero
    
    // MARK: - Property Helpers
    
    override public var liveValues: [LiveValue] {
        return [radius, position]
    }
    
    var relRadius: CGFloat {
        let radius = self.radius.uniform
        let relRes: Resolution = ._4K
        let res: Resolution = renderResolution
        let relHeight = res.height.cg / relRes.height.cg
        let relRadius = radius * relHeight //min(radius * relHeight, 1.0)
        let maxRadius: CGFloat = 32 * 10
        let mappedRadius = relRadius * maxRadius
        return mappedRadius //radius.uniform * 32 * 10
    }
    
    open override var uniforms: [CGFloat] {
        return [CGFloat(style.index), relRadius, CGFloat(quality.rawValue), position.x.uniform, position.y.uniform, position.z.uniform]
    }
    
    override open var shaderNeedsAspect: Bool { return true }
    
    public required init() {
        super.init(name: "Blur", typeName: "vox-effect-single-blur")
        extend = .hold
    }
}

public extension NODEOut {
    
    func _blur(_ radius: LiveFloat) -> BlurVOX {
        let blurPix = BlurVOX()
        blurPix.name = ":blur:"
        blurPix.input = self as? VOX & NODEOut
        blurPix.radius = radius
        return blurPix
    }
    
    func _zoomBlur(_ radius: LiveFloat) -> BlurVOX {
        let blurPix = BlurVOX()
        blurPix.name = ":zoom-blur:"
        blurPix.style = .zoom
        blurPix.quality = .epic
        blurPix.input = self as? VOX & NODEOut
        blurPix.radius = radius
        return blurPix
    }
    
}
