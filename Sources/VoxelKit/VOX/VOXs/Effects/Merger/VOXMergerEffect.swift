//
//  VOXMergerEffect.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-07-31.
//  Open Source - MIT License
//

import RenderKit

public class VOXMergerEffect: VOXEffect, NODEMergerEffect, NODEInMerger {
    
    public var mergerEffectModel: VoxelMergerEffectModel {
        get { effectModel as! VoxelMergerEffectModel }
        set { effectModel = newValue }
    }
    
    public var inputA: (NODE & NODEOut)? { didSet { setNeedsConnectMerger(new: inputA, old: oldValue, second: false) } }
    public var inputB: (NODE & NODEOut)? { didSet { setNeedsConnectMerger(new: inputB, old: oldValue, second: true) } }
    public override var connectedIn: Bool { return inputList.count == 2 }
    
    @LiveEnum("placement") public var placement: Placement = .fit
    
    public override var liveList: [LiveWrap] {
        [_placement]
    }
    
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
        inputA = nil
        inputB = nil
        super.destroy()
    }
    
}
