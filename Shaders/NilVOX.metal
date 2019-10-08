//
//  NilVOX.metal
//  VoxelKitShaders
//
//  Created by Anton Heestand on 2019-10-08.
//  Copyright © 2019 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void nilVOX(texture3d<float, access::sample> inTex [[ texture(0) ]],
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

    outTex.write(c, pos);
    
}


