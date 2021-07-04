//
//  VOXResolution.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-04.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit
import Resolution

extension VOX {

    public var renderResolution: Resolution {
        .custom(w: renderedResolution3d.x, h: renderedResolution3d.y)
    }
    
    public var renderedResolution3d: Resolution3D {
        derivedResolution ?? ._8
    }

    public var derivedResolution: Resolution3D? {
        guard !bypass else {
            if let voxIn = self as? NODEInIO {
                return (voxIn.inputList.first as? VOX)?.derivedResolution
            }
            return nil
        }
        if let voxContent = self as? VOXContent {
            if let voxGenerator = voxContent as? VOXGenerator {
                return voxGenerator.resolution
            } else if let voxResource = voxContent as? VOXResource {
                return voxResource.resolution
            }
        } else if let voxEffect = self as? VOXEffect {
            if let resPix = self as? ResolutionVOX {
                return resPix.resolution
            } else if let nodeRes3d = self as? NODEResolution3D {
                return nodeRes3d.resolution
            }
            guard let inRes = (voxEffect.inputList.first as? VOX)?.derivedResolution else {
//                print("\(name) >>>>>>>>>>> X", voxEffect.inputList.map(\.name))
                return nil
            }
//            print("\(name) >>>>>>>>>>> =D", voxEffect.inputList.map(\.name))
            return inRes
        }
        return nil
    }

    public func applyResolution(applied: @escaping () -> ()) {
        let res = renderedResolution3d
        finalResolution = .custom(w: res.x, h: res.y)
        finalResolution3d = res
        VoxelKit.main.logger.log(node: self, .info, .resolution, "Apply Resolution: \(res) (\(res.count))")
        applied()
//        let res = renderResolution
//        guard view.resolutionSize == nil || view.resolutionSize! != res.size.cg else {
//            applied()
//            return
//        }
//        view.setResolution(res)
//        VoxelKit.main.logger.log(node: self, .info, .res, "Applied: \(res) [\(res.w)x\(res.h)]")
//        applied()
//        if let voxOut = self as? NODEOutIO {
//            for pathList in voxOut.outputPathList {
//                pathList.nodeIn.applyResolution(applied: {})
//            }
//        }
    }

    func removeRes() {
        view.setResolution(nil)
    }
        
}
