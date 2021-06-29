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
    
    public var outputPathList: [NODEOutPath] = []
    public var connectedOut: Bool { return !outputPathList.isEmpty }
    
    public var renderPromisePublisher: PassthroughSubject<RenderRequest, Never> = PassthroughSubject()
    public var renderPublisher: PassthroughSubject<RenderPack, Never> = PassthroughSubject()
}
