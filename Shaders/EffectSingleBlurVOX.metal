//
//  EffectSingleBlurVOX.metal
//  PixelKit Shaders
//
//  Created by Hexagons on 2017-11-14.
//  Copyright © 2017 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#import "Shaders/Source/Content/random_header.metal"

struct Uniforms{
    float type;
    float radius;
    float res;
    float x;
    float y;
    float z;
};

kernel void effectSingleBlurVOX(const device Uniforms& in [[ buffer(0) ]],
                                texture3d<float, access::sample> inTex [[ texture(0) ]],
                                texture3d<float, access::write>  outTex [[ texture(1) ]],
                                uint3 pos [[ thread_position_in_grid ]],
                                sampler s [[ sampler(0) ]]) {
    
    if (pos.x >= outTex.get_width() || pos.y >= outTex.get_height() || pos.z >= outTex.get_depth()) {
      return;
    }
    
    float pi = 3.14159265359;
    int max_res = 16384 - 1;
    
    float w = float(outTex.get_width());
    float h = float(outTex.get_height());
    float d = float(outTex.get_depth());
    float x = float(pos.x + 0.5) / w;
    float y = float(pos.y + 0.5) / h;
    float z = float(pos.z + 0.5) / d;
    float3 xyz = float3(x, y, z);
    
    float4 c = inTex.sample(s, xyz);
    
    int res = int(in.res);
    
    float3 p = float3(in.x, in.y, in.z);
    
    float amounts = 1.0;

    if (in.type == 0) {
        
        // Box
        
        for (int ix = -res; ix <= res; ++ix) {
            for (int iy = -res; iy <= res; ++iy) {
                for (int iz = -res; iz <= res; ++iz) {
                    if (x != 0 && y != 0 && z != 0) {
                        float dist = sqrt(pow(sqrt(pow(float(ix), 2) + pow(float(iy), 2)), 2) + pow(float(iz), 2));
                        if (dist <= res) {
                            float amount = pow(1.0 - dist / (res + 1), 0.5);
                            float xu = x + ((float(ix) / w) * in.radius) / res;
                            float yv = y + ((float(iy) / h) * in.radius) / res;
                            float zw = z + ((float(iz) / d) * in.radius) / res;
                            c += inTex.sample(s, float3(xu, yv, zw)) * amount;
                            amounts += amount;
                        }
                    }
                }
            }
        }
        
    } else if (in.type == 1) {
        
        // Zoom
        
        for (int ix = -res; ix <= res; ++ix) {
            if (ix != 0) {
                float amount = pow(1.0 - ix / (res + 1), 0.5);
                float xu = x + (((float(ix) * (x - 0.5 - p.x)) / w) * in.radius) / res;
                float yv = y + (((float(ix) * (y - 0.5 + p.y)) / h) * in.radius) / res;
                float zw = z + (((float(ix) * (z - 0.5 + p.z)) / d) * in.radius) / res;
                c += inTex.sample(s, float3(xu, yv, zw)) * amount;
                amounts += amount;
            }
        }
        
    } else if (in.type == 2) {
        
        // Random
        Loki loki_rnd_u = Loki(x * max_res, y * max_res, z * max_res);
        float ru = loki_rnd_u.rand();
        Loki loki_rnd_v = Loki(x * max_res, y * max_res, z * max_res + 1000);
        float rv = loki_rnd_v.rand();
        Loki loki_rnd_w = Loki(x * max_res, y * max_res, z * max_res + 2000);
        float rw = loki_rnd_w.rand();
        float3 ruvw = xyz + (float3(ru, rv, rw) - 0.5) * in.radius * 0.001;
        c = inTex.sample(s, ruvw);
        
    }
    
    c /= amounts;
    
    outTex.write(c, pos);
    
}


