//
//  VOXOperators.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-09-04.
//  Open Source - MIT License
//

import LiveValues
import RenderKit

infix operator ++
infix operator --
infix operator **
infix operator !**
infix operator !&
infix operator <>
infix operator ><
infix operator ~
infix operator °
infix operator <->
//infix operator <+>
infix operator >-<
//infix operator >+<
infix operator +-+
prefix operator °

public extension VOX {
    
    static let blendOperators = BlendOperators()
    
    class BlendOperators {
        
        public var globalPlacement: Placement = .fit
        
        func blend(_ voxA: VOX, _ voxB: VOX & NODEOut, blendingMode: BlendMode) -> BlendVOX {
            let voxA = (voxA as? VOX & NODEOut) ?? ColorVOX(at: ._128) // CHECK
            let blendVox = BlendVOX()
            blendVox.name = operatorName(of: blendingMode)
            blendVox.blendMode = blendingMode
            blendVox.placement = globalPlacement
            blendVox.inputA = voxA
            blendVox.inputB = voxB
            return blendVox
        }
        
        func blend(_ vox: VOX, _ color: LiveColor, blendingMode: BlendMode) -> BlendVOX {
            let colorVox = ColorVOX(at: .custom(x: 1, y: 1, z: 1))
            colorVox.color = color
            if [.addWithAlpha, .subWithAlpha].contains(blendingMode) {
                colorVox.premultiply = false
            }
            let blendVox = blend(vox, colorVox, blendingMode: blendingMode)
            blendVox.extend = .hold
            return blendVox
        }
        
        func blend(_ vox: VOX, _ val: LiveFloat, blendingMode: BlendMode) -> BlendVOX {
            let color: LiveColor
            switch blendingMode {
            case .addWithAlpha, .subWithAlpha:
                color = LiveColor(lum: val, a: val)
            default:
                color = LiveColor(lum: val)
            }
            return blend(vox, color, blendingMode: blendingMode)
        }
        
        func blend(_ vox: VOX, _ val: LivePoint, blendingMode: BlendMode) -> BlendVOX {
            return blend(vox, LiveColor(r: val.x, g: val.y, b: 0.0, a: 1.0), blendingMode: blendingMode)
        }
        
        func operatorName(of blendingMode: BlendMode) -> String {
            switch blendingMode {
            case .over: return "&"
            case .under: return "!&"
            case .add: return "+"
            case .addWithAlpha: return "++"
            case .mult: return "*"
            case .diff: return "%"
            case .sub: return "-"
            case .subWithAlpha: return "--"
            case .max: return "><"
            case .min: return "<>"
            case .gam: return "!**"
            case .pow: return "**"
            case .div: return "/"
            case .avg: return "~"
            case .cos: return "°"
            case .in: return "<->"
            case .out: return ">-<"
            case .xor: return "+-+"
            }
        }
        
    }
    
