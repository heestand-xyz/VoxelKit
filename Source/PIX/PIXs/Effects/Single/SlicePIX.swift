//
//  SlicePIX.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import PixelKit

public class SlicePIX: PIXSingleEffect {
    
    override open var shader: String { return "slicePIX" }
    
    public required init() {
        super.init()
        name = "slice"
    }
}

