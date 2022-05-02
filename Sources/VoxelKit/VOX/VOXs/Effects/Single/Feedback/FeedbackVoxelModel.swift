//
//  Created by Anton Heestand on 2022-01-16.
//

import Foundation
import CoreGraphics
import RenderKit
import Resolution
import PixelColor
import simd

public struct FeedbackVoxelModel: VoxelSingleEffectModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Feedback"
    public var typeName: String = "vox-effect-single-feedback"
    public var bypass: Bool = false
    
    public var inputNodeReferences: [NodeReference] = []
    public var outputNodeReferences: [NodeReference] = []

    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .zero
    
    // MARK: Local
    
    public var feedbackInputNodeReference: NodeReference?
    public var feedActive: Bool = true
}

extension FeedbackVoxelModel {
    
    public func isEqual(to nodeModel: NodeModel) -> Bool {
        guard let voxelModel = nodeModel as? Self else { return false }
        guard isVoxelSingleEffectEqual(to: voxelModel) else { return false }
        guard feedbackInputNodeReference == voxelModel.feedbackInputNodeReference else { return false }
        guard feedActive == voxelModel.feedActive else { return false }
        return true
    }
}
