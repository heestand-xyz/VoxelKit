//
//  VOX.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-04.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit
import Metal
import simd
import Combine
import CoreGraphics
import Resolution
import PixelColor

public class VOX: NODE3D, Equatable {
    
    @Published public var voxelModel: VoxelModel {
        didSet {
            guard !liveUpdatingModel else { return }
            modelUpdated()
            render()
        }
    }
    private var liveUpdatingModel: Bool = false
    
    public var renderObject: Render { VoxelKit.main.render }
    
    public var id: UUID {
        get { voxelModel.id }
        set { voxelModel.id = newValue }
    }
    public var name: String {
        get { voxelModel.name }
        set { voxelModel.name = newValue }
    }
    public var typeName: String {
        voxelModel.typeName
    }
    
    public var information: String? { nil }
    
    public var delegate: NODEDelegate?
    
    public var shaderName: String { "" }
    
    public var overrideBits: Bits? { nil }
    
    open var liveList: [LiveWrap] { [] }
    open var values: [Floatable] { [] }
    open var extraUniforms: [CGFloat] { [] }
    open var uniforms: [CGFloat] {
        var uniforms: [CGFloat] = values.flatMap(\.floats)
        uniforms.append(contentsOf: extraUniforms)
        return uniforms
    }
    
    open var uniformArray: [[CGFloat]]? { nil }
    public var uniformArrayMaxLimit: Int? { nil }
    public var uniformArrayLength: Int? { nil }
    public var uniformIndexArray: [[Int]]? { nil }
    public var uniformIndexArrayMaxLimit: Int? { nil }
    
     
    @Published public var finalResolution: Resolution = .square(8)
    @Published public var finalResolution3d: Resolution3D = .cube(8)
 
    
    public var clearColor: PixelColor = .clear {
        didSet {
            render()
        }
    }
    
    
    public var vertexUniforms: [CGFloat] { [] }
    public var shaderNeedsAspect: Bool { false }

    public var canRender: Bool = true
    
    public var bypass: Bool {
        get { voxelModel.bypass }
        set {
            voxelModel.bypass = newValue
            if newValue {
                if let nodeOut: NODEOutIO = self as? NODEOutIO {
                    for nodePath in nodeOut.outputPathList {
                        nodePath.nodeIn.render()
                    }
                }
            } else {
                render()
            }
        }
    }
    
    public var shaderNeedsResolution: Bool { false }
    
