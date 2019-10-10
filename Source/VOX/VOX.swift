//
//  VOX.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-04.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import LiveValues
import RenderKit
import Metal
import simd

public class VOX: NODE3D, Equatable {
    
    public let id = UUID()
    public var name: String?
    
    public var delegate: NODEDelegate?
    
    public var shaderName: String { return "" }
    
    public var view: NODEView
    
    open var liveValues: [LiveValue] { return [] }
    open var preUniforms: [CGFloat] { return [] }
    open var postUniforms: [CGFloat] { return [] }
    open var uniforms: [CGFloat] {
        var vals: [CGFloat] = []
        vals.append(contentsOf: preUniforms)
        for liveValue in liveValues {
            if let liveFloat = liveValue as? LiveFloat {
                vals.append(liveFloat.uniform)
            } else if let liveInt = liveValue as? LiveInt {
                vals.append(CGFloat(liveInt.uniform))
            } else if let liveBool = liveValue as? LiveBool {
                vals.append(liveBool.uniform ? 1.0 : 0.0)
            } else if let liveColor = liveValue as? LiveColor {
                vals.append(contentsOf: liveColor.colorCorrect.uniformList)
            } else if let livePoint = liveValue as? LivePoint {
                vals.append(contentsOf: livePoint.uniformList)
            } else if let liveSize = liveValue as? LiveSize {
                vals.append(contentsOf: liveSize.uniformList)
            } else if let liveRect = liveValue as? LiveRect {
                vals.append(contentsOf: liveRect.uniformList)
            } else if let liveVec = liveValue as? LiveVec {
                vals.append(contentsOf: liveVec.uniformList)
            }
        }
        vals.append(contentsOf: postUniforms)
        return vals
    }
    
    public var liveArray: [[LiveFloat]] { return [] }
    open var uniformArray: [[CGFloat]] {
        return liveArray.map({ liveFloats -> [CGFloat] in
            return liveFloats.map({ liveFloat -> CGFloat in
                return liveFloat.uniform
            })
        })
    }
    public var uniformArrayMaxLimit: Int? { nil }
    public var uniformIndexArray: [[Int]] { [] }
    public var uniformIndexArrayMaxLimit: Int? { nil }
    
    
    public var needsRender: Bool = false {
        didSet {
            guard needsRender else { return }
            guard VoxelKit.main.render.engine.renderMode == .direct else { return }
            VoxelKit.main.render.engine.renderNODE(self, done: { _ in })
        }
    }
    public var rendering: Bool = false
    public var inRender: Bool = false
    public var renderIndex: Int = 0
    
    public var bypass: Bool = false
    
    public var contentLoaded: Bool?
    
    public var vertexUniforms: [CGFloat] { return [] }
    
    public var shaderNeedsAspect: Bool { return false }
    
    public var pipeline: MTLRenderPipelineState!
    public var pipeline3d: MTLComputePipelineState!
    public var sampler: MTLSamplerState!
    public var interpolate: InterpolateMode = .linear { didSet { updateSampler() } }
    public var extend: ExtendMode = .zero { didSet { updateSampler() } }
    public var mipmap: MTLSamplerMipFilter = .linear { didSet { updateSampler() } }
    var compare: MTLCompareFunction = .never
    
    public var customRenderActive: Bool = false
    public var customRenderDelegate: CustomRenderDelegate?
    public var customMergerRenderActive: Bool = false
    public var customMergerRenderDelegate: CustomMergerRenderDelegate?
    public var customGeometryActive: Bool = false
    public var customGeometryDelegate: CustomGeometryDelegate?
    public var customMetalLibrary: MTLLibrary? { return nil }
    public var customVertexShaderName: String? { return nil }
    public var customVertexTextureActive: Bool { return false }
    public var customVertexNodeIn: (NODE & NODEOut)? { return nil }
    public var customMatrices: [matrix_float4x4] { return [] }
    public var customLinkedNodes: [NODE] = []
    
    public var destroyed: Bool = false
    
    // MARK: Texture
    
    var _texture: MTLTexture?
    public var texture: MTLTexture? {
        get {
            guard !bypass else {
                guard let input = self as? NODEInIO else { return nil }
                return input.inputList.first?.texture
            }
            return _texture
        }
        set {
            _texture = newValue
            nextTextureAvalibleCallback?()
        }
    }
    public var didRenderTexture: Bool {
        return _texture != nil
    }
    var nextTextureAvalibleCallback: (() -> ())?
    public func nextTextureAvalible(_ callback: @escaping () -> ()) {
        nextTextureAvalibleCallback = {
            callback()
            self.nextTextureAvalibleCallback = nil
        }
    }
    
