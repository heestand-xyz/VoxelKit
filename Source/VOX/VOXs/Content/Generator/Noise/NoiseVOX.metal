//
//  ContentGeneratorNoiseVOX.metal
//  VoxelKit Shaders
//
//  Created by Hexagons on 2017-11-24.
//  Copyright © 2017 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#import "../../../../../Shaders/Source/Content/noise_header.metal"
#import "../../../../../Shaders/Source/Content/random_header.metal"

struct Uniforms{
    float seed;
    float octaves;
    float x;
    float y;
    float z;
    float w;
    float zoom;
    float color;
    float random;
    float includeAlpha;
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

kernel void contentGeneratorNoiseVOX(const device Uniforms& in [[ buffer(0) ]],
                                     texture3d<float, access::write>  outTex [[ texture(0) ]],
                                     uint3 pos [[ thread_position_in_grid ]],
                                     sampler s [[ sampler(0) ]]) {
    
    if (pos.x >= outTex.get_width() || pos.y >= outTex.get_height() || pos.z >= outTex.get_depth()) {
        return;
    }
    
    float x = float(pos.x + 0.5) / float(outTex.get_width());
    float y = float(pos.y + 0.5) / float(outTex.get_height());
    float z = float(pos.z + 0.5) / float(outTex.get_depth());
    if (in.tile > 0.0) {
        x = (in.tileX / in.tileResX) + x * in.tileFraction;
        y = (in.tileY / in.tileResY) + y * in.tileFraction;
        z = (in.tileZ / in.tileResZ) + z * in.tileFraction;
    }
    
    int max_res = 16384 - 1;
    
    float ux = (x - in.x - 0.5) / in.zoom;
    float vy = (y - in.y - 0.5) / in.zoom;
    float wz = (z - in.z - 0.5) / in.zoom;

    float n;
    if (in.random > 0.0) {
        Loki loki_rnd = Loki(x * max_res, y * max_res, z * max_res + in.seed * 100);
        n = loki_rnd.rand();
    } else {
        n = octave_noise_4d(in.octaves, 0.5, 1.0, ux, vy, wz, in.w + in.seed);
        n = n / 2 + 0.5;
    }
    
    float ng;
    float nb;
    if (in.color > 0.0) {
        if (in.random > 0.0) {
            Loki loki_rnd_g = Loki(x * max_res, y * max_res, z * max_res + in.seed * 100 + 1000);
            ng = loki_rnd_g.rand();
            Loki loki_rnd_b = Loki(x * max_res, y * max_res, z * max_res + in.seed * 100 + 2000);
            nb = loki_rnd_b.rand();
        } else {
            ng = octave_noise_4d(in.octaves, 0.5, 1.0, ux, vy, wz, in.w + in.seed + 10);
            ng = ng / 2 + 0.5;
            nb = octave_noise_4d(in.octaves, 0.5, 1.0, ux, vy, wz, in.w + in.seed + 20);
            nb = nb / 2 + 0.5;
        }
    }
    
    float na;
    if (in.includeAlpha > 0.0) {
        if (in.random > 0.0) {
            Loki loki_rnd_g = Loki(x * max_res, y * max_res, z * max_res + in.seed * 100 + 3000);
            na = loki_rnd_g.rand();
        } else {
            na = octave_noise_4d(in.octaves, 0.5, 1.0, ux, vy, wz, in.w + in.seed + 30);
            na = na / 2 + 0.5;
        }
    }
    
    float r = n;
    float g = in.color > 0.0 ? ng : n;
    float b = in.color > 0.0 ? nb : n;
    float a = in.includeAlpha > 0.0 ? na : 1.0;

    float4 c = float4(r, g, b, a);
    
    outTex.write(c, pos);
    
}
