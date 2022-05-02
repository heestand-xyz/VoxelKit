//
//  Created by Anton Heestand on 2022-01-16.
//

import RenderKit

public typealias VoxelContentModel = VoxelModel & NodeContentModel

extension VoxelModel {
    
    func isVoxelContentEqual(to voxelModel: VoxelContentModel) -> Bool {
        guard let self = self as? VoxelContentModel else { return false }
        guard isVoxelEqual(to: voxelModel) else { return false }
        guard self.outputNodeReferences == voxelModel.outputNodeReferences else { return false }
        return true
    }
}
