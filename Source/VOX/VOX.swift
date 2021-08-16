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

public class VOX: NODE3D, Equatable {
    
    public var renderObject: Render { VoxelKit.main.render }
    
    public let id: UUID
    public var name: String
    public let typeName: String
    
    public var delegate: NODEDelegate?
    
    public var shaderName: String { return "" }
    
    public var overrideBits: Bits? { nil }
    
    open var liveList: [LiveWrap] { [] }
    open var values: [Floatable] { [] }
    open var extraUniforms: [CGFloat] { [] }
    open var uniforms: [CGFloat] {
        var uniforms: [CGFloat] = values.flatMap(\.floats)
        uniforms.append(contentsOf: extraUniforms)
        return uniforms
    }
    
    open var uniformArray: [[CGFloat]] { [] }
    public var uniformArrayMaxLimit: Int? { nil }
    public var uniformIndexArray: [[Int]] { [] }
    public var uniformIndexArrayMaxLimit: Int? { nil }
    
     
    @Published public var finalResolution: Resolution = .square(8)
    @Published public var finalResolution3d: Resolution3D = .cube(8)
 
    
    public var vertexUniforms: [CGFloat] { return [] }
    public var shaderNeedsAspect: Bool { return false }

    public var bypass: Bool = false {
        didSet {
            guard !bypass else { return }
            render()
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
        return _texture != nil
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
    public var interpolation: PixelInterpolation = .linear { didSet { updateSampler() } }
    public var extend: ExtendMode = .zero { didSet { updateSampler() } }
    public var mipmap: MTLSamplerMipFilter = .linear { didSet { updateSampler() } }
    var compare: MTLCompareFunction = .never
    
    public var pipeline: MTLRenderPipelineState!
    public var pipeline3d: MTLComputePipelineState!
    public var sampler: MTLSamplerState!
    public var allGood: Bool {
        return pipeline != nil && sampler != nil
    }
    
    public var customRenderActive: Bool = false
    public weak var customRenderDelegate: CustomRenderDelegate?
    public var customMergerRenderActive: Bool = false
    public weak var customMergerRenderDelegate: CustomMergerRenderDelegate?
    public var customGeometryActive: Bool = false
    public weak var customGeometryDelegate: CustomGeometryDelegate?
    open var customMetalLibrary: MTLLibrary? { return nil }
    open var customVertexShaderName: String? { return nil }
    open var customVertexTextureActive: Bool { return false }
    open var customVertexNodeIn: (NODE & NODEOut)? { return nil }
    open var customMatrices: [matrix_float4x4] { return [] }
    
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
    
    init(name: String, typeName: String) {
        
        id = UUID()
        self.name = name
        self.typeName = typeName
        
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
    
    // MARK: - Codable
    
    enum VOXCodingKeys: CodingKey {
        case id
        case name
        case typeName
        case bypass
        case viewInterpolation
        case interpolation
        case extend
        case mipmap
        case compare
        case liveList
    }
    
    enum LiveTypeCodingKey: CodingKey {
        case type
    }

    private struct EmptyDecodable: Decodable {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: VOXCodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        typeName = try container.decode(String.self, forKey: .typeName)
        bypass = try container.decode(Bool.self, forKey: .bypass)
        viewInterpolation = try container.decode(ViewInterpolation.self, forKey: .viewInterpolation)
        interpolation = try container.decode(PixelInterpolation.self, forKey: .interpolation)
        extend = try container.decode(ExtendMode.self, forKey: .extend)
        mipmap = MTLSamplerMipFilter(rawValue: try container.decode(UInt.self, forKey: .mipmap))!
        compare = MTLCompareFunction(rawValue: try container.decode(UInt.self, forKey: .compare))!
        
        if Thread.isMainThread {
            setupVOX()
        } else {
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.main.async { [weak self] in
                self?.setupVOX()
                group.leave()
            }
            group.wait()
        }
        
        var liveCodables: [LiveCodable] = []
        var liveListContainer = try container.nestedUnkeyedContainer(forKey: .liveList)
        var liveListContainerMain = liveListContainer
        while(!liveListContainer.isAtEnd) {
            let liveTypeContainer = try liveListContainer.nestedContainer(keyedBy: LiveTypeCodingKey.self)
            guard let liveType: LiveType = try? liveTypeContainer.decode(LiveType.self, forKey: .type) else {
                _ = try? liveListContainerMain.decode(EmptyDecodable.self)
                continue
            }
            let liveCodable: LiveCodable = try liveListContainerMain.decode(liveType.liveCodableType)
            liveCodables.append(liveCodable)
        }
        for liveCodable in liveCodables {
            guard let liveWrap: LiveWrap = liveList.first(where: { $0.typeName == liveCodable.typeName }) else { continue }
            liveWrap.setLiveCodable(liveCodable)
        }
        
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: VOXCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(typeName, forKey: .typeName)
        try container.encode(bypass, forKey: .bypass)
        try container.encode(viewInterpolation, forKey: .viewInterpolation)
        try container.encode(interpolation, forKey: .interpolation)
        try container.encode(extend, forKey: .extend)
        try container.encode(mipmap.rawValue, forKey: .mipmap)
        try container.encode(compare.rawValue, forKey: .compare)
        try container.encode(liveList.map({ $0.getLiveCodable() }), forKey: .liveList)
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
        return lhs.id == rhs.id
    }
    
    public static func !=(lhs: VOX, rhs: VOX) -> Bool {
        return lhs.id != rhs.id
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
