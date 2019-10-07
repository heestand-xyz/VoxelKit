//
//  VOXEffect.swift
//  PixelKit
//
//  Created by Hexagons on 2018-07-26.
//  Open Source - MIT License
//

import RenderKit

public class VOXEffect: VOX, NODEInIO, NODEOutIO {
    
    public var inputList: [NODE & NODEOut] = []
    public var outputPathList: [NODEOutPath] = []
    public var connectedIn: Bool { return !inputList.isEmpty }
    public var connectedOut: Bool { return !outputPathList.isEmpty }
        
    override init() {
        super.init()
    }
    
}
