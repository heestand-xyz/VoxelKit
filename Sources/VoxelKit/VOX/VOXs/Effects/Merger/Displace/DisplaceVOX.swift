//
//  DisplaceVOX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-09-06.
//  Open Source - MIT License
//

import RenderKit
import CoreGraphics

public class DisplaceVOX: VOXMergerEffect {
    
    public typealias Model = DisplaceVoxelModel
    
    private var model: Model {
        get { mergerEffectModel as! Model }
        set { mergerEffectModel = newValue }
    }
    
    override open var shaderName: String { return "effectMergerDisplaceVOX" }
    
    // MARK: - Public Properties
    
    @LiveFloat("distance", range: 0.0...2.0) public var distance: CGFloat = 1.0
    @LiveFloat("origin") public var origin: CGFloat = 0.5
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        super.liveList + [_distance, _origin]
    }
    
    public override var values: [Floatable] {
        [distance, origin]
    }
    
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
        
        distance = model.distance
        origin = model.origin
        
        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        
        model.distance = distance
        model.origin = origin
        
        super.liveUpdateModelDone()
    }
    
}

public extension NODEOut {
    
    func voxDisplace(vox: VOX & NODEOut, distance: CGFloat) -> DisplaceVOX {
        let displacePix = DisplaceVOX()
        displacePix.name = ":displace:"
        displacePix.inputA = self as? VOX & NODEOut
        displacePix.inputB = vox
        displacePix.distance = distance
        return displacePix
    }
    
    func voxNoiseDisplace(distance: CGFloat, motion: CGFloat = 0.0, octaves: Int = 10) -> DisplaceVOX {
        let vox = self as! VOX & NODEOut
        let noisePix = NoiseVOX(at: vox.renderedResolution3d)
        noisePix.name = "noiseDisplace:noise"
        noisePix.colored = true
        noisePix.motion = motion
        noisePix.octaves = octaves
        return vox.voxDisplace(vox: noisePix, distance: distance)
    }
    
}
