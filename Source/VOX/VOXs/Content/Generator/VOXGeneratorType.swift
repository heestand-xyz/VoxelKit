
public enum VOXGeneratorType: String, Codable, Hashable, CaseIterable, Identifiable {
    
    public var id: String { rawValue }
    
    case box
    case color
    case gradient
    case noise
    case sphere
    
    public var name: String {
        switch self {
        case .box:
            return "Box"
        case .color:
            return "Color"
        case .gradient:
            return "Gradient"
        case .noise:
            return "Noise"
        case .sphere:
            return "Sphere"
        }
    }
    
    public var type: VOXGenerator.Type {
        switch self {
        case .box:
            return BoxVOX.self
        case .color:
            return ColorVOX.self
        case .gradient:
            return GradientVOX.self
        case .noise:
            return NoiseVOX.self
        case .sphere:
            return SphereVOX.self
        }
    }
    
}
