//
//  File.swift
//  
//
//  Created by Anton Heestand on 2022-01-19.
//

import RenderKit

public typealias VoxelEffectModel = VoxelModel & NodeEffectModel

extension VoxelModel {
    
    func isVoxelEffectEqual(to voxelModel: VoxelEffectModel) -> Bool {
        #warning("Crash EXC_BAD_ACCESS on as?")
        guard let self = self as? VoxelEffectModel else { return false }
        guard isVoxelEffectEqual(to: voxelModel) else { return false }
        guard self.inputNodeReferences == voxelModel.inputNodeReferences else { return false }
        guard self.outputNodeReferences == voxelModel.outputNodeReferences else { return false }
        return true
    }
}
