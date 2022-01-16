
public enum VOXSingleEffectType: String, Codable, Hashable, CaseIterable, Identifiable {
    
    public var id: String { rawValue }
    
    case blur
    case edge
    case feedback
    case kaleidoscope
    case levels
    case `nil`
    case quantize
    case resolution
    case threshold
    case transform
    
    public var name: String {
        switch self {
        case .blur:
            return "Blur"
        case .edge:
            return "Edge"
        case .feedback:
            return "Feedback"
        case .kaleidoscope:
            return "Kaleidoscope"
        case .levels:
            return "Levels"
        case .nil:
            return "Nil"
        case .quantize:
            return "Quantize"
        case .resolution:
            return "Resolution"
        case .threshold:
            return "Threshold"
        case .transform:
            return "Transform"
        }
    }
    
    public var typeName: String {
        "vox-effect-single-\(name.lowercased().replacingOccurrences(of: " ", with: "-"))"
    }
    
    public var type: VOXSingleEffect.Type {
        switch self {
        case .blur:
            return BlurVOX.self
        case .edge:
            return EdgeVOX.self
        case .feedback:
            return FeedbackVOX.self
        case .kaleidoscope:
            return KaleidoscopeVOX.self
        case .levels:
            return LevelsVOX.self
        case .nil:
            return NilVOX.self
        case .quantize:
            return QuantizeVOX.self
        case .resolution:
            return ResolutionVOX.self
        case .threshold:
            return ThresholdVOX.self
        case .transform:
            return TransformVOX.self
        }
    }
    
}
