#include <metal_stdlib>

using namespace metal;

struct InstanceConstants {
    float4x4 modelViewProjectionMatrix;
    float4x4 normalMatrix;
    float4 color;
};

struct VertexIn {
    float3 position [[attribute(0)]];
    float3 normal   [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 normal;
    float4 color;
};

vertex VertexOut voxelViewVertex(VertexIn in [[stage_in]],
                                 constant InstanceConstants &instance [[buffer(1)]]) {
    VertexOut out;

    float4 position(in.position, 1);
    float4 normal(in.normal, 0);
    
    out.position = instance.modelViewProjectionMatrix * position;
    out.normal = (instance.normalMatrix * normal).xyz;
    out.color = instance.color;

    return out;
}

fragment half4 voxelViewVertexFragment(VertexOut in [[stage_in]]) {
    
    return half4(in.color);
}
