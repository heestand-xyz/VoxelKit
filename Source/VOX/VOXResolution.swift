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
        return realResolution ?? ._8
    }

    public var realResolution: Resolution3D? {
        guard !bypass else {
            if let voxIn = self as? NODEInIO {
                return (voxIn.inputList.first as? VOX)?.realResolution
            }
            return nil
        }
        if let voxContent = self as? VOXContent {
            if let voxGenerator = voxContent as? VOXGenerator {
                return voxGenerator.resolution
            }
        } else if let voxIn = self as? VOX & NODEInIO {
            if #available(iOS 11.3, *) {
                if let resPix = self as? ResolutionVOX {
                    return resPix.resolution
                }
            }
//            if let remapPix = voxIn as? RemapPIX {
//                guard let inResB = (remapPix.inputB as? PIX)?.realResolution else { return nil }
//                return inResB
//            }
            guard let inRes = (voxIn.inputList.first as? VOX)?.realResolution else { return nil }
//            if let cropPix = self as? CropPIX {
//                return .size(inRes.size * LiveSize(cropPix.resScale))
//            } else if let convertPix = self as? ConvertPIX {
//                return .size(inRes.size * LiveSize(convertPix.resScale))
//            } else if let flipFlopPix = self as? FlipFlopPIX {
//                return flipFlopPix.flop != .none ? Resolution(inRes.raw.flopped) : inRes
//            }
            return inRes
        }
        if let nodeRes3d = self as? NODEResolution3D {
            return nodeRes3d.resolution
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
