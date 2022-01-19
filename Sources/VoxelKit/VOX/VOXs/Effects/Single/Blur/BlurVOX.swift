//
//  BlurVOX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-02.
//  Open Source - MIT License
//

import RenderKit
import CoreGraphics
import Resolution

public class BlurVOX: VOXSingleEffect {
    
    public typealias Model = BlurVoxelModel
    
    private var model: Model {
        get { singleEffectModel as! Model }
        set { singleEffectModel = newValue }
    }
    
    override open var shaderName: String { return "effectSingleBlurVOX" }
    
    // MARK: - Public Properties
    
    public enum BlurStyle: String, Enumable {
        case box
        case zoom
        case random
        public var index: Int {
            switch self {
            case .box: return 0
            case .zoom: return 1
            case .random: return 2
            }
        }
        public var name: String {
            switch self {
            case .box:
                return "Box"
            case .zoom:
                return "Zoom"
            case .random:
                return "Random"
            }
        }
        public var typeName: String { rawValue }
    }
    
    public enum SampleQualityMode: Int, Enumable {
        case low = 4
        case mid = 8
        case high = 16
        case extreme = 32
        case insane = 64
        case epic = 128
        public var index: Int { rawValue }
        public var name: String {
            switch self {
            case .low:
                return "Low"
            case .mid:
                return "Mid"
            case .high:
                return "High"
            case .extreme:
                return "Extreme"
            case .insane:
                return "Insane"
            case .epic:
                return "Epic"
            }
        }
        public var typeName: String { name.lowercased() }
    }
    
    @LiveEnum("style") public var style: BlurStyle = .box
    /// radius is relative. default at 0.5
    ///
    /// 1.0 at 4K is max, tho at lower resolutions you can go beyond 1.0
    @LiveFloat("radius") public var radius: CGFloat = 0.5
    @LiveEnum("quality") public var quality: SampleQualityMode = .mid
    @LiveVector("position") public var position: SIMD3<Double> = .zero
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        [_style, _radius, _quality, _position]
    }
    
    public override var values: [Floatable] {
        [radius, position]
    }
    
    var relRadius: CGFloat {
        let radius = self.radius
        let relRes: Resolution = ._4K
        let res: Resolution = renderResolution
        let relHeight = res.height / relRes.height
        let relRadius = radius * relHeight
        let maxRadius: CGFloat = 32 * 10
        let mappedRadius = relRadius * maxRadius
        return mappedRadius
    }
    
    open override var uniforms: [CGFloat] {
        [CGFloat(style.index), relRadius, CGFloat(quality.rawValue), position.x, position.y, position.z]
    }
    
    override open var shaderNeedsAspect: Bool { return true }
    
    // MARK: - Life Cycle -
    
    public init(model: Model) {
        super.init(model: model)
    }
    
    public required init() {
        let model = Model()
        super.init(model: model)
    }
    
    // MARK: - Live Model
    
    public override func modelUpdateLive() {
        super.modelUpdateLive()
        
        style = model.style
        radius = model.radius
        quality = model.quality
        position = model.position
        
        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        
        model.style = style
        model.radius = radius
        model.quality = quality
        model.position = position
        
        super.liveUpdateModelDone()
    }
    
}

public extension NODEOut {
    
    func voxBlur(_ radius: CGFloat) -> BlurVOX {
        let blurPix = BlurVOX()
        blurPix.name = ":blur:"
        blurPix.input = self as? VOX & NODEOut
        blurPix.radius = radius
        return blurPix
    }
    
    func voxZoomBlur(_ radius: CGFloat) -> BlurVOX {
        let blurPix = BlurVOX()
        blurPix.name = ":zoom-blur:"
        blurPix.style = .zoom
        blurPix.quality = .epic
        blurPix.input = self as? VOX & NODEOut
        blurPix.radius = radius
        return blurPix
    }
    
}