    // MARK: - Life Cycle
    
    init() {
        
        view = NODEView(with: VoxelKit.main.render)
        
        setupShader()
            
        VoxelKit.main.render.add(node: self)
        
        VoxelKit.main.logger.log(node: self, .detail, nil, "Linked with PixelKit.", clean: true)
    
    }
    
    // MARK: - Setup
    
    func setupShader() {
        guard shaderName != "" else {
            VoxelKit.main.logger.log(node: self, .fatal, nil, "Shader not defined.")
            return
        }
        do {
            let compute = try VoxelKit.main.render.makeFrag(shaderName, with: customMetalLibrary, from: self)
            pipeline3d = try VoxelKit.main.render.makeShaderPipeline3d(compute)
            #if !os(tvOS) || !targetEnvironment(simulator)
            sampler = try VoxelKit.main.render.makeSampler(interpolate: interpolate.mtl, extend: extend.mtl, mipFilter: mipmap)
            #endif
        } catch {
            VoxelKit.main.logger.log(node: self, .fatal, nil, "Setup failed.", e: error)
        }
    }
    
    // MARK: - Sampler
    
    func updateSampler() {
        do {
            #if !os(tvOS) || !targetEnvironment(simulator)
            sampler = try VoxelKit.main.render.makeSampler(interpolate: interpolate.mtl, extend: extend.mtl, mipFilter: mipmap)
            #endif
            VoxelKit.main.logger.log(node: self, .info, nil, "New Sample Mode. Interpolate: \(interpolate) & Extend: \(extend)")
            setNeedsRender()
        } catch {
            VoxelKit.main.logger.log(node: self, .error, nil, "Error setting new Sample Mode. Interpolate: \(interpolate) & Extend: \(extend)", e: error)
        }
    }
    
    // MARK: - Render
    
    public func setNeedsRender() {
        guard !bypass || self is VOXGenerator else {
            renderOuts()
            return
        }
        guard !needsRender else { return }
//        guard view.metalView.resolution != nil else {
//            VoxelKit.main.logger.log(node: self, .warning, .render, "Metal View res not set.", loop: true)
//            VoxelKit.main.logger.log(node: self, .debug, .render, "Auto applying Resolution...", loop: true)
//            applyResolution {
//                self.setNeedsRender()
//            }
//            return
//        }
        VoxelKit.main.logger.log(node: self, .detail, .render, "Requested.", loop: true)
        needsRender = true
    }
        
    func renderOuts() {
        if let voxOut = self as? NODEOutIO {
            for voxOutPath in voxOut.outputPathList {
                let vox = voxOutPath.nodeIn
                guard !vox.destroyed else { continue }
                guard vox.id != self.id else {
                    VoxelKit.main.logger.log(node: self, .error, .render, "Connected to self.")
                    continue
                }
                vox.setNeedsRender()
            }
        }
    }

    public func didRender(texture: MTLTexture, force: Bool) {
        self.texture = texture
        renderIndex += 1
        delegate?.nodeDidRender(self)
        if VoxelKit.main.render.engine.renderMode != .frameTree {
            for customLinkedVox in customLinkedNodes {
                customLinkedVox.setNeedsRender()
            }
            if !force { // CHECK the force!
                renderOuts()
//                renderCustomVertexTexture()
            }
        }
    }
    
    // MARK: - Connect
    
