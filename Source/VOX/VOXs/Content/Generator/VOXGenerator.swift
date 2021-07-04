//
//  VOXGenerator.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-04.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit
import CoreGraphics
import MetalKit
import Resolution
import PixelColor

public class VOXGenerator: VOXContent, NODEGenerator, /*NODETileable3D,*/ NODEResolution3D {
    
    @LiveResolution3D("resolution") public var resolution: Resolution3D = .cube(8)
    @LiveBool("premultiply") public var premultiply: Bool = true
    
//    public var tileResolution: Resolution3D { VoxelKit.main.tileResolution }
//    public var tileTextures: [[[MTLTexture]]]?
    
    @LiveColor("backgroundColor") public var backgroundColor: PixelColor = .black
    @LiveColor("color") public var color: PixelColor = .white
    
    public override var liveList: [LiveWrap] {
        [_resolution, _premultiply, _backgroundColor, _color]
    }

    public init(at resolution: Resolution3D, name: String, typeName: String) {
        self.resolution = resolution
        super.init(name: name, typeName: typeName)
        applyResolution { [weak self] in self?.render() }
    }
    
    public required init(at resolution: Resolution3D) {
        fatalError("please use init(at:name:typeName:)")
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
}
