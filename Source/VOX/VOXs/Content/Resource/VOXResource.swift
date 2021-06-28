//
//  VOXResource.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-04.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit

public class VOXResource: VOXContent, NODEResourceCustom {
    
    public var resolution: Resolution3D { didSet { applyResolution { self.setNeedsRender() } } }
    
    public required init(at resolution: Resolution3D, name: String, typeName: String) {
        self.resolution = resolution
        super.init(name: name, typeName: typeName)
    }
}
