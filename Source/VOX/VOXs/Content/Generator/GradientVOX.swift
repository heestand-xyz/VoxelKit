//
//  GradientVOX.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import LiveValues
import RenderKit

public struct ColorStep {
    public var step: LiveFloat
    public var color: LiveColor
    public init(_ step: LiveFloat, _ color: LiveColor) {
        self.step = step
        self.color = color
    }
}

public class GradientVOX: VOXGenerator {
    
    override open var shaderName: String { return "contentGeneratorGradientVOX" }
    
    // MARK: - Public Types
    
    public enum Direction {
        case linear(Axis)
        case radial
        case angle(Axis)
        var index: Int {
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
    }
    
    // MARK: - Public Properties
    
    public var direction: Direction = .linear(.x) { didSet { setNeedsRender() } }
    public var scale: LiveFloat = 1.0
    public var offset: LiveFloat = 0.0
    public var position: LiveVec = .zero
    public var extendRamp: ExtendMode = .hold { didSet { setNeedsRender() } }
    public var colorSteps: [ColorStep] = [ColorStep(0.0, .black), ColorStep(1.0, .white)]
    
    // MARK: - Property Helpers
    
    override open var liveValues: [LiveValue] {
        return [scale, offset, position]
    }

    override public var liveArray: [[LiveFloat]] {
        return colorSteps.map({ colorStep -> [LiveFloat] in
            return [colorStep.step, colorStep.color.r, colorStep.color.g, colorStep.color.b, colorStep.color.a]
        })
    }
    
    override open var preUniforms: [CGFloat] {
        return [CGFloat(direction.index)]
    }
    
    override open var postUniforms: [CGFloat] {
        return [CGFloat(extendRamp.index), CGFloat(direction.axis?.index ?? 0)]
    }
    
    // MARK: - Life Cycle
    
    public required init(at resolution: Resolution3D) {
        super.init(at: resolution)
        name = "gradient"
    }
    
}
