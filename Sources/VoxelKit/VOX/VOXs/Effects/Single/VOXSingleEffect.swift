//
//  VOXSingleEffect.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-07-31.
//  Open Source - MIT License
//

import RenderKit

public class VOXSingleEffect: VOXEffect, NODESingleEffect, NODEInSingle {
    
    public var singleEffectModel: VoxelSingleEffectModel {
        get { effectModel as! VoxelSingleEffectModel }
        set { effectModel = newValue }
    }
    
    public var input: (NODE & NODEOut)? { didSet { setNeedsConnectSingle(new: input, old: oldValue) } }
    
    // MARK: - Life Cycle -
    
    public init(model: VoxelSingleEffectModel) {
        super.init(model: model)
    }
    
    public required init() {
        fatalError("please use init(model:)")
    }
    
    @available(*, deprecated, renamed: "init(model:)")
    public init(name: String, typeName: String) {
        fatalError("please use init(model:)")
    }
    
    public override func destroy() {
        input = nil
        super.destroy()
    }
    
}
