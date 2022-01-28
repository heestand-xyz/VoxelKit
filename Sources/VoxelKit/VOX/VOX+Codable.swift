//
//  File.swift
//  
//
//  Created by Anton Heestand on 2022-01-28.
//

import Foundation

extension VOX {
    
    // MARK: Codable
    
    public enum CodingError: Error {
        case typeNameUnknown(String)
        case badOS
        case badOSVersion
    }
    
    public func encodeVoxelModel() throws -> Data {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        for type in VOXGeneratorType.allCases {
            guard type.typeName == typeName else { continue }
            switch type {
            case .box:
                return try encoder.encode(voxelModel as! BoxVoxelModel)
            case .color:
                return try encoder.encode(voxelModel as! ColorVoxelModel)
            case .gradient:
                return try encoder.encode(voxelModel as! GradientVoxelModel)
            case .noise:
                return try encoder.encode(voxelModel as! NoiseVoxelModel)
            case .sphere:
                return try encoder.encode(voxelModel as! SphereVoxelModel)
            }
        }
        
        for type in VOXResourceType.allCases {
            guard type.typeName == typeName else { continue }
            switch type {
            case .object:
                return try encoder.encode(voxelModel as! ObjectVoxelModel)
            }
        }
        
        for type in VOXSingleEffectType.allCases {
            guard type.typeName == typeName else { continue }
            switch type {
            case .blur:
                return try encoder.encode(voxelModel as! BlurVoxelModel)
            case .edge:
                return try encoder.encode(voxelModel as! EdgeVoxelModel)
            case .feedback:
                return try encoder.encode(voxelModel as! FeedbackVoxelModel)
            case .kaleidoscope:
                return try encoder.encode(voxelModel as! KaleidoscopeVoxelModel)
            case .levels:
                return try encoder.encode(voxelModel as! LevelsVoxelModel)
            case .nil:
                return try encoder.encode(voxelModel as! NilVoxelModel)
            case .quantize:
                return try encoder.encode(voxelModel as! QuantizeVoxelModel)
            case .resolution:
                return try encoder.encode(voxelModel as! ResolutionVoxelModel)
            case .threshold:
                return try encoder.encode(voxelModel as! ThresholdVoxelModel)
            case .transform:
                return try encoder.encode(voxelModel as! TransformVoxelModel)
            }
        }
        
        for type in VOXMergerEffectType.allCases {
            guard type.typeName == typeName else { continue }
            switch type {
            case .blend:
                return try encoder.encode(voxelModel as! BlendVoxelModel)
            case .cross:
                return try encoder.encode(voxelModel as! CrossVoxelModel)
            case .displace:
                return try encoder.encode(voxelModel as! DisplaceVoxelModel)
            case .lookup:
                return try encoder.encode(voxelModel as! LookupVoxelModel)
            }
        }
        
        throw CodingError.typeNameUnknown(typeName)
    }
    
    struct TypeNameContainer: Decodable {
        let typeName: String
    }
    
