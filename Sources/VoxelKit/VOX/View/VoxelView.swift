//
//  File.swift
//  
//
//  Created by Anton Heestand on 2021-09-25.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif
import MetalKit
import ModelIO
import simd
import SwiftUI
import RenderKit

#if os(macOS)
public struct VoxelView: NSViewRepresentable {
    let vox: VOX
    public init(vox: VOX) {
        self.vox = vox
    }
    public func makeNSView(context: Context) -> UINSVoxelView {
        UINSVoxelView(vox: vox)
    }
    public func updateNSView(_ nsView: UINSVoxelView, context: Context) {}
}
#else
public struct VoxelView: UIViewRepresentable {
    let vox: VOX
    public init(vox: VOX) {
        self.vox = vox
    }
    public func makeUIView(context: Context) -> UINSVoxelView {
        UINSVoxelView(vox: vox)
    }
    public func updateUIView(_ uiView: UINSVoxelView, context: Context) {}
}
#endif

public class UINSVoxelView: MTKView {

    static let constantBufferLength = 65_536

    static let metalDevice: MTLDevice = {
        VoxelKit.main.render.metalDevice
    }()
    
    var renderPipelineState: MTLRenderPipelineState?
    let depthStencilState: MTLDepthStencilState
    
    let constantBuffer: MTLBuffer
    
    var mesh: MTKMesh?
    
    var camera = Camera() {
        didSet {
            render()
        }
    }
    
    let vox: VOX
    
    public init(vox: VOX) {
        
        self.vox = vox
        
        depthStencilState = UINSVoxelView.makeDepthStencilState()
        
        constantBuffer = UINSVoxelView.metalDevice.makeBuffer(length: UINSVoxelView.constantBufferLength, options: [.storageModeShared])!
        
        mesh = try? UINSVoxelView.mesh()
        
        super.init(frame: .zero, device: UINSVoxelView.metalDevice)
        
        sampleCount = 1
        colorPixelFormat = .bgra8Unorm
        depthStencilPixelFormat = .depth32Float

        renderPipelineState = try? UINSVoxelView.makeRenderPipelineState(view: self, vertexDescriptor: UINSVoxelView.vertexDescriptor)
        
        if renderPipelineState == nil || mesh == nil {
            VoxelKit.main.logger.log(.error, .render, "Voxel View Did Not Initialize Correctly")
        }
        
        vox.delegate = self
        
#if DEBUG
        var cameraAngle: Float = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.camera.transform = float4x4(rotationAroundAxis: SIMD3<Float>(x: 0, y: 1, z: 0), by: cameraAngle) * float4x4(translationBy: SIMD3<Float>(0, 0, 15))
            cameraAngle += 0.01
        }
#endif
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UINSVoxelView: NODEDelegate {
    public func nodeDidRender(_ node: NODE) {
        render()
    }
}

extension UINSVoxelView {
    
    struct Camera {
    
        var fieldOfView: Float = 60.0
        var nearZ: Float = 0.1
        var farZ: Float = 100.0
        
        var transform: float4x4 = float4x4(translationBy: SIMD3<Float>(0, 0, 10.0))
        
        func projectionMatrix(aspectRatio: Float) -> float4x4 {
            float4x4(perspectiveProjectionRHFovY: radians_from_degrees(fieldOfView),
                            aspectRatio: aspectRatio,
                            nearZ: nearZ,
                            farZ: farZ)
        }

    }
    
}

extension UINSVoxelView {
    
    static func mesh() throws -> MTKMesh {
        let meshAllocator = MTKMeshBufferAllocator(device: Self.metalDevice)
        let mdlMesh = MDLMesh.init(sphereWithExtent: SIMD3<Float>(x: 2.0, y: 2.0, z: 2.0),
                                   segments: SIMD2<UInt32>(20, 20),
                                   inwardNormals: false,
                                   geometryType: .triangles,
                                   allocator: meshAllocator)
        return try MTKMesh(mesh: mdlMesh, device: Self.metalDevice)
    }
    
}

extension UINSVoxelView {
    
    public func render() {
        
        VoxelKit.main.logger.log(.detail, .render, "Voxel View Will Render")
        
        guard let commandBuffer = VoxelKit.main.render.commandQueue.makeCommandBuffer() else { return }
        guard let renderPassDescriptor = currentRenderPassDescriptor else { return }
        guard let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        draw(in: renderCommandEncoder)
        
        renderCommandEncoder.endEncoding()
        
        if let drawable = currentDrawable {
            commandBuffer.present(drawable)
        }
        
        commandBuffer.addCompletedHandler { _ in
            VoxelKit.main.logger.log(.detail, .render, "Voxel View Did Render")
        }
        
        commandBuffer.commit()
    }
    
}

extension UINSVoxelView {
    
