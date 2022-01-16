//
//  ContentGeneratorGradientVOX.metal
//  VoxelKitShaders
//
//  Created by Anton Heestand on 2019-10-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include "../../../../../Shaders/Source/Content/gradient_header.metal"

struct Uniforms {
    float type;
    float scale;
    float offset;
    float px;
    float py;
    float pz;
    float extend;
    float axis;
    float premultiply;
    float tile;
    float tileX;
    float tileY;
    float tileZ;
    float tileResX;
    float tileResY;
    float tileResZ;
    float tileFraction;
};

kernel void contentGeneratorGradientVOX(const device Uniforms& in [[ buffer(0) ]],
                                        texture3d<float, access::write>  outTex [[ texture(0) ]],
                                        const device array<ColorStopArray, ARRMAX>& inArr [[ buffer(1) ]],
                                        const device array<bool, ARRMAX>& inArrActive [[ buffer(2) ]],
                                        uint3 pos [[ thread_position_in_grid ]],
                                        sampler s [[ sampler(0) ]]) {
    
    if (pos.x >= outTex.get_width() || pos.y >= outTex.get_height() || pos.z >= outTex.get_depth()) {
        return;
    }
    
    float pi = 3.14159265359;
    
    float x = float(pos.x + 0.5) / float(outTex.get_width());
    float y = float(pos.y + 0.5) / float(outTex.get_height());
    float z = float(pos.z + 0.5) / float(outTex.get_depth());
    if (in.tile > 0.0) {
        x = (in.tileX / in.tileResX) + x * in.tileFraction;
        y = (in.tileY / in.tileResY) + y * in.tileFraction;
        z = (in.tileZ / in.tileResZ) + z * in.tileFraction;
    }
    
    x -= in.px;
    y -= in.py;
    z -= in.pz;

    float axis = 0.0;
    float axisA = 0.0;
    float axisB = 0.0;
    switch (int(in.axis)) {
        case 0: axis = x; axisA = y; axisB = z; break;
        case 1: axis = y; axisA = x; axisB = z; break;
        case 2: axis = z; axisA = x; axisB = y; break;
    }

    float fraction = 0;
    if (in.type == 0) {
        // Linear
        fraction = (axis - in.offset) / in.scale;
    } else if (in.type == 1) {
        // Radial
        fraction = (sqrt(pow(sqrt(pow(x - 0.5, 2) + pow(y - 0.5, 2)), 2) + pow(z - 0.5, 2)) * 2 - in.offset) / in.scale;
    } else if (in.type == 2) {
        // Angle
        fraction = (atan2(axisB - 0.5, (-axisA + 0.5)) / (pi * 2) + 0.5 - in.offset) / in.scale;
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
    
    outTex.write(c, pos);
    
}
