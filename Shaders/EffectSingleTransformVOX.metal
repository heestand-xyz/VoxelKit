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
        
    float x = float(pos.x + 0.5) / float(outTex.get_width());
    float y = float(pos.y + 0.5) / float(outTex.get_height());
    float z = float(pos.z + 0.5) / float(outTex.get_depth());
    
    float3 size = float3(in.sx * in.s, in.sy * in.s, in.sz * in.s);
    float3 p = float3(x + in.tx, y + in.ty, z + in.tz);
    float3 uvw = (p - 0.5) / size + 0.5;
    
    float4 c = inTex.sample(s, uvw);
    
    outTex.write(c, pos);
    
}


