//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import RenderKit

public protocol VoxelModel: NodeModel {
    var interpolation: PixelInterpolation { get set }
    var extend: ExtendMode { get set }
}

extension VoxelModel {
    
    func isVoxelEqual(to voxelModel: VoxelModel) -> Bool {
        guard isSuperEqual(to: voxelModel) else { return false }
        guard interpolation == voxelModel.interpolation else { return false }
        guard extend == voxelModel.extend else { return false }
        return true
    }
}
