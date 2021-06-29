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
    
    override open var shaderName: String { return "nilVOX" }
    
    // MARK: - Private Properties
    
    var readyToFeed: Bool = false
    var feedReset: Bool = false

    // MARK: - Public Properties
    
    var feedTexture: MTLTexture? {
        guard let texture = feedbackInput?.texture else { return nil }
        return try? Texture.copy3D(texture: texture, on: VoxelKit.main.render.metalDevice, in: VoxelKit.main.render.commandQueue)
    }
    
    @LiveBool("feedbackActive") public var feedbackActive: Bool = true
    public var feedbackInput: (VOX & NODEOut)? { didSet { if feedbackActive { render() } } }
    
    public override var liveList: [LiveWrap] {
        [_feedbackActive]
    }
    
    public required init() {
        super.init(name: "Feedback", typeName: "vox-effect-single-feedback")
        VoxelKit.main.render.listenToFramesUntil {
            if self.input?.texture != nil && self.feedTexture != nil {
                self.render()
                return .done
            } else {
                return .continue
            }
        }
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
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
            feedbackActive = true
            feedReset = false
        }
        readyToFeed = true
        render()
    }
    
    public func resetFeed() {
        guard feedbackActive else {
            VoxelKit.main.logger.log(node: self, .info, .effect, "Feedback reset; feed not active.")
            return
        }
        feedbackActive = false
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
