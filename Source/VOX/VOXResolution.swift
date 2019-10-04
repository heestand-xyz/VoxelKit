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
        realResolution ?? .auto(render: VoxelKit.main.render)
    }

    public var realResolution: Resolution? {
        guard !bypass else {
            if let pixIn = self as? NODEInIO {
                return (pixIn.inputList.first as? VOX)?.realResolution
            } else { return nil }
        }
        
        return nil
//        if let pixContent = self as? VOXContent {
//            if let pixResource = pixContent as? VOXResource {
//                /// ...
//                return nil
//            } else if let pixGenerator = pixContent as? VOXGenerator {
//                return pixGenerator.resolution
//            } else if let pixSprite = pixContent as? VOXSprite {
//                return .cgSize(pixSprite.scene?.size ?? CGSize(width: 128, height: 128))
//            } else if let pixCustom = pixContent as? VOXCustom {
//                return pixCustom.resolution
//            } else { return nil }
//        } else if let resPix = self as? ResolutionVOX {
//            let resRes: Resolution
//            if resPix.inheritInResolution {
//                guard let inResolution = (resPix.inputList.first as? VOX)?.realResolution else { return nil }
//                resRes = inResolution
//            } else {
//                resRes = resPix.resolution
//            }
//            return resRes * resPix.resMultiplier
//        } else if let pixIn = self as? VOX & NODEInIO {
//            if let remapPix = pixIn as? RemapVOX {
//                guard let inResB = (remapPix.inputB as? VOX)?.realResolution else { return nil }
//                return inResB
//            }
//            guard let inRes = (pixIn.inputList.first as? VOX)?.realResolution else { return nil }
//            if let cropPix = self as? CropVOX {
//                return .size(inRes.size * LiveSize(cropPix.resScale))
//            } else if let convertPix = self as? ConvertVOX {
//                return .size(inRes.size * LiveSize(convertPix.resScale))
//            } else if let flipFlopPix = self as? FlipFlopVOXVOXVOX {
//                return flipFlopPix.flop != .none ? Resolution(inRes.raw.flopped) : inRes
//            }
//            return inRes
//        } else { return nil }
    }

    public func nextRealResolution(callback: @escaping (Resolution) -> ()) {
        if let res = realResolution {
            callback(res)
            return
        }
        VoxelKit.main.render.delay(frames: 1, done: {
            self.nextRealResolution(callback: callback)
        })
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
