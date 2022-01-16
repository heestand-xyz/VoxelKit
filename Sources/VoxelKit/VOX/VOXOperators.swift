//
//  VOXOperators.swift
//  VoxelKit
//
//  Created by Hexagons on 2018-09-04.
//  Open Source - MIT License
//

import RenderKit
import PixelColor
import CoreGraphics

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
        
        func blend(_ vox: VOX, _ color: PixelColor, blendingMode: BlendMode) -> BlendVOX {
            let colorVox = ColorVOX(at: .custom(x: 1, y: 1, z: 1))
            colorVox.color = color
            if [.addWithAlpha, .subtractWithAlpha].contains(blendingMode) {
                colorVox.premultiply = false
            }
            let blendVox = blend(vox, colorVox, blendingMode: blendingMode)
            blendVox.extend = .hold
            return blendVox
        }
        
        func blend(_ vox: VOX, _ val: CGFloat, blendingMode: BlendMode) -> BlendVOX {
            let color: PixelColor
            switch blendingMode {
            case .addWithAlpha, .subtractWithAlpha:
                color = PixelColor(white: val, alpha: val)
            default:
                color = PixelColor(white: val)
            }
            return blend(vox, color, blendingMode: blendingMode)
        }
        
        func blend(_ vox: VOX, _ val: CGPoint, blendingMode: BlendMode) -> BlendVOX {
            return blend(vox, PixelColor(red: val.x, green: val.y, blue: 0.0, alpha: 1.0), blendingMode: blendingMode)
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
    static func +(lhs: CGFloat, rhs: VOX) -> BlendVOX { return rhs + lhs }
    static func +(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .add)
    }
    static func +(lhs: CGPoint, rhs: VOX) -> BlendVOX { return rhs + lhs }
    static func +(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .add)
    }
    static func +(lhs: PixelColor, rhs: VOX) -> BlendVOX { return rhs + lhs }
    static func +(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .add)
    }
    
    static func ++(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .addWithAlpha)
    }
    static func ++(lhs: CGFloat, rhs: VOX) -> BlendVOX { return rhs ++ lhs }
    static func ++(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .addWithAlpha)
    }
    static func ++(lhs: PixelColor, rhs: VOX) -> BlendVOX { return rhs ++ lhs }
    static func ++(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .addWithAlpha)
    }
    
    static func -(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subtract)
    }
    static func -(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subtract)
    }
    static func -(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subtract)
    }
    static func -(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subtract)
    }
    
    static func --(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subtractWithAlpha)
    }
    static func --(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subtractWithAlpha)
    }
    static func --(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subtractWithAlpha)
    }
    static func --(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .subtractWithAlpha)
    }
    
    static func *(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .multiply)
    }
    static func *(lhs: CGFloat, rhs: VOX) -> BlendVOX { return rhs * lhs }
    static func *(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .multiply)
    }
    static func *(lhs: CGPoint, rhs: VOX) -> BlendVOX { return rhs * lhs }
    static func *(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .multiply)
    }
    static func *(lhs: PixelColor, rhs: VOX) -> BlendVOX { return rhs * lhs }
    static func *(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .multiply)
    }
    
    static func **(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .power)
    }
    static func **(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .power)
    }
    static func **(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .power)
    }
    static func **(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .power)
    }
    
    static func !**(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .gamma)
    }
    static func !**(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .gamma)
    }
    static func !**(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .gamma)
    }
    static func !**(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .gamma)
    }
    
    static func &(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .over)
    }
    static func &(lhs: CGFloat, rhs: VOX) -> BlendVOX { return rhs !& lhs }
    static func &(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .over)
    }
    static func &(lhs: CGPoint, rhs: VOX) -> BlendVOX { return rhs !& lhs }
    static func &(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .over)
    }
    static func &(lhs: PixelColor, rhs: VOX) -> BlendVOX { return rhs !& lhs }
    static func &(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .over)
    }
    
    static func !&(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .under)
    }
    static func !&(lhs: CGFloat, rhs: VOX) -> BlendVOX { return rhs & lhs }
    static func !&(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .under)
    }
    static func !&(lhs: CGPoint, rhs: VOX) -> BlendVOX { return rhs & lhs }
    static func !&(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .under)
    }
    static func !&(lhs: PixelColor, rhs: VOX) -> BlendVOX { return rhs & lhs }
    static func !&(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .under)
    }
    
    static func %(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .difference)
    }
    static func %(lhs: CGFloat, rhs: VOX) -> BlendVOX { return rhs % lhs }
    static func %(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .difference)
    }
    static func %(lhs: CGPoint, rhs: VOX) -> BlendVOX { return rhs % lhs }
    static func %(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .difference)
    }
    static func %(lhs: PixelColor, rhs: VOX) -> BlendVOX { return rhs % lhs }
    static func %(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .difference)
    }
    
    static func <>(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .minimum)
    }
    static func <>(lhs: CGFloat, rhs: VOX) -> BlendVOX { return rhs <> lhs }
    static func <>(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .minimum)
    }
    static func <>(lhs: CGPoint, rhs: VOX) -> BlendVOX { return rhs <> lhs }
    static func <>(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .minimum)
    }
    static func <>(lhs: PixelColor, rhs: VOX) -> BlendVOX { return rhs <> lhs }
    static func <>(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .minimum)
    }
    
    static func ><(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .maximum)
    }
    static func ><(lhs: CGFloat, rhs: VOX) -> BlendVOX { return rhs >< lhs }
    static func ><(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .maximum)
    }
    static func ><(lhs: CGPoint, rhs: VOX) -> BlendVOX { return rhs >< lhs }
    static func ><(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .maximum)
    }
    static func ><(lhs: PixelColor, rhs: VOX) -> BlendVOX { return rhs >< lhs }
    static func ><(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .maximum)
    }
    
    static func /(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .divide)
    }
    static func /(lhs: CGFloat, rhs: VOX) -> BlendVOX { return rhs / lhs }
    static func /(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .divide)
    }
    static func /(lhs: CGPoint, rhs: VOX) -> BlendVOX { return rhs / lhs }
    static func /(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .divide)
    }
    static func /(lhs: PixelColor, rhs: VOX) -> BlendVOX { return rhs / lhs }
    static func /(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .divide)
    }
    
    static func ~(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .average)
    }
    static func ~(lhs: CGFloat, rhs: VOX) -> BlendVOX { return rhs ~ lhs }
    static func ~(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .average)
    }
    static func ~(lhs: CGPoint, rhs: VOX) -> BlendVOX { return rhs ~ lhs }
    static func ~(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .average)
    }
    static func ~(lhs: PixelColor, rhs: VOX) -> BlendVOX { return rhs ~ lhs }
    static func ~(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .average)
    }
    
    static func °(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .cosine)
    }
    static func °(lhs: CGFloat, rhs: VOX) -> BlendVOX { return rhs ° lhs }
    static func °(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .cosine)
    }
    static func °(lhs: CGPoint, rhs: VOX) -> BlendVOX { return rhs ° lhs }
    static func °(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .cosine)
    }
    static func °(lhs: PixelColor, rhs: VOX) -> BlendVOX { return rhs ° lhs }
    static func °(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .cosine)
    }
    
    static func <->(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .inside)
    }
    static func <->(lhs: CGFloat, rhs: VOX) -> BlendVOX { return rhs <-> lhs }
    static func <->(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .inside)
    }
    static func <->(lhs: CGPoint, rhs: VOX) -> BlendVOX { return rhs <-> lhs }
    static func <->(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .inside)
    }
    static func <->(lhs: PixelColor, rhs: VOX) -> BlendVOX { return rhs <-> lhs }
    static func <->(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .inside)
    }
    
