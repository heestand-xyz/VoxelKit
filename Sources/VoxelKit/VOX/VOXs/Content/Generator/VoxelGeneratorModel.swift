//
//  Created by Anton Heestand on 2022-01-16.
//

import RenderKit

public typealias VoxelGeneratorModel = VoxelContentModel & Node3DGeneratorContentModel

extension VoxelModel {
    
    func isVoxelGeneratorEqual(to voxelModel: VoxelGeneratorModel) -> Bool {
        guard let self = self as? VoxelGeneratorModel else { return false }
        guard isVoxelContentEqual(to: voxelModel) else { return false }
        guard self.premultiply == voxelModel.premultiply else { return false }
        guard self.resolution == voxelModel.resolution else { return false }
        guard self.backgroundColor == voxelModel.backgroundColor else { return false }
        guard self.color == voxelModel.color else { return false }
        return true
    }
}
