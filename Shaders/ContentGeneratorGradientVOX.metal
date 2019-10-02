//
//  ContentGeneratorGradientVOX.metal
//  VoxelKitShaders
//
//  Created by Anton Heestand on 2019-10-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include "Shaders/Source/Content/gradient_header.metal"

struct VertexOut3 {
    float4 position [[position]];
    float3 texCoord;
};

struct Uniforms {
    float type;
    float scale;
    float offset;
    float px;
    float py;
    float extend;
    float lx;
    float ly;
    float lz;
    float axis;
    float premultiply;
    float aspect;
};

fragment float4 contentGeneratorGradientVOX(VertexOut3 out [[stage_in]],
                                            const device Uniforms& in [[ buffer(0) ]],
                                            const device array<ArrayUniforms, ARRMAX>& inArr [[ buffer(1) ]],
                                            const device array<bool, ARRMAX>& inArrActive [[ buffer(2) ]],
                                            sampler s [[ sampler(0) ]]) {
    float pi = 3.14159265359;
    
    float x = out.texCoord[0];
    float y = out.texCoord[1];
    float z = out.texCoord[2];
    
    x -= in.px;// / in.aspect;
    y -= in.py;
    x -= in.lx;
    y -= in.ly;
    z -= in.lz;

    float axis = 0.0;
    float axisA = 0.0;
    float axisB = 0.0;
    switch (int(in.axis)) {
    case 0: axis = x; axisA = y; axisB = z;
    case 1: axis = y; axisA = x; axisB = z;
    case 2: axis = z; axisA = x; axisB = y;
    }
    
    float fraction = 0;
    if (in.type == 0) {
        // Linear
        fraction = (axis - in.offset) / in.scale;
    } else if (in.type == 1) {
        // Radial
        fraction = (sqrt(pow((axisA - 0.5) * in.aspect, 2) + pow(axisB - 0.5, 2)) * 2 - in.offset) / in.scale;
    } else if (in.type == 2) {
        // Angle
        fraction = (atan2(axisB - 0.5, (-axisA + 0.5) * in.aspect) / (pi * 2) + 0.5 - in.offset) / in.scale;
    }

    FractionAndZero fz = fractionAndZero(fraction, int(in.extend));
    fraction = fz.fraction;

    float4 c = 0;
    if (!fz.zero) {
        c = gradient(fraction, inArr, inArrActive);
    }

    if (!fz.zero && in.premultiply) {
        c = float4(c.r * c.a, c.g * c.a, c.b * c.a, c.a);
    }

    return c;
    
}
