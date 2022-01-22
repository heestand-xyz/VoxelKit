//
//  FeedbackVOX.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-08-21.
//  Open Source - MIT License
//

import RenderKit
import Metal
import CoreGraphics

public class FeedbackVOX: VOXSingleEffect {
    
    public typealias Model = FeedbackVoxelModel
    
    private var model: Model {
        get { singleEffectModel as! Model }
        set { singleEffectModel = newValue }
    }
    
    override open var shaderName: String { return "nilVOX" }
    
    // MARK: - Private Properties
    
    var readyToFeed: Bool = false
    var feedReset: Bool = false

    // MARK: - Public Properties
    
    var feedTexture: MTLTexture? {
        guard let texture = feedbackInput?.texture else { return nil }
        return try? Texture.copy3D(texture: texture, on: VoxelKit.main.render.metalDevice, in: VoxelKit.main.render.commandQueue)
    }
    
    @LiveBool("feedActive") public var feedActive: Bool = true
    public var feedbackInput: (VOX & NODEOut)? {
        didSet {
            if let feedbackInput: VOX = feedbackInput {
                model.feedbackInputNodeReference = NodeReference(node: feedbackInput, connection: .single)
            } else {
                model.feedbackInputNodeReference = nil
            }
            if feedActive {
                render()
            }
        }
    }
    
    public override var liveList: [LiveWrap] {
        [_feedActive]
    }
    
    // MARK: - Life Cycle -
    
    public init(model: Model) {
        super.init(model: model)
        setup()
    }
    
    public required init() {
        let model = Model()
        super.init(model: model)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        VoxelKit.main.render.listenToFramesUntil {
            if self.input?.texture != nil && self.feedTexture != nil {
                self.render()
                return .done
            } else {
                return .continue
            }
        }
    }
    
    // MARK: - Live Model
    
    public override func modelUpdateLive() {
        super.modelUpdateLive()
        
        feedActive = model.feedActive
        
        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        
        model.feedActive = feedActive
        
        super.liveUpdateModelDone()
    }
    
    // MARK: - Feedback
    
    func tileFeedTexture(at tileIndex: TileIndex) -> MTLTexture? {
        guard let tileFeedVox = feedbackInput as? VOX & NODETileable3D else {
            VoxelKit.main.logger.log(node: self, .error, .texture, "Feed Input VOX Not Tileable.")
            return nil
        }
        guard let texture = tileFeedVox.tileTextures?[tileIndex.z][tileIndex.y][tileIndex.x] else { return nil }
        return try? Texture.copy3D(texture: texture, on: VoxelKit.main.render.metalDevice, in: VoxelKit.main.render.commandQueue)
    }
    
    public override func didRender(renderPack: RenderPack) {
        super.didRender(renderPack: renderPack)
        if feedReset {
            feedActive = true
            feedReset = false
        }
        readyToFeed = true
        render()
    }
    
    public func resetFeed() {
        guard feedActive else {
            VoxelKit.main.logger.log(node: self, .info, .effect, "Feedback reset; feed not active.")
            return
        }
        feedActive = false
        feedReset = true
        render()
    }
    
}

public extension NODEOut {
    
    func _feed(_ fraction: CGFloat = 1.0, loop: ((FeedbackVOX) -> (VOX & NODEOut))? = nil) -> FeedbackVOX {
        let feedbackPix = FeedbackVOX()
        feedbackPix.name = "feed:feedback"
        feedbackPix.input = self as? VOX & NODEOut
        let crossPix = CrossVOX()
        crossPix.name = "feed:cross"
        crossPix.inputA = self as? VOX & NODEOut
        crossPix.inputB = loop?(feedbackPix) ?? feedbackPix
        crossPix.fraction = fraction
        feedbackPix.feedbackInput = crossPix
        return feedbackPix
    }
    
}
