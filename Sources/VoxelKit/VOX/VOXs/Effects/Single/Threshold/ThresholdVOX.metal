//
//  EffectSingleThresholdVOX.metal
//  PixelKit Shaders
//
//  Created by Hexagons on 2017-11-30.
//  Copyright © 2017 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Uniforms{
    float threshold;
};

kernel void effectSingleThresholdVOX(const device Uniforms& in [[ buffer(0) ]],
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
    float bw = (c.r + c.g + c.b) / 3;
        
    float t = (bw - in.threshold) / 0.001 + in.threshold;
    if (t < 0) {
        t = 0;
    } else if (t > 1) {
        t = 1;
    }
    
    c = float4(t, t, t, 1.0);
    
    outTex.write(c, pos);
    
}
