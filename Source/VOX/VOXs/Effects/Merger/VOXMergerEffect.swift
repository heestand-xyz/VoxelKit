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
    
    public var placement: Placement = .fit { didSet { setNeedsRender() } }
    
    // MARK: - Life Cycle
    
    public override func destroy() {
        inputA = nil
        inputB = nil
        super.destroy()
    }
    
}
