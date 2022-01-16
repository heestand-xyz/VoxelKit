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
    
    public typealias Model = SphereVoxelModel
    
    private var model: Model {
        get { generatorModel as! Model }
        set { generatorModel = newValue }
    }
    
    override open var shaderName: String { "contentGeneratorSphereVOX" }
    
    // MARK: - Public Properties
    
    @LiveFloat("radius", range: 0.0...0.5) public var radius: CGFloat = 0.25
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
        
        radius = model.radius
        position = model.position
        edgeRadius = model.edgeRadius
        edgeColor = model.edgeColor
        
        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        
        model.radius = radius
        model.position = position
        model.edgeRadius = edgeRadius
        model.edgeColor = edgeColor
        
        super.liveUpdateModelDone()
    }
    
}
