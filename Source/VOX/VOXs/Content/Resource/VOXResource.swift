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
    
    @LiveResolution3D("resolution") public var resolution: Resolution3D = .cube(8)
    
    public override var liveList: [LiveWrap] {
        [_resolution]
    }
    
    public init(at resolution: Resolution3D, name: String, typeName: String) {
        self.resolution = resolution
        super.init(name: name, typeName: typeName)
    }
    
    public required init(at resolution: Resolution3D) {
        fatalError("please use init(name:typeName:)")
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
