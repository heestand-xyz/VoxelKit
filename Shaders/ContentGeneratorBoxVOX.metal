//
//  ContentGeneratorBoxVOX.metal
//  PixelKit Shaders
//
//  Created by Hexagons on 2017-11-17.
//  Copyright © 2017 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

float sdRoundBox(float3 p, float3 b, float r) {
    float3 q = abs(p) - b;
    return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0) - r;
}

struct Uniforms{
    float tx;
    float ty;
    float tz;
    float sx;
    float sy;
    float sz;
    float e;
    float r;
    float ar;
    float ag;
    float ab;
    float aa;
    float er;
    float eg;
    float eb;
    float ea;
    float br;
    float bg;
    float bb;
    float ba;
    float premultiply;
};

kernel void contentGeneratorBoxVOX(const device Uniforms& in [[ buffer(0) ]],
                                   texture3d<float, access::write>  outTex [[ texture(0) ]],
                                   uint3 pos [[ thread_position_in_grid ]],
                                   sampler s [[ sampler(0) ]]) {
    
    if (pos.x >= outTex.get_width() || pos.y >= outTex.get_height() || pos.z >= outTex.get_depth()) {
        return;
    }
    
    float x = float(pos.x + 0.5) / float(outTex.get_width());
    float y = float(pos.y + 0.5) / float(outTex.get_height());
    float z = float(pos.z + 0.5) / float(outTex.get_depth());
    float3 xyz = float3(x, y, z);
    
    float3 trans = float3(in.tx, in.ty, in.tz);
    float3 scale = float3(in.sx, in.sy, in.sz);
    
    float4 ac = float4(in.ar, in.ag, in.ab, in.aa);
    float4 ec = float4(in.er, in.eg, in.eb, in.ea);
    float4 bc = float4(in.br, in.bg, in.bb, in.ba);
    
    float4 c = bc;
    
    float e = in.e;
    if (e < 0) {
        e = 0;
    }
    
    float dist = sdRoundBox(xyz + trans - 0.5, scale / 2, in.r);
    if (dist - in.r < 0.0) {
        c = ac;
    } else if (dist - in.r - e < 0.0) {
        c = ec;
    }
    
    if (in.premultiply) {
        c = float4(c.r * c.a, c.g * c.a, c.b * c.a, c.a);
    }
    
    outTex.write(c, pos);
    
}
