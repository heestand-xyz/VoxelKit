//
//  VOXResource.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-04.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit
import Resolution

public class VOXResource: VOXContent, NODEResourceCustom {
    
    var resourceModel: VoxelResourceModel {
        get { contentModel as! VoxelResourceModel }
        set { contentModel = newValue }
    }
    
    @LiveResolution3D("resolution") public var resolution: Resolution3D = .cube(8)
    
    public override var liveList: [LiveWrap] {
        [_resolution]
    }
    
    // MARK: - Life Cycle -
    
    public init(model: VoxelResourceModel) {
        self.resolution = model.resolution
        super.init(model: model)
    }
    
    @available(*, deprecated, renamed: "init(model:)")
    public init(at resolution: Resolution3D, name: String, typeName: String) {
        fatalError("please use init(model:)")
    }
    
    public required init(at resolution: Resolution3D) {
        fatalError("please use init(model:)")
    }
    
    // MARK: - Live Model
    
    open override func modelUpdateLive() {
        super.modelUpdateLive()
        
        resolution = resourceModel.resolution
    }
    
    open override func liveUpdateModel() {
        super.liveUpdateModel()
        
        resourceModel.resolution = resolution
    }
    
}
