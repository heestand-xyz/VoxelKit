//
//  Created by Anton Heestand on 2022-01-16.
//

import RenderKit

public typealias VoxelResourceModel = VoxelContentModel & Node3DResourceContentModel

extension VoxelModel {
    
    func isVoxelResourceEqual(to voxelModel: VoxelResourceModel) -> Bool {
        guard let self = self as? VoxelResourceModel else { return false }
        guard isVoxelContentEqual(to: voxelModel) else { return false }
        guard self.resolution == voxelModel.resolution else { return false }
        return true
    }
}
