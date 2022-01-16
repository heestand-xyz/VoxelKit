//
//  VOXEffect.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-07-26.
//  Open Source - MIT License
//

import RenderKit
import MetalKit
import Resolution
import Combine

public class VOXEffect: VOX, NODEEffect/*, NODETileable3D*/ {
    
    public var inputList: [NODE & NODEOut] = []
    public var outputPathList: [NODEOutPath] = []
    public var connectedIn: Bool { !inputList.isEmpty }
    public var connectedOut: Bool { !outputPathList.isEmpty }

//    public var tileResolution: Resolution3D { VoxelKit.main.tileResolution }
//    public var tileTextures: [[[MTLTexture]]]?
    
    public var renderPromisePublisher: PassthroughSubject<RenderRequest, Never> = PassthroughSubject()
    public var renderPublisher: PassthroughSubject<RenderPack, Never> = PassthroughSubject()
    public var cancellableIns: [AnyCancellable] = []
    
}