    func setNeedsConnectSingle(new newInVox: (NODE & NODEOut)?, old oldInVox: (NODE & NODEOut)?) {
        guard var voxInIO = self as? VOX & NODEInIO else { VoxelKit.main.logger.log(node: self, .error, .connection, "NODEIn's Only"); return }
        if let oldVoxOut = oldInVox {
            var voxOut = oldVoxOut as! (VOX & NODEOutIO)
            for (i, voxOutPath) in voxOut.outputPathList.enumerated() {
                if voxOutPath.nodeIn.id == voxInIO.id {
                    voxOut.outputPathList.remove(at: i)
                    break
                }
            }
            voxInIO.inputList = []
            VoxelKit.main.logger.log(node: self, .info, .connection, "Disonnected Single: \(voxOut)")
        }
        if let newVoxOut = newInVox {
            guard newVoxOut.id != self.id else {
                VoxelKit.main.logger.log(node: self, .error, .connection, "Can't connect to self.")
                return
            }
            var voxOut = newVoxOut as! (VOX & NODEOutIO)
            voxInIO.inputList = [voxOut]
            voxOut.outputPathList.append(NODEOutPath(nodeIn: voxInIO, inIndex: 0))
            applyResolution { self.setNeedsRender() }
            VoxelKit.main.logger.log(node: self, .info, .connection, "Connected Single: \(voxOut)")
        } else {
            disconnected()
        }
    }
    
    func setNeedsConnectMerger(new newInVox: (NODE & NODEOut)?, old oldInVox: (NODE & NODEOut)?, second: Bool) {
        guard var voxInIO = self as? VOX & NODEInIO else { VoxelKit.main.logger.log(node: self, .error, .connection, "NODEIn's Only"); return }
        guard let voxInMerger = self as? NODEInMerger else { return }
        if let oldVoxOut = oldInVox {
            var voxOut = oldVoxOut as! (VOX & NODEOutIO)
            for (i, voxOutPath) in voxOut.outputPathList.enumerated() {
                if voxOutPath.nodeIn.id == voxInIO.id {
                    voxOut.outputPathList.remove(at: i)
                    break
                }
            }
            voxInIO.inputList = []
            VoxelKit.main.logger.log(node: self, .info, .connection, "Disonnected Merger: \(voxOut)")
        }
        if let newVoxOut = newInVox {
            if var voxOutA = (!second ? newVoxOut : voxInMerger.inputA) as? (VOX & NODEOutIO),
                var voxOutB = (second ? newVoxOut : voxInMerger.inputB) as? (VOX & NODEOutIO) {
                voxInIO.inputList = [voxOutA, voxOutB]
                voxOutA.outputPathList.append(NODEOutPath(nodeIn: voxInIO, inIndex: 0))
                voxOutB.outputPathList.append(NODEOutPath(nodeIn: voxInIO, inIndex: 1))
                applyResolution { self.setNeedsRender() }
                VoxelKit.main.logger.log(node: self, .info, .connection, "Connected Merger: \(voxOutA), \(voxOutB)")
            }
        } else {
            disconnected()
        }
    }
    
    func setNeedsConnectMulti(new newInVoxs: [NODE & NODEOut], old oldInVoxs: [NODE & NODEOut]) {
        guard var voxInIO = self as? VOX & NODEInIO else { VoxelKit.main.logger.log(node: self, .error, .connection, "NODEIn's Only"); return }
        voxInIO.inputList = newInVoxs
        for oldInVox in oldInVoxs {
            if var input = oldInVox as? (VOX & NODEOutIO) {
                for (j, voxOutPath) in input.outputPathList.enumerated() {
                    if voxOutPath.nodeIn.id == voxInIO.id {
                        input.outputPathList.remove(at: j)
                        break
                    }
                }
            }
        }
        for (i, newInVox) in newInVoxs.enumerated() {
            if var input = newInVox as? (VOX & NODEOutIO) {
                input.outputPathList.append(NODEOutPath(nodeIn: voxInIO, inIndex: i))
            }
        }
        if newInVoxs.isEmpty {
            disconnected()
        }
        VoxelKit.main.logger.log(node: self, .info, .connection, "Connected Multi: \(newInVoxs)")
        applyResolution { self.setNeedsRender() }
    }
    
    func disconnected() {
        removeRes()
    }
    
    // MARK: - Other
    
    public func checkLive() {
        for liveValue in liveValues {
            if liveValue.uniformIsNew {
                setNeedsRender()
                break
            }
        }
        for liveValues in liveArray {
            for liveValue in liveValues {
                if liveValue.uniformIsNew {
                    setNeedsRender()
                    break
                }
            }
        }
    }
    
    public func destroy() {
        VoxelKit.main.render.remove(node: self)
        texture = nil
        bypass = true
        destroyed = true
    }
    
    public func isEqual(to node: NODE) -> Bool {
        id == node.id
    }
    
    public static func == (lhs: VOX, rhs: VOX) -> Bool {
        lhs.id == rhs.id
    }
    
}
