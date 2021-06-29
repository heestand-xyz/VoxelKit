//
//  EffectSingleTransformVOX.metal
//  PixelKitShaders
//
//  Created by Hexagons on 2017-11-17.
//  Copyright © 2017 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Uniforms{
    float tx;
    float ty;
    float tz;
    float rx;
    float ry;
    float rz;
    float s;
    float sx;
    float sy;
    float sz;
};

kernel void effectSingleTransformVOX(const device Uniforms& in [[ buffer(0) ]],
                                     texture3d<float, access::sample> inTex [[ texture(0) ]],
                                     texture3d<float, access::write>  outTex [[ texture(1) ]],
                                     uint3 pos [[ thread_position_in_grid ]],
                                     sampler s [[ sampler(0) ]]) {
    
    if (pos.x >= outTex.get_width() || pos.y >= outTex.get_height() || pos.z >= outTex.get_depth()) {
      return;
    }
    
    float pi = 3.14159265359;
        
    float x = float(pos.x + 0.5) / float(outTex.get_width());
    float y = float(pos.y + 0.5) / float(outTex.get_height());
    float z = float(pos.z + 0.5) / float(outTex.get_depth());
    
    float3 size = float3(in.sx * in.s, in.sy * in.s, in.sz * in.s);
    float3 p = float3(x + in.tx - 0.5, y + in.ty - 0.5, z + in.tz - 0.5);
    
    if (in.rx != 0.0) {
        float angx = atan2(p.z, p.y) + (-in.rx * pi * 2);
        float ampx = sqrt(pow(p.y, 2) + pow(p.z, 2));
        float2 rotx = float2(cos(angx) * ampx, sin(angx) * ampx);
        p = float3(p.x, rotx[0], rotx[1]);
    }
    
    if (in.ry != 0.0) {
        float angy = atan2(p.z, p.x) + (-in.ry * pi * 2);
        float ampy = sqrt(pow(p.x, 2) + pow(p.z, 2));
        float2 roty = float2(cos(angy) * ampy, sin(angy) * ampy);
        p = float3(roty[0], p.y, roty[1]);
    }
    
    if (in.rz != 0.0) {
        float angz = atan2(p.y, p.x) + (-in.rz * pi * 2);
        float ampz = sqrt(pow(p.x, 2) + pow(p.y, 2));
        float2 rotz = float2(cos(angz) * ampz, sin(angz) * ampz);
        p = float3(rotz[0], rotz[1], p.z);
    }
    
    float3 uvw = p / size + 0.5;
    
    float4 c = inTex.sample(s, uvw);
    
    outTex.write(c, pos);
    
}


