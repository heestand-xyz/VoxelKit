//
//  File.swift
//  
//
//  Created by Anton Heestand on 2022-01-19.
//

import RenderKit

public typealias VoxelMergerEffectModel = VoxelEffectModel & NodeMergerEffectModel

extension VoxelModel {
    
    func isVoxelMergerEffectEqual(to voxelModel: VoxelMergerEffectModel) -> Bool {
        guard let self = self as? VoxelMergerEffectModel else { return false }
        guard isVoxelEffectEqual(to: voxelModel) else { return false }
        guard self.placement == voxelModel.placement else { return false }
        return true
    }
}
