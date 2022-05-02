//
//  GradientVOX.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit
import CoreGraphics
import PixelColor
import simd
import Resolution

public struct ColorStep: Codable, Equatable {
    public var step: CGFloat
    public var color: PixelColor
    public init(_ step: CGFloat, _ color: PixelColor) {
        self.step = step
        self.color = color
    }
}

public class GradientVOX: VOXGenerator {
    
    public typealias Model = GradientVoxelModel
    
    private var model: Model {
        get { generatorModel as! Model }
        set { generatorModel = newValue }
    }
    
    override open var shaderName: String { "contentGeneratorGradientVOX" }
    
    // MARK: - Public Types
    
    public enum Direction: Enumable, Equatable {
        case linear(Axis)
        case radial
        case angle(Axis)
        public var index: Int {
            switch self {
            case .linear: return 0
            case .radial: return 1
            case .angle: return 2
            }
        }
        public var axis: Axis? {
            switch self {
            case .linear(let axis): return axis
            case .radial: return nil
            case .angle(let axis): return axis
            }
        }
        public var name: String {
            switch self {
            case .linear(let axis):
                return "Linear \(axis.name)"
            case .radial:
                return "Radial"
            case .angle(let axis):
                return "Angle \(axis.name)"
            }
        }
        public var typeName: String {
            name.lowercased().replacingOccurrences(of: " ", with: "-")
        }
        public static var allCases: [Direction] {
            var allCases: [Direction] = []
            allCases += Axis.allCases.map({ Direction.linear($0) })
            allCases += [.radial]
            allCases += Axis.allCases.map({ Direction.angle($0) })
            return allCases
        }
    }
    
    // MARK: - Public Properties
    
    public var colorSteps: [ColorStep] {
        get { model.colorStops }
        set {
            model.colorStops = newValue
            super.render()
        }
    }

    @LiveEnum("direction") public var direction: Direction = .linear(.x)
    @LiveFloat("scale") public var scale: CGFloat = 1.0
    @LiveFloat("offset") public var offset: CGFloat = 0.0
    @LiveVector("position") public var position: SIMD3<Double> = .zero
    @LiveEnum("extendMode") public var extendMode: ExtendMode = .hold
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        super.liveList.filter({ liveWrap in
            !["backgroundColor", "color"].contains(liveWrap.typeName)
        }) + [_direction, _scale, _offset, _position, _extendMode]
    }
    
    open override var uniforms: [CGFloat] {
        return [CGFloat(direction.index), scale, offset, position.x, position.y, position.z, CGFloat(extendMode.index), CGFloat(direction.axis?.index ?? 0)]
    }
    
    public override var uniformArray: [[CGFloat]] {
        colorSteps.map({ colorStep -> [CGFloat] in
            [colorStep.step, colorStep.color.red, colorStep.color.green, colorStep.color.blue, colorStep.color.alpha]
        })
    }
    
    public override var uniformArrayLength: Int? { 5 }
    
    // MARK: - Life Cycle -
    
    public init(model: Model) {
        super.init(model: model)
    }
    
    public required init(at resolution: Resolution3D = .default) {
        let model = Model(resolution: resolution)
        super.init(model: model)
    }
    
    // MARK: - Live Model
    
    public override func modelUpdateLive() {
        super.modelUpdateLive()
        
        direction = model.direction
        scale = model.scale
        offset = model.offset
        position = model.position
        extendMode = model.extendMode
        
        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        
        model.direction = direction
        model.scale = scale
        model.offset = offset
        model.position = position
        model.extendMode = extendMode
        
        super.liveUpdateModelDone()
    }
    
    
}
