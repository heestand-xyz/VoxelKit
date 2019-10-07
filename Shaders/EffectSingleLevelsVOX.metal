//
//  EffectSingleLevelsPIX.metal
//  PixelKit Shaders
//
//  Created by Hexagons on 2017-11-07.
//  Copyright © 2017 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Uniforms {
    float brightness;
    float darkness;
    float contrast;
    float gamma;
    float invert;
    float opacity;
};

kernel void effectSingleLevelsVOX(const device Uniforms& in [[ buffer(0) ]],
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
    
    float a = c.a * in.opacity;
    
    c *= 1 / (1.0 - in.darkness);
    c -= 1.0 / (1.0 - in.darkness) - 1;
    
    c *= in.brightness;
    
    c -= 0.5;
    c *= 1.0 + in.contrast;
    c += 0.5;
    
    c = pow(c, 1 / max(0.001, in.gamma));
    
    if (in.invert) {
        c = 1.0 - c;
    }
    
    c *= in.opacity;
    
    c = float4(c.r, c.g, c.b, a);
    
    outTex.write(c, pos);
    
}


