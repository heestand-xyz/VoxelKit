//
//  ContentResourceObjectVOX.metal
//  VoxelKitShaders
//
//  Created by Hexagons on 2019-10-05.
//  Copyright © 2019 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Uniforms {};

//struct UniformArray {
//    float x;
//    float y;
//    float z;
//};

kernel void contentResourceObjectVOX(const device Uniforms& in [[ buffer(0) ]],
                                     texture3d<float, access::write>  outTex [[ texture(0) ]],
                                     const device array<float3, 10000>& vertexArr [[ buffer(1) ]],
                                     const device array<int3, 10000>& polyArr [[ buffer(2) ]],
                                     uint3 pos [[ thread_position_in_grid ]],
                                     sampler s [[ sampler(0) ]]) {
    
    if (pos.x >= outTex.get_width() || pos.y >= outTex.get_height() || pos.z >= outTex.get_depth()) {
        return;
    }
    
    float4 c = 0.0;

    outTex.write(c, pos);
    
}

