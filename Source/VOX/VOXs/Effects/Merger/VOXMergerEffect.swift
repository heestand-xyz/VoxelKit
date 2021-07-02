//
//  VOXMergerEffect.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-07-31.
//  Open Source - MIT License
//

import RenderKit

public class VOXMergerEffect: VOXEffect, NODEMergerEffect, NODEInMerger {
    
    public var inputA: (NODE & NODEOut)? { didSet { setNeedsConnectMerger(new: inputA, old: oldValue, second: false) } }
    public var inputB: (NODE & NODEOut)? { didSet { setNeedsConnectMerger(new: inputB, old: oldValue, second: true) } }
    public override var connectedIn: Bool { return inputList.count == 2 }
    
    @LiveEnum("placement") public var placement: Placement = .fit
    
    public override var liveList: [LiveWrap] {
        [_placement]
    }
    
    // MARK: - Life Cycle
    
    public required init() {
        fatalError("please use init(name:typeName:)")
    }
    
    public override init(name: String, typeName: String) {
        super.init(name: name, typeName: typeName)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    public override func destroy() {
        inputA = nil
        inputB = nil
        super.destroy()
    }
    
}
