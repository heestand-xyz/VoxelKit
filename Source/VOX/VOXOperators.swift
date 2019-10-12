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
        
        public var globalPlacement: Placement = .aspectFit
        
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
            if [.addWithAlpha, .subtractWithAlpha].contains(blendingMode) {
                colorVox.premultiply = false
            }
            let blendVox = blend(vox, colorVox, blendingMode: blendingMode)
            blendVox.extend = .hold
            return blendVox
        }
        
        func blend(_ vox: VOX, _ val: LiveFloat, blendingMode: BlendMode) -> BlendVOX {
            let color: LiveColor
            switch blendingMode {
            case .addWithAlpha, .subtractWithAlpha:
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
            case .multiply: return "*"
            case .difference: return "%"
            case .subtract: return "-"
            case .subtractWithAlpha: return "--"
            case .maximum: return "><"
            case .minimum: return "<>"
            case .gamma: return "!**"
            case .power: return "**"
            case .divide: return "/"
            case .average: return "~"
            case .cosine: return "°"
            case .inside: return "<->"
            case .outside: return ">-<"
            case .exclusiveOr: return "+-+"
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
        return blendOperators.blend(lhs, rhs, blendingMode: .subtract)
    }
    static func -(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subtract)
    }
    static func -(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subtract)
    }
    static func -(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subtract)
    }
    
    static func --(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subtractWithAlpha)
    }
    static func --(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subtractWithAlpha)
    }
    static func --(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subtractWithAlpha)
    }
    static func --(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subtractWithAlpha)
    }
    
    static func *(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .multiply)
    }
    static func *(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs * lhs }
    static func *(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .multiply)
    }
    static func *(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs * lhs }
    static func *(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .multiply)
    }
    static func *(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs * lhs }
    static func *(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .multiply)
    }
    
    static func **(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .power)
    }
    static func **(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .power)
    }
    static func **(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .power)
    }
    static func **(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .power)
    }
    
    static func !**(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .gamma)
    }
    static func !**(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .gamma)
    }
    static func !**(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .gamma)
    }
    static func !**(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .gamma)
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
        return blendOperators.blend(lhs, rhs, blendingMode: .difference)
    }
    static func %(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs % lhs }
    static func %(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .difference)
    }
    static func %(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs % lhs }
    static func %(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .difference)
    }
    static func %(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs % lhs }
    static func %(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .difference)
    }
    
    static func <>(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .minimum)
    }
    static func <>(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs <> lhs }
    static func <>(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .minimum)
    }
    static func <>(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs <> lhs }
    static func <>(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .minimum)
    }
    static func <>(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs <> lhs }
    static func <>(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .minimum)
    }
    
    static func ><(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .maximum)
    }
    static func ><(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs >< lhs }
    static func ><(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .maximum)
    }
    static func ><(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs >< lhs }
    static func ><(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .maximum)
    }
    static func ><(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs >< lhs }
    static func ><(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .maximum)
    }
    
    static func /(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .divide)
    }
    static func /(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs / lhs }
    static func /(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .divide)
    }
    static func /(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs / lhs }
    static func /(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .divide)
    }
    static func /(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs / lhs }
    static func /(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .divide)
    }
    
    static func ~(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .average)
    }
    static func ~(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs ~ lhs }
    static func ~(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .average)
    }
    static func ~(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs ~ lhs }
    static func ~(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .average)
    }
    static func ~(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs ~ lhs }
    static func ~(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .average)
    }
    
    static func °(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .cosine)
    }
    static func °(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs ° lhs }
    static func °(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .cosine)
    }
    static func °(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs ° lhs }
    static func °(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .cosine)
    }
    static func °(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs ° lhs }
    static func °(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .cosine)
    }
    
    static func <->(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .inside)
    }
    static func <->(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs <-> lhs }
    static func <->(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .inside)
    }
    static func <->(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs <-> lhs }
    static func <->(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .inside)
    }
    static func <->(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs <-> lhs }
    static func <->(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .inside)
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
        return blendOperators.blend(lhs, rhs, blendingMode: .outside)
    }
    static func >-<(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs >-< lhs }
    static func >-<(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .outside)
    }
    static func >-<(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs >-< lhs }
    static func >-<(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .outside)
    }
    static func >-<(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs >-< lhs }
    static func >-<(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .outside)
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
        return blendOperators.blend(lhs, rhs, blendingMode: .exclusiveOr)
    }
    static func +-+(lhs: LiveFloat, rhs: VOX) -> BlendVOX { return rhs +-+ lhs }
    static func +-+(lhs: VOX, rhs: LiveFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .exclusiveOr)
    }
    static func +-+(lhs: LivePoint, rhs: VOX) -> BlendVOX { return rhs +-+ lhs }
    static func +-+(lhs: VOX, rhs: LivePoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .exclusiveOr)
    }
    static func +-+(lhs: LiveColor, rhs: VOX) -> BlendVOX { return rhs +-+ lhs }
    static func +-+(lhs: VOX, rhs: LiveColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .exclusiveOr)
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
