//
//  FeedbackVOX.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-08-21.
//  Open Source - MIT License
//

import LiveValues
import RenderKit
import Metal

public class FeedbackVOX: VOXSingleEffect {
    
    override open var shaderName: String { return "nilVOX" }
    
    // MARK: - Private Properties
    
    var readyToFeed: Bool = false
    var feedReset: Bool = false

    // MARK: - Public Properties
    
    var feedTexture: MTLTexture? {
        guard let texture = feedVox?.texture else { return nil }
        return try? Texture.copy3D(texture: texture, on: VoxelKit.main.render.metalDevice, in: VoxelKit.main.render.commandQueue)
    }
    
    public var feedActive: Bool = true { didSet { setNeedsRender() } }
    public var feedVox: (VOX & NODEOut)? { didSet { if feedActive { setNeedsRender() } } }
    
    public required init() {
        super.init()
        name = "feedback"
        VoxelKit.main.render.listenToFramesUntil {
            if self.input?.texture != nil && self.feedTexture != nil {
                self.setNeedsRender()
                return .done
            } else {
                return .continue
            }
        }
    }
    
    func tileFeedTexture(at tileIndex: TileIndex) -> MTLTexture? {
        guard let tileFeedVox = feedVox as? VOX & NODETileable3D else {
            VoxelKit.main.logger.log(node: self, .error, .texture, "Feed Input VOX Not Tileable.")
            return nil
        }
        guard let texture = tileFeedVox.tileTextures?[tileIndex.z][tileIndex.y][tileIndex.x] else { return nil }
        return try? Texture.copy3D(texture: texture, on: VoxelKit.main.render.metalDevice, in: VoxelKit.main.render.commandQueue)
    }
    
    override public func didRender(texture: MTLTexture, force: Bool) {
        super.didRender(texture: texture, force: force)
        if feedReset {
            feedActive = true
            feedReset = false
        }
        readyToFeed = true
        setNeedsRender()
    }
    
    public func resetFeed() {
        guard feedActive else {
            VoxelKit.main.logger.log(node: self, .info, .effect, "Feedback reset; feed not active.")
            return
        }
        feedActive = false
        feedReset = true
        setNeedsRender()
    }
    
}

public extension NODEOut {
    
    func _feed(_ fraction: LiveFloat = 1.0, loop: ((FeedbackVOX) -> (VOX & NODEOut))? = nil) -> FeedbackVOX {
        let feedbackPix = FeedbackVOX()
        feedbackPix.name = "feed:feedback"
        feedbackPix.input = self as? VOX & NODEOut
        let crossPix = CrossVOX()
        crossPix.name = "feed:cross"
        crossPix.inputA = self as? VOX & NODEOut
        crossPix.inputB = loop?(feedbackPix) ?? feedbackPix
        crossPix.fraction = fraction
        feedbackPix.feedVox = crossPix
        return feedbackPix
    }
    
}
