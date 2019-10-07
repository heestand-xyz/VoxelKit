//
//  EffectMergerDisplaceVOX.metal
//  PixelKitShaders
//
//  Created by Hexagons on 2017-11-14.
//  Copyright © 2017 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Uniforms{
    float dist;
    float origin;
};

kernel void effectMergerDisplaceVOX(const device Uniforms& in [[ buffer(0) ]],
                                    texture3d<float, access::sample> inTexA [[ texture(0) ]],
                                    texture3d<float, access::sample> inTexB [[ texture(1) ]],
                                    texture3d<float, access::write>  outTex [[ texture(2) ]],
                                    uint3 pos [[ thread_position_in_grid ]],
                                    sampler s [[ sampler(0) ]]) {
    
    if (pos.x >= outTex.get_width() || pos.y >= outTex.get_height() || pos.z >= outTex.get_depth()) {
      return;
    }
    
    float x = float(pos.x + 0.5) / float(outTex.get_width());
    float y = float(pos.y + 0.5) / float(outTex.get_height());
    float z = float(pos.z + 0.5) / float(outTex.get_depth());
    float3 xyz = float3(x, y, z);
    
    float4 cb = inTexB.sample(s, xyz);

    float4 ca = inTexA.sample(s, float3(x + (cb.r - in.origin) * in.dist,
                                        y + (cb.g - in.origin) * in.dist,
                                        z + (cb.b - in.origin) * in.dist));
    
    outTex.write(ca, pos);
    
}


