//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import RenderKit

public protocol VoxelModel: NodeModel {
    var interpolation: PixelInterpolation { get set }
    var extend: ExtendMode { get set }
}
