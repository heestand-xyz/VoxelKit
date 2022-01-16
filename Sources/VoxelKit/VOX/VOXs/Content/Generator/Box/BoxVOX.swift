//
//  BoxVOX.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-21.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit
import simd
import CoreGraphics
import PixelColor
import Resolution

public class BoxVOX: VOXGenerator {
    
    public typealias Model = BoxVoxelModel
    
    private var model: Model {
        get { generatorModel as! Model }
        set { generatorModel = newValue }
    }
    
    override open var shaderName: String { "contentGeneratorBoxVOX" }
    
    // MARK: - Public Properties
    
    @LiveVector("position") public var position: SIMD3<Double> = .zero
    @LiveVector("size") public var size: SIMD3<Double> = SIMD3<Double>(x: 0.5, y: 0.5, z: 0.5)
    @LiveFloat("edgeRadius") public var edgeRadius: CGFloat = 0.0
    @LiveColor("edgeColor") public var edgeColor: PixelColor = .gray
    @LiveFloat("cornerRadius") public var cornerRadius: CGFloat = 0.0
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        super.liveList + [_position, _size, _edgeRadius, _cornerRadius, _edgeColor]
    }
    
    public override var values: [Floatable] {
        [position, size, edgeRadius, cornerRadius, super.color, edgeColor, super.backgroundColor]
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
        
        position = model.position
        size = model.size
        edgeRadius = model.edgeRadius
        edgeColor = model.edgeColor
        cornerRadius = model.cornerRadius
        
        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        
        model.position = position
        model.size = size
        model.edgeRadius = edgeRadius
        model.edgeColor = edgeColor
        model.cornerRadius = cornerRadius
        
        super.liveUpdateModelDone()
    }
    
}
