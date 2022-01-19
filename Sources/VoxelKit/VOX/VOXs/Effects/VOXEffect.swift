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

public class VOXEffect: VOX, NODEEffect {
    
    var effectModel: VoxelEffectModel {
        get { voxelModel as! VoxelEffectModel }
        set { voxelModel = newValue }
    }
    
    public var inputList: [NODE & NODEOut] = [] {
        didSet { effectModel.inputNodeReferences = inputList.map({ NodeReference(node: $0, connection: .single) }) }
    }
    public var outputPathList: [NODEOutPath] = [] {
        didSet { effectModel.outputNodeReferences = outputPathList.map(NodeReference.init) }
    }
    public var connectedIn: Bool { !inputList.isEmpty }
    public var connectedOut: Bool { !outputPathList.isEmpty }

//    public var tileResolution: Resolution3D { VoxelKit.main.tileResolution }
//    public var tileTextures: [[[MTLTexture]]]?
    
    public var renderPromisePublisher: PassthroughSubject<RenderRequest, Never> = PassthroughSubject()
    public var renderPublisher: PassthroughSubject<RenderPack, Never> = PassthroughSubject()
    public var cancellableIns: [AnyCancellable] = []
    
    // MARK: - Life Cycle -
    
    init(model: VoxelEffectModel) {
        super.init(model: model)
    }
}
