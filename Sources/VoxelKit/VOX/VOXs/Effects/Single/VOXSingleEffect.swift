//
//  VOXSingleEffect.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-07-31.
//  Open Source - MIT License
//

import RenderKit

public class VOXSingleEffect: VOXEffect, NODESingleEffect, NODEInSingle {
    
    public var input: (NODE & NODEOut)? { didSet { setNeedsConnectSingle(new: input, old: oldValue) } }
    
    // MARK: - Life Cycle -
    
    public required init() {
        fatalError("please use init(name:typeName:)")
    }
    
    public init(name: String, typeName: String) {
        fatalError("please use init(model:)")
    }
    
    public override func destroy() {
        input = nil
        super.destroy()
    }
    
}
