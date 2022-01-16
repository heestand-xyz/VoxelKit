//
//  File.swift
//  
//
//  Created by Anton Heestand on 2021-06-29.
//

import Foundation
import RenderKit
import Resolution

final public class NilVOX: VOXSingleEffect {
    
    override public var shaderName: String { return "nilVOX" }
    
    let nilOverrideBits: Bits?
    public override var overrideBits: Bits? { nilOverrideBits }
    
    public required init(name: String = "Nil") {
        nilOverrideBits = nil
        super.init(name: name, typeName: "vox-effect-single-nil")
    }
    
    public required init() {
        nilOverrideBits = nil
        super.init(name: "Nil", typeName: "vox-effect-single-nil")
    }
    
    public init(overrideBits: Bits) {
        nilOverrideBits = overrideBits
        super.init(name: "Nil (\(overrideBits.rawValue)bit)", typeName: "vox-effect-single-nil")
    }
    
    // MARK: Codable
    
//    enum CodingKeys: CodingKey {
//        case nilOverrideBits
//    }
//    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        nilOverrideBits = try container.decode(Bits?.self, forKey: .nilOverrideBits)
//        try super.init(from: decoder)
//    }
//    
//    public override func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(nilOverrideBits, forKey: .nilOverrideBits)
//        try super.encode(to: encoder)
//    }
    
}

public extension NODEOut {
    
    /// bypass is `false` by *default*
    func voxNil(bypass: Bool = false) -> NilVOX {
        let nilPix = NilVOX()
        nilPix.name = ":nil:"
        nilPix.input = self as? VOX & NODEOut
        nilPix.bypass = bypass
        return nilPix
    }
    
}
