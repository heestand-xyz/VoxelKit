//
//  GradientVOX.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import LiveValues
import RenderKit

//class GradientVOX: GradientPIX {
//    
//    override open var shader: String { return "contentGeneratorGradientVOX" }
//    
//    // MARK: - Public Types
//    
//    public enum Direction3D {
//        case linear(Axis)
//        case radial
//        case angle(Axis)
//        var index: Int {
//            switch self {
//            case .linear: return 0
//            case .radial: return 1
//            case .angle: return 2
//            }
//        }
//        var axis: Axis? {
//            switch self {
//            case .linear(let axis): return axis
//            case .radial: return nil
//            case .angle(let axis): return axis
//            }
//        }
//    }
//    
//    // MARK: - Public Properties
//    
//    public var direction3d: Direction3D = .linear(.x) { didSet { setNeedsRender() } }
//    public var location: LiveVec = .zero
//    
//    // MARK: - Property Helpers
//    
//    override public var liveValues: [LiveValue] {
//        var values = super.liveValues
//        values.append(location)
//        return values
//    }
//    
//    override var preUniforms: [CGFloat] {
//        return [CGFloat(direction3d.index)]
//    }
//    
//    override var postUniforms: [CGFloat] {
//        var uniforms = super.postUniforms
//        uniforms.append(CGFloat(direction3d.axis?.index ?? 0))
//        return uniforms
//    }
//    
//    // MARK: - Life Cycle
//    
//    public required init(res: Res = .auto) {
//        super.init(res: res)
//        name = "gradient"
//    }
//    
//}
