//
//  VOXEffect.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-07-26.
//  Open Source - MIT License
//

import RenderKit
import MetalKit

public class VOXEffect: VOX, NODEInIO, NODEOutIO, NODETileable3D {
    
    public var inputList: [NODE & NODEOut] = []
    public var outputPathList: [NODEOutPath] = []
    public var connectedIn: Bool { return !inputList.isEmpty }
    public var connectedOut: Bool { return !outputPathList.isEmpty }

    public var tileResolution: Resolution3D { VoxelKit.main.tileResolution }
    public var tileTextures: [[[MTLTexture]]]?
    
}