    func draw(in renderCommandEncoder: MTLRenderCommandEncoder) {
        
        guard let renderPipelineState = renderPipelineState else { return }
        
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)
        renderCommandEncoder.setDepthStencilState(depthStencilState)
        
        let viewMatrix = camera.transform.inverse

        let viewport = bounds
        let width = Float(viewport.size.width)
        let height = Float(viewport.size.height)
        let aspectRatio = width / height

        let projectionMatrix = camera.projectionMatrix(aspectRatio: aspectRatio)
        
        let worldMatrix = matrix_identity_float4x4
        
        renderCommandEncoder.setVertexBuffer(constantBuffer, offset: 0, index: 1)
        
        draw(worldTransform: worldMatrix,
             viewMatrix: viewMatrix,
             projectionMatrix: projectionMatrix,
             in: renderCommandEncoder)
    }
    
    func draw(worldTransform: float4x4, viewMatrix: float4x4, projectionMatrix: float4x4, in renderCommandEncoder: MTLRenderCommandEncoder) {
        
        guard let mesh = mesh else { return }
        
        let nodeTransform = matrix_identity_float4x4
        let worldMatrix = worldTransform * nodeTransform
        
        var constants = InstanceConstants(modelViewProjectionMatrix: projectionMatrix * viewMatrix * worldMatrix,
                                          normalMatrix: viewMatrix * worldMatrix,
                                          color: SIMD4<Float>(x: 1.0, y: 0.5, z: 0.5, w: 1.0))
        
        memcpy(constantBuffer.contents(), &constants, MemoryLayout<InstanceConstants>.size)
        
        renderCommandEncoder.setVertexBufferOffset(0, index: 1)
        
        for (index, vertexBuffer) in mesh.vertexBuffers.enumerated() {
            renderCommandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: index)
        }
        
        for submesh in mesh.submeshes {
            let fillMode: MTLTriangleFillMode = .lines // .fill
            renderCommandEncoder.setTriangleFillMode(fillMode)
            renderCommandEncoder.drawIndexedPrimitives(type: submesh.primitiveType,
                                                       indexCount: submesh.indexCount,
                                                       indexType: submesh.indexType,
                                                       indexBuffer: submesh.indexBuffer.buffer,
                                                       indexBufferOffset: submesh.indexBuffer.offset)
        }
        
    }
    
}

extension UINSVoxelView {
    
    static func makeRenderPipelineState(view: MTKView, vertexDescriptor: MDLVertexDescriptor) throws -> MTLRenderPipelineState {
                
        let vertexFunction = VOX.metalLibrary.makeFunction(name: "voxelViewVertex")
        let fragmentFunction = VOX.metalLibrary.makeFunction(name: "voxelViewFragment")
        
        let mtlVertexDescriptor = MTKMetalVertexDescriptorFromModelIO(vertexDescriptor)
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.vertexDescriptor = mtlVertexDescriptor
        pipelineDescriptor.sampleCount = view.sampleCount
        pipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = view.depthStencilPixelFormat

        return try Self.metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
}

extension UINSVoxelView {
    
    static let vertexDescriptor: MDLVertexDescriptor = {
        let vertexDescriptor = MDLVertexDescriptor()
        vertexDescriptor.vertexAttributes[0].name = MDLVertexAttributePosition
        vertexDescriptor.vertexAttributes[0].format = .float3
        vertexDescriptor.vertexAttributes[0].offset = 0
        vertexDescriptor.vertexAttributes[0].bufferIndex = 0
        vertexDescriptor.vertexAttributes[1].name = MDLVertexAttributeNormal
        vertexDescriptor.vertexAttributes[1].format = .float3
        vertexDescriptor.vertexAttributes[1].offset = MemoryLayout<Float>.size * 3
        vertexDescriptor.vertexAttributes[1].bufferIndex = 0
        vertexDescriptor.bufferLayouts[0].stride = MemoryLayout<Float>.size * 6
        return vertexDescriptor
    }()
    
}

extension UINSVoxelView {
    
    static func makeDepthStencilState() -> MTLDepthStencilState {
        let depthStateDescriptor = MTLDepthStencilDescriptor()
        depthStateDescriptor.depthCompareFunction = .less
        depthStateDescriptor.isDepthWriteEnabled = true
        return Self.metalDevice.makeDepthStencilState(descriptor: depthStateDescriptor)!
    }
    
}