    static func +(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .add)
    }
    static func +(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs + lhs }
    static func +(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .add)
    }
    static func +(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs + lhs }
    static func +(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .add)
    }
    static func +(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs + lhs }
    static func +(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .add)
    }
    
    static func ++(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .addWithAlpha)
    }
    static func ++(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs ++ lhs }
    static func ++(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .addWithAlpha)
    }
    static func ++(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs ++ lhs }
    static func ++(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .addWithAlpha)
    }
    
    static func -(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .sub)
    }
    static func -(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .sub)
    }
    static func -(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .sub)
    }
    static func -(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .sub)
    }
    
    static func --(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subWithAlpha)
    }
    static func --(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subWithAlpha)
    }
    static func --(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subWithAlpha)
    }
    static func --(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subWithAlpha)
    }
    
    static func *(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .mult)
    }
    static func *(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs * lhs }
    static func *(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .mult)
    }
    static func *(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs * lhs }
    static func *(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .mult)
    }
    static func *(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs * lhs }
    static func *(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .mult)
    }
    
    static func **(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .pow)
    }
    static func **(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .pow)
    }
    static func **(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .pow)
    }
    static func **(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .pow)
    }
    
    static func !**(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .gam)
    }
    static func !**(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .gam)
    }
    static func !**(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .gam)
    }
    static func !**(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .gam)
    }
    
    static func &(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .over)
    }
    static func &(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs !& lhs }
    static func &(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .over)
    }
    static func &(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs !& lhs }
    static func &(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .over)
    }
    static func &(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs !& lhs }
    static func &(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .over)
    }
    
    static func !&(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .under)
    }
    static func !&(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs & lhs }
    static func !&(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .under)
    }
    static func !&(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs & lhs }
    static func !&(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .under)
    }
    static func !&(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs & lhs }
    static func !&(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .under)
    }
    
    static func %(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .diff)
    }
    static func %(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs % lhs }
    static func %(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .diff)
    }
    static func %(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs % lhs }
    static func %(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .diff)
    }
    static func %(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs % lhs }
    static func %(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .diff)
    }
    
    static func <>(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .min)
    }
    static func <>(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs <> lhs }
    static func <>(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .min)
    }
    static func <>(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs <> lhs }
    static func <>(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .min)
    }
    static func <>(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs <> lhs }
    static func <>(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .min)
    }
    
    static func ><(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .max)
    }
    static func ><(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs >< lhs }
    static func ><(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .max)
    }
    static func ><(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs >< lhs }
    static func ><(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .max)
    }
    static func ><(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs >< lhs }
    static func ><(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .max)
    }
    
    static func /(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .div)
    }
    static func /(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs / lhs }
    static func /(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .div)
    }
    static func /(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs / lhs }
    static func /(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .div)
    }
    static func /(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs / lhs }
    static func /(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .div)
    }
    
    static func ~(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .avg)
    }
    static func ~(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs ~ lhs }
    static func ~(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .avg)
    }
    static func ~(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs ~ lhs }
    static func ~(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .avg)
    }
    static func ~(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs ~ lhs }
    static func ~(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .avg)
    }
    
    static func °(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .cos)
    }
    static func °(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs ° lhs }
    static func °(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .cos)
    }
    static func °(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs ° lhs }
    static func °(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .cos)
    }
    static func °(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs ° lhs }
    static func °(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .cos)
    }
    
    static func <->(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .in)
    }
    static func <->(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs <-> lhs }
    static func <->(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .in)
    }
    static func <->(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs <-> lhs }
    static func <->(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .in)
    }
    static func <->(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs <-> lhs }
    static func <->(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .in)
    }
    
//    static func <+>(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
//        return blendOperators.blend(lhs, rhs, blendingMode: .insideDestination)
//    }
//    static func <+>(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs <+> lhs }
//    static func <+>(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
//        return blendOperators.blend(lhs, rhs, blendingMode: .insideDestination)
//    }
//    static func <+>(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs <+> lhs }
//    static func <+>(lhs: VOX, rhs: LiveColor) -> BlendVOX {
//        return blendOperators.blend(lhs, rhs, blendingMode: .insideDestination)
//    }
    
    static func >-<(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .out)
    }
    static func >-<(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs >-< lhs }
    static func >-<(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .out)
    }
    static func >-<(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs >-< lhs }
    static func >-<(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .out)
    }
    static func >-<(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs >-< lhs }
    static func >-<(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .out)
    }
    
//    static func >+<(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
//        return blendOperators.blend(lhs, rhs, blendingMode: .outsideDestination)
//    }
//    static func >+<(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs >+< lhs }
//    static func >+<(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
//        return blendOperators.blend(lhs, rhs, blendingMode: .outsideDestination)
//    }
//    static func >+<(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs >+< lhs }
//    static func >+<(lhs: VOX, rhs: LiveColor) -> BlendVOX {
//        return blendOperators.blend(lhs, rhs, blendingMode: .outsideDestination)
//    }
    
    static func +-+(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .xor)
    }
    static func +-+(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs +-+ lhs }
    static func +-+(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .xor)
    }
    static func +-+(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs +-+ lhs }
    static func +-+(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .xor)
    }
    static func +-+(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs +-+ lhs }
    static func +-+(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .xor)
    }
    
    prefix static func ! (operand: VOX) -> VOX & NODEOut {
        guard let vox = operand as? NODEOut else {
            let black = ColorVOX(at: ._128)
            black.bgColor = .black
            return black
        }
        return vox._invert()
    }
    
    prefix static func ° (operand: VOX) -> VOX & NODEOut {
        return operand ° 1.0
    }
    
}
