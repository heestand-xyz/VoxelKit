
public enum VOXMergerEffectType: String, Codable, Hashable, CaseIterable, Identifiable {
    
    public var id: String { rawValue }
    
    case blend
    case cross
    case displace
    case lookup
    
    public var name: String {
        switch self {
        case .blend:
            return "Blend"
        case .cross:
            return "Cross"
        case .displace:
            return "Displace"
        case .lookup:
            return "Lookup"
        }
    }
    
    public var type: VOXMergerEffect.Type {
        switch self {
        case .blend:
            return BlendVOX.self
        case .cross:
            return CrossVOX.self
        case .displace:
            return DisplaceVOX.self
        case .lookup:
            return LookupVOX.self
        }
    }
    
}
