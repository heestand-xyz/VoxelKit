//
//  ContentGeneratorColorVOX.metal
//  VoxelKitShaders
//
//  Created by Hexagons on 2019-10-05.
//  Copyright © 2019 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Uniforms {
    float r;
    float g;
    float b;
    float a;
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

kernel void contentGeneratorColorVOX(const device Uniforms& in [[ buffer(0) ]],
                                     texture3d<float, access::write>  outTex [[ texture(0) ]],
                                     uint3 pos [[ thread_position_in_grid ]],
                                     sampler s [[ sampler(0) ]]) {
    
    if (pos.x >= outTex.get_width() || pos.y >= outTex.get_height() || pos.z >= outTex.get_depth()) {
        return;
    }
    
    float4 c = float4(in.r, in.g, in.b, in.a);

    if (in.premultiply) {
        c = float4(c.r * c.a, c.g * c.a, c.b * c.a, c.a);
    }

    outTex.write(c, pos);
    
}

