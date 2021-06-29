//
//  ContentGeneratorSphereVOX.metal
//  PixelKit Shaders
//
//  Created by Hexagons on 2017-11-17.
//  Copyright © 2017 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Uniforms{
    float s;
    float x;
    float y;
    float z;
    float e;
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
    float tile;
    float tileX;
    float tileY;
    float tileZ;
    float tileResX;
    float tileResY;
    float tileResZ;
    float tileFraction;
};

kernel void contentGeneratorSphereVOX(const device Uniforms& in [[ buffer(0) ]],
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
    
    float4 ac = float4(in.ar, in.ag, in.ab, in.aa);
    float4 ec = float4(in.er, in.eg, in.eb, in.ea);
    float4 bc = float4(in.br, in.bg, in.bb, in.ba);
    
    float4 c = bc;
    
    float e = in.e;
    if (e < 0) {
        e = 0;
    }
    
    float dist = sqrt(pow(sqrt(pow(x - 0.5 - in.x, 2) + pow(y - 0.5 - in.y, 2)), 2) + pow(z - 0.5 - in.z, 2));
    if (dist < in.s - e / 2) {
        c = ac;
    } else if (dist < in.s + e / 2) {
        c = ec;
    }
    
    if (in.premultiply) {
        c = float4(c.r * c.a, c.g * c.a, c.b * c.a, c.a);
    }
    
    outTex.write(c, pos);
    
}
