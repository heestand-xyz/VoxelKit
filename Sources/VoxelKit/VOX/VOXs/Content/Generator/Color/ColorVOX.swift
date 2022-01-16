//
//  ColorVOX.swift
//  VoxelKit
//
//  Created by Hexagons on 2019-10-05.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit
import CoreGraphics
import Resolution

public class ColorVOX: VOXGenerator {
    
    public typealias Model = ColorVoxelModel
    
    private var model: Model {
        get { generatorModel as! Model }
        set { generatorModel = newValue }
    }
    
    override open var shaderName: String { "contentGeneratorColorVOX" }
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        super.liveList.filter({ liveWrap in
            liveWrap.typeName != "backgroundColor"
        })
    }
    
    public override var values: [Floatable] {
        [super.color]
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
        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        super.liveUpdateModelDone()
    }
    
}
