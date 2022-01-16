//
//  VOXContent.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-04.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit
import Combine

public class VOXContent: VOX, NODEContent, NODEOutIO {
    
    var contentModel: VoxelContentModel {
        get { voxelModel as! VoxelContentModel }
        set { voxelModel = newValue }
    }
    
    public var outputPathList: [NODEOutPath] = [] {
        didSet { contentModel.outputNodeReferences = outputPathList.map(NodeReference.init) }
    }
    public var connectedOut: Bool { return !outputPathList.isEmpty }
    
    public var renderPromisePublisher: PassthroughSubject<RenderRequest, Never> = PassthroughSubject()
    public var renderPublisher: PassthroughSubject<RenderPack, Never> = PassthroughSubject()
    
    // MARK: - Life Cycle -
    
    init(model: VoxelContentModel) {
        super.init(model: model)
    }
}
