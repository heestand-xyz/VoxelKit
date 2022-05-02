//
//  File.swift
//  
//
//  Created by Anton Heestand on 2022-01-19.
//

import RenderKit

public typealias VoxelSingleEffectModel = VoxelEffectModel & NodeSingleEffectModel

extension VoxelModel {
    
    func isVoxelSingleEffectEqual(to voxelModel: VoxelSingleEffectModel) -> Bool {
        guard let self = self as? VoxelSingleEffectModel else { return false }
        guard isVoxelEffectEqual(to: voxelModel) else { return false }
        return true
    }
}