    public var _texture: MTLTexture?
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
            if newValue != nil {
                nextTextureAvailableCallback?()
            }
        }
    }
    public var didRenderTexture: Bool {
        _texture != nil
    }
    var nextTextureAvailableCallback: (() -> ())?
    public func nextTextureAvailable(_ callback: @escaping () -> ()) {
        nextTextureAvailableCallback = {
            callback()
            self.nextTextureAvailableCallback = nil
        }
    }
    
    open var additiveVertexBlending: Bool { false }
    
    public var view: NODEView!
    public var additionalViews: [NODEView] = []
    
    public var viewInterpolation: ViewInterpolation = .linear {
        didSet { view.metalView.viewInterpolation = viewInterpolation }
    }
    public var interpolation: PixelInterpolation {
        get { voxelModel.interpolation }
        set {
            voxelModel.interpolation = newValue
            updateSampler()
        }
    }
    public var extend: ExtendMode {
        get { voxelModel.extend }
        set {
            voxelModel.extend = newValue
            updateSampler()
        }
    }
    public var mipmap: MTLSamplerMipFilter = .linear { didSet { updateSampler() } }
    var compare: MTLCompareFunction = .never
    
    public var pipeline: MTLRenderPipelineState!
    public var pipeline3d: MTLComputePipelineState!
    public var sampler: MTLSamplerState!
    public var allGood: Bool {
        pipeline != nil && sampler != nil
    }
    
    public var customRenderActive: Bool = false
    public weak var customRenderDelegate: CustomRenderDelegate?
    public var customMergerRenderActive: Bool = false
    public weak var customMergerRenderDelegate: CustomMergerRenderDelegate?
    public var customGeometryActive: Bool = false
    public weak var customGeometryDelegate: CustomGeometryDelegate?
    open var customMetalLibrary: MTLLibrary? { nil }
    open var customVertexShaderName: String? { nil }
    open var customVertexTextureActive: Bool { false }
    open var customVertexNodeIn: (NODE & NODEOut)? { nil }
    open var customMatrices: [matrix_float4x4] { [] }
    
    public var renderInProgress = false
    public var renderQueue: [RenderRequest] = []
    public var renderIndex: Int = 0
    public var contentLoaded: Bool?
    var inputTextureAvailable: Bool?
    var generatorNotBypassed: Bool?
    
    static let metalLibrary: MTLLibrary = {
        do {
            return try VoxelKit.main.render.metalDevice.makeDefaultLibrary(bundle: Bundle.module)
        } catch {
            fatalError("Loading Metal Library Failed: \(error.localizedDescription)")
        }
    }()
    
    public var destroyed = false
    public var cancellables: [AnyCancellable] = []
    
    // MARK: - Life Cycle -
    
    init(model: VoxelModel) {
        voxelModel = model
        setupVOX()
    }
    
    // MARK: - Setup
    
    func setupVOX() {
        
        let pixelFormat: MTLPixelFormat = overrideBits?.pixelFormat ?? VoxelKit.main.render.bits.pixelFormat
        view = NODEView(with: VoxelKit.main.render, pixelFormat: pixelFormat)
        
        setupShader()
            
        VoxelKit.main.render.add(node: self)
        
        VoxelKit.main.logger.log(node: self, .detail, nil, "Linked with VoxelKit.", clean: true)
        
        for liveProp in liveList {
            liveProp.node = self
        }
        
    }
    
    func setupShader() {
        guard shaderName != "" else {
            VoxelKit.main.logger.log(node: self, .fatal, nil, "Shader not defined.")
            return
        }
        do {
            if self is NODEMetal == false {
                guard let compute = VOX.metalLibrary.makeFunction(name: shaderName) else {
                    VoxelKit.main.logger.log(node: self, .fatal, nil, "Setup of Metal Function \"\(shaderName)\" Failed")
                    return
                }
                pipeline3d = try VoxelKit.main.render.makeShaderPipeline3d(compute)
            }
            #if !os(tvOS) || !targetEnvironment(simulator)
            sampler = try VoxelKit.main.render.makeSampler(interpolate: interpolation.mtl, extend: extend.mtl, mipFilter: mipmap)
            #endif
        } catch {
            VoxelKit.main.logger.log(node: self, .fatal, nil, "Setup failed.", e: error)
        }
    }
    
    // MARK: - Sampler
    
    func updateSampler() {
        do {
            #if !os(tvOS) || !targetEnvironment(simulator)
            sampler = try VoxelKit.main.render.makeSampler(interpolate: interpolation.mtl, extend: extend.mtl, mipFilter: mipmap)
            #endif
            VoxelKit.main.logger.log(node: self, .info, nil, "New Sample Mode. Interpolate: \(interpolation) & Extend: \(extend)")
            render()
        } catch {
            VoxelKit.main.logger.log(node: self, .error, nil, "Error setting new Sample Mode. Interpolate: \(interpolation) & Extend: \(extend)", e: error)
        }
    }
    
    // MARK: - Model
    
    func modelUpdated() {
        modelUpdateLive()
    }
    
    /// Call `modelUpdateLiveDone()` in final class
    open func modelUpdateLive() {}
    public func modelUpdateLiveDone() {}
    
    // MARK: - Live
    
    public func liveValueChanged() {
        liveUpdateModel()
    }
    
    /// Call `liveUpdateModelDone()` in final class
    open func liveUpdateModel() {
        liveUpdatingModel = true
    }
    public func liveUpdateModelDone() {
        liveUpdatingModel = false
    }
    
    // MARK: - Render
    
    public func render() {
        guard renderObject.engine.renderMode == .auto else { return }
        renderObject.logger.log(node: self, .detail, .render, "Render Requested", loop: true)
        let renderRequest = RenderRequest(frameIndex: renderObject.frameIndex, node: self, completion: nil)
        queueRender(renderRequest)
    }
    
    open func didRender(renderPack: RenderPack) {
        self.texture = renderPack.response.texture
        renderIndex += 1
        delegate?.nodeDidRender(self)
        renderOuts(renderPack: renderPack)
        renderCustomVertexTexture()
    }
    
    public func clearRender() {
        texture = nil
        renderObject.logger.log(node: self, .info, .render, "Clear Render")
        removeRes()
    }
    
    // MARK: - Connect
    
    public func didConnect() {}
    
    public func didDisconnect() {
        removeRes()
    }
    
    // MARK: - Other
    
    public func destroy() {
        clearRender()
        VoxelKit.main.render.remove(node: self)
        texture = nil
        bypass = true
        destroyed = true
        view.destroy()
    }
    
}

public extension VOX {
    
    func addView() -> NODEView {
        let pixelFormat: MTLPixelFormat = overrideBits?.pixelFormat ?? VoxelKit.main.render.bits.pixelFormat
        let view = NODEView(with: renderObject, pixelFormat: pixelFormat)
        additionalViews.append(view)
        applyResolution { [weak self] in
            self?.render()
        }
        return view
    }
    
    func removeView(_ view: NODEView) {
        additionalViews.removeAll { nodeView in
            nodeView == view
        }
    }
    
}

// MARK: - Equals

extension VOX {
    
    public static func ==(lhs: VOX, rhs: VOX) -> Bool {
        lhs.id == rhs.id
    }
    
    public static func !=(lhs: VOX, rhs: VOX) -> Bool {
        lhs.id != rhs.id
    }
    
    public static func ==(lhs: VOX?, rhs: VOX) -> Bool {
        guard lhs != nil else { return false }
        return lhs!.id == rhs.id
    }
    
    public static func !=(lhs: VOX?, rhs: VOX) -> Bool {
        guard lhs != nil else { return false }
        return lhs!.id != rhs.id
    }
    
    public static func ==(lhs: VOX, rhs: VOX?) -> Bool {
        guard rhs != nil else { return false }
        return lhs.id == rhs!.id
    }
    
    public static func !=(lhs: VOX, rhs: VOX?) -> Bool {
        guard rhs != nil else { return false }
        return lhs.id != rhs!.id
    }
    
    public func isEqual(to node: NODE) -> Bool {
        self.id == node.id
    }
    
}