//    static func <+>(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
//        return blendOperators.blend(lhs, rhs, blendingMode: .insideDestination)
//    }
//    static func <+>(lhs: CGFloat, rhs: VOX) -> BlendVOX { return rhs <+> lhs }
//    static func <+>(lhs: VOX, rhs: CGFloat) -> BlendVOX {
//        return blendOperators.blend(lhs, rhs, blendingMode: .insideDestination)
//    }
//    static func <+>(lhs: PixelColor, rhs: VOX) -> BlendVOX { return rhs <+> lhs }
//    static func <+>(lhs: VOX, rhs: PixelColor) -> BlendVOX {
//        return blendOperators.blend(lhs, rhs, blendingMode: .insideDestination)
//    }
    
    static func >-<(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .outside)
    }
    static func >-<(lhs: CGFloat, rhs: VOX) -> BlendVOX { return rhs >-< lhs }
    static func >-<(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .outside)
    }
    static func >-<(lhs: CGPoint, rhs: VOX) -> BlendVOX { return rhs >-< lhs }
    static func >-<(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .outside)
    }
    static func >-<(lhs: PixelColor, rhs: VOX) -> BlendVOX { return rhs >-< lhs }
    static func >-<(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .outside)
    }
    
//    static func >+<(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
//        return blendOperators.blend(lhs, rhs, blendingMode: .outsideDestination)
//    }
//    static func >+<(lhs: CGFloat, rhs: VOX) -> BlendVOX { return rhs >+< lhs }
//    static func >+<(lhs: VOX, rhs: CGFloat) -> BlendVOX {
//        return blendOperators.blend(lhs, rhs, blendingMode: .outsideDestination)
//    }
//    static func >+<(lhs: PixelColor, rhs: VOX) -> BlendVOX { return rhs >+< lhs }
//    static func >+<(lhs: VOX, rhs: PixelColor) -> BlendVOX {
//        return blendOperators.blend(lhs, rhs, blendingMode: .outsideDestination)
//    }
    
    static func +-+(lhs: VOX, rhs: VOX & NODEOut) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .exclusiveOr)
    }
    static func +-+(lhs: CGFloat, rhs: VOX) -> BlendVOX { return rhs +-+ lhs }
    static func +-+(lhs: VOX, rhs: CGFloat) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .exclusiveOr)
    }
    static func +-+(lhs: CGPoint, rhs: VOX) -> BlendVOX { return rhs +-+ lhs }
    static func +-+(lhs: VOX, rhs: CGPoint) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .exclusiveOr)
    }
    static func +-+(lhs: PixelColor, rhs: VOX) -> BlendVOX { return rhs +-+ lhs }
    static func +-+(lhs: VOX, rhs: PixelColor) -> BlendVOX {
        return blendOperators.blend(lhs, rhs, blendingMode: .exclusiveOr)
    }
    
    prefix static func ! (operand: VOX) -> VOX & NODEOut {
        guard let vox = operand as? NODEOut else {
            let black = ColorVOX(at: ._128)
            black.backgroundColor = .black
            return black
        }
        return vox.voxInverted()
    }
    
//    prefix static func ° (operand: VOX) -> VOX & NODEOut {
//        return operand ° 1.0
//    }
    
}
