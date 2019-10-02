//
//  ContentGeneratorGradientVOX.metal
//  VoxelKitShaders
//
//  Created by Anton Heestand on 2019-10-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

// Hardcoded at 128
// Defined as uniformArrayMaxLimit in source
constant int ARRMAX = 128;

struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
};

struct Uniforms {
    float type;
    float scale;
    float offset;
    float px;
    float py;
    float extend;
    float premultiply;
    float aspect;
};

struct ArrayUniforms {
    float fraction;
    float cr;
    float cg;
    float cb;
    float ca;
};

fragment float4 contentGeneratorGradientVOX(VertexOut out [[stage_in]],
                                            const device Uniforms& in [[ buffer(0) ]],
                                            const device array<ArrayUniforms, ARRMAX>& inArr [[ buffer(1) ]],
                                            const device array<bool, ARRMAX>& inArrActive [[ buffer(2) ]],
                                            sampler s [[ sampler(0) ]]) {

    return float4(0.0);
    
}
