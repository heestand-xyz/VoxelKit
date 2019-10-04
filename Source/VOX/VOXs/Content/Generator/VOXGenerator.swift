//
//  VOXGenerator.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-04.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import LiveValues
import RenderKit
import CoreGraphics

public class VOXGenerator: VOXContent, NODEGenerator, NODEResolution3D {
    
    public var resolution: Resolution3D { didSet { setNeedsRender() } }
    public var premultiply: Bool = true { didSet { setNeedsRender() } }
    
    public var bgColor: LiveColor = .black
    public var color: LiveColor = .white

    public required init(at resolution: Resolution3D) {
        self.resolution = resolution
        super.init()
        applyResolution { self.setNeedsRender() }
    }
    
}
