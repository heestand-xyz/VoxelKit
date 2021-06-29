//
//  EffectSingleKaleidoscopePIX.metal
//  PixelKit Shaders
//
//  Created by Hexagons on 2017-11-28.
//  Copyright © 2017 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Uniforms {
    float divisions;
    float mirror;
    float rotation;
    float tx;
    float ty;
    float tz;
    float axis;
};

kernel void effectSingleKaleidoscopeVOX(const device Uniforms& in [[ buffer(0) ]],
                                        texture3d<float, access::sample> inTex [[ texture(0) ]],
                                        texture3d<float, access::write>  outTex [[ texture(1) ]],
                                        uint3 pos [[ thread_position_in_grid ]],
                                        sampler s [[ sampler(0) ]]) {
    
    if (pos.x >= outTex.get_width() || pos.y >= outTex.get_height() || pos.z >= outTex.get_depth()) {
      return;
    }
    
    float pi = 3.14159265359;
    
    float w = float(outTex.get_width());
    float h = float(outTex.get_height());
    float d = float(outTex.get_depth());
    float x = float(pos.x + 0.5) / w;
    float y = float(pos.y + 0.5) / h;
    float z = float(pos.z + 0.5) / d;
    
    uint su = 1;
    uint sv = 1;
    float u = 0.0;
    float v = 0.0;
    switch (int(in.axis)) {
        case 0:
            su = h;
            sv = d;
            u = y;
            v = z;
            break;
        case 1:
            su = w;
            sv = d;
            u = x;
            v = z;
            break;
        case 2:
            su = w;
            sv = h;
            u = x;
            v = y;
            break;
    }
    
    float aspect = float(su) / float(sv);
    float rot = in.rotation;
    float div = in.divisions;
    
    float ang = atan2(v - 0.5 + in.ty, (u - 0.5) * aspect - in.tx) / (pi * 2);
    float ang_big = (ang - rot) * div;
    float ang_step = ang_big - floor(ang_big);
    if (in.mirror) {
        if ((ang_big / 2) - floor(ang_big / 2) > 0.5) {
            ang_step = 1.0 - ang_step;
        }
    }
    float ang_kaleid = (ang_step / div + rot) * (pi * 2);
    float dist = sqrt(pow((u - 0.5) * aspect - in.tx, 2) + pow(v - 0.5 + in.ty, 2));
    float2 uv = float2((cos(ang_kaleid) / aspect) * dist + in.tx, sin(ang_kaleid) * dist - in.ty) + 0.5;
    
    float3 uvw = 0.0;
    switch (int(in.axis)) {
        case 0:
            uvw = float3(x, uv[0], uv[1]);
            break;
        case 1:
            uvw = float3(uv[0], y, uv[1]);
            break;
        case 2:
            uvw = float3(uv[0], uv[1], z);
            break;
    }
    
    float4 c = inTex.sample(s, uvw);
    
    outTex.write(c, pos);
    
}
