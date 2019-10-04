//
//  VOXResolution.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-04.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import LiveValues
import RenderKit

extension VOX {

    public var renderResolution: Resolution {
        .custom(w: renderedResolution3d.x, h: renderedResolution3d.y)
    }
    
    public var renderedResolution3d: Resolution3D {
        return realResolution ?? ._8
    }

    public var realResolution: Resolution3D? {
        guard !bypass else {
            if let pixIn = self as? NODEInIO {
                return (pixIn.inputList.first as? VOX)?.realResolution
            }
            return nil
        }
        if let pixContent = self as? VOXContent {
            if let pixGenerator = pixContent as? VOXGenerator {
                return pixGenerator.resolution
            }
        }
        return nil
    }

    public func applyResolution(applied: @escaping () -> ()) {
        let res = renderResolution
        guard view.resolutionSize == nil || view.resolutionSize! != res.size.cg else {
            applied()
            return
        }
        view.setResolution(res)
        VoxelKit.main.logger.log(node: self, .info, .res, "Applied: \(res) [\(res.w)x\(res.h)]")
        applied()
        if let pixOut = self as? NODEOutIO {
            for pathList in pixOut.outputPathList {
                pathList.nodeIn.applyResolution(applied: {})
            }
        }
    }

    func removeRes() {
        view.setResolution(nil)
    }
        
}