    public static func decodeVoxelModel(data: Data) throws -> VoxelModel {
        
        let decoder = JSONDecoder()
        
        let typeNameContainer = try decoder.decode(TypeNameContainer.self, from: data)
        let typeName: String = typeNameContainer.typeName
        
        for type in VOXGeneratorType.allCases {
            guard type.typeName == typeName else { continue }
            switch type {
            case .box:
                return try decoder.decode(BoxVoxelModel.self, from: data)
            case .color:
                return try decoder.decode(ColorVoxelModel.self, from: data)
            case .gradient:
                return try decoder.decode(GradientVoxelModel.self, from: data)
            case .noise:
                return try decoder.decode(NoiseVoxelModel.self, from: data)
            case .sphere:
                return try decoder.decode(SphereVoxelModel.self, from: data)
            }
        }
        
        for type in VOXResourceType.allCases {
            guard type.typeName == typeName else { continue }
            switch type {
            case .object:
                return try decoder.decode(ObjectVoxelModel.self, from: data)
            }
        }
        
        for type in VOXSingleEffectType.allCases {
            guard type.typeName == typeName else { continue }
            switch type {
            case .blur:
                return try decoder.decode(BlurVoxelModel.self, from: data)
            case .edge:
                return try decoder.decode(EdgeVoxelModel.self, from: data)
            case .feedback:
                return try decoder.decode(FeedbackVoxelModel.self, from: data)
            case .kaleidoscope:
                return try decoder.decode(KaleidoscopeVoxelModel.self, from: data)
            case .levels:
                return try decoder.decode(LevelsVoxelModel.self, from: data)
            case .nil:
                return try decoder.decode(NilVoxelModel.self, from: data)
            case .quantize:
                return try decoder.decode(QuantizeVoxelModel.self, from: data)
            case .resolution:
                return try decoder.decode(ResolutionVoxelModel.self, from: data)
            case .threshold:
                return try decoder.decode(ThresholdVoxelModel.self, from: data)
            case .transform:
                return try decoder.decode(TransformVoxelModel.self, from: data)
            }
        }
        
        for type in VOXMergerEffectType.allCases {
            guard type.typeName == typeName else { continue }
            switch type {
            case .blend:
                return try decoder.decode(BlendVoxelModel.self, from: data)
            case .cross:
                return try decoder.decode(CrossVoxelModel.self, from: data)
            case .displace:
                return try decoder.decode(DisplaceVoxelModel.self, from: data)
            case .lookup:
                return try decoder.decode(LookupVoxelModel.self, from: data)
            }
        }
        
        throw CodingError.typeNameUnknown(typeName)
    }
    
    // MARK: - Initialize
    
    public static func initialize(voxelModel: VoxelModel) throws -> VOX {
        
        let typeName: String = voxelModel.typeName
        
        for type in VOXGeneratorType.allCases {
            guard type.typeName == typeName else { continue }
            switch type {
            case .box:
                return BoxVOX(model: voxelModel as! BoxVoxelModel)
            case .color:
                return ColorVOX(model: voxelModel as! ColorVoxelModel)
            case .gradient:
                return GradientVOX(model: voxelModel as! GradientVoxelModel)
            case .noise:
                return NoiseVOX(model: voxelModel as! NoiseVoxelModel)
            case .sphere:
                return SphereVOX(model: voxelModel as! SphereVoxelModel)
            }
        }
        
        for type in VOXResourceType.allCases {
            guard type.typeName == typeName else { continue }
            switch type {
            case .object:
                return ObjectVOX(model: voxelModel as! ObjectVoxelModel)
            }
        }
        
        for type in VOXSingleEffectType.allCases {
            guard type.typeName == typeName else { continue }
            switch type {
            case .blur:
                return BlurVOX(model: voxelModel as! BlurVoxelModel)
            case .edge:
                return EdgeVOX(model: voxelModel as! EdgeVoxelModel)
            case .feedback:
                return FeedbackVOX(model: voxelModel as! FeedbackVoxelModel)
            case .kaleidoscope:
                return KaleidoscopeVOX(model: voxelModel as! KaleidoscopeVoxelModel)
            case .levels:
                return LevelsVOX(model: voxelModel as! LevelsVoxelModel)
            case .nil:
                return NilVOX(model: voxelModel as! NilVoxelModel)
            case .quantize:
                return QuantizeVOX(model: voxelModel as! QuantizeVoxelModel)
            case .resolution:
                return ResolutionVOX(model: voxelModel as! ResolutionVoxelModel)
            case .threshold:
                return ThresholdVOX(model: voxelModel as! ThresholdVoxelModel)
            case .transform:
                return TransformVOX(model: voxelModel as! TransformVoxelModel)
            }
        }
        
        for type in VOXMergerEffectType.allCases {
            guard type.typeName == typeName else { continue }
            switch type {
            case .blend:
                return BlendVOX(model: voxelModel as! BlendVoxelModel)
            case .cross:
                return CrossVOX(model: voxelModel as! CrossVoxelModel)
            case .displace:
                return DisplaceVOX(model: voxelModel as! DisplaceVoxelModel)
            case .lookup:
                return LookupVOX(model: voxelModel as! LookupVoxelModel)
            }
        }
        
        throw CodingError.typeNameUnknown(typeName)
    }
}
