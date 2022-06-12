//
//  VOXGenerator.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-04.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit
import CoreGraphics
import MetalKit
import Resolution
import PixelColor

public class VOXGenerator: VOXContent, NODEGenerator, NODEResolution3D {
    
    public var generatorModel: VoxelGeneratorModel {
        get { contentModel as! VoxelGeneratorModel }
        set { contentModel = newValue }
    }
    
    @LiveResolution3D("resolution") public var resolution: Resolution3D = .cube(8)
    
    @LiveBool("premultiply") public var premultiply: Bool = true
    
    @LiveColor("backgroundColor") public var backgroundColor: PixelColor = .black
    @LiveColor("color") public var color: PixelColor = .white
    
    public override var liveList: [LiveWrap] {
        [_resolution, _premultiply, _backgroundColor, _color]
    }
    
    // MARK: - Life Cycle -
    
    public init(model: VoxelGeneratorModel) {
        self.resolution = model.resolution
        super.init(model: model)
        setupGenerator()
    }
    
    @available(*, deprecated, renamed: "init(model:)")
    public init(at resolution: Resolution3D, name: String, typeName: String) {
        fatalError("please use init(model:)")
    }
    
    public required init(at resolution: Resolution3D) {
        fatalError("please use init(model:)")
    }
    
    // MARK: - Setup
    
    func setupGenerator() {
        applyResolution { [weak self] in
            self?.render()
            // FIXME: Delay on Init
            VoxelKit.main.render.delay(frames: 1) { [weak self] in
                self?.render()
            }
        }
    }
    
    // MARK: - Live Model
    
    open override func modelUpdateLive() {
        super.modelUpdateLive()
        
        resolution = generatorModel.resolution
        backgroundColor = generatorModel.backgroundColor
        color = generatorModel.color
        premultiply = generatorModel.premultiply
    }
    
    open override func liveUpdateModel() {
        super.liveUpdateModel()
        
        generatorModel.resolution = resolution
        generatorModel.backgroundColor = backgroundColor
        generatorModel.color = color
        generatorModel.premultiply = premultiply
    }
    
}
