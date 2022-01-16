//
//  EffectSingleEdgePIX.metal
//  PixelKit Shaders
//
//  Created by Hexagons on 2017-11-21.
//  Copyright © 2017 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Uniforms{
    float amp;
    float dist;
};

kernel void effectSingleEdgeVOX(const device Uniforms& in [[ buffer(0) ]],
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
    float3 xyz = float3(x, y, z);
    
    float4 c = inTex.sample(s, xyz);

    uint w = inTex.get_width();
    uint h = inTex.get_height();
    uint d = inTex.get_depth();
    
    float4 cxp = inTex.sample(s, float3(x + in.dist / float(w), y, z));
    float4 cyp = inTex.sample(s, float3(x, y + in.dist / float(h), z));
    float4 czp = inTex.sample(s, float3(x, y, z + in.dist / float(d)));
    float4 cxn = inTex.sample(s, float3(x - in.dist / float(w), y, z));
    float4 cyn = inTex.sample(s, float3(x, y - in.dist / float(h), z));
    float4 czn = inTex.sample(s, float3(x, y, z - in.dist / float(d)));
    
    float cq = (c.r + c.g + c.b) / 3;
    float cxpq = (cxp.r + cxp.g + cxp.b) / 3;
    float cypq = (cyp.r + cyp.g + cyp.b) / 3;
    float czpq = (czp.r + czp.g + czp.b) / 3;
    float cxnq = (cxn.r + cxn.g + cxn.b) / 3;
    float cynq = (cyn.r + cyn.g + cyn.b) / 3;
    float cznq = (czn.r + czn.g + czn.b) / 3;
    
    float cp = (abs(cq - cxpq) + abs(cq - cypq) + abs(cq - czpq)) / 3;
    float cn = (abs(cq - cxnq) + abs(cq - cynq) + abs(cq - cznq)) / 3;
    float e = ((cp + cn) / 2) * in.amp;
    
    c = float4(e, e, e, 1.0);
    
    outTex.write(c, pos);
    
}


