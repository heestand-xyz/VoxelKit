//
//  ContentResourceObjectVOX.metal
//  VoxelKitShaders
//
//  Created by Hexagons on 2019-10-05.
//  Copyright © 2019 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//float dot2(float3 v) { return dot(v,v); }
//
//float triangle(float3 p, float3 a, float3 b, float3 c) {
//    float3 ba = b - a; float3 pa = p - a;
//    float3 cb = c - b; float3 pb = p - b;
//    float3 ac = a - c; float3 pc = p - c;
//    float3 nor = cross( ba, ac );
//    return sqrt(
//    (sign(dot(cross(ba,nor),pa)) +
//     sign(dot(cross(cb,nor),pb)) +
//     sign(dot(cross(ac,nor),pc))<2.0f)
//     ?
//     min( min(
//     dot2(ba*clamp(dot(ba,pa)/dot2(ba),0.0f,1.0f)-pa),
//     dot2(cb*clamp(dot(cb,pb)/dot2(cb),0.0f,1.0f)-pb) ),
//     dot2(ac*clamp(dot(ac,pc)/dot2(ac),0.0f,1.0f)-pc) )
//     :
//     dot(nor,pa)*dot(nor,pa)/dot2(nor) );
//}

struct Uniforms {
    float tx;
    float ty;
    float tz;
    float s;
    float numVtx;
    float numPly;
};

struct UniformArray {
    float x;
    float y;
    float z;
};

struct UniformIndexArray {
    int a;
    int b;
    int c;
};

kernel void contentResourceObjectVOX(const device Uniforms& in [[ buffer(0) ]],
                                     texture3d<float, access::write> outTex [[ texture(0) ]],
                                     const device array<UniformArray, 10000>& vertexArr [[ buffer(1) ]],
                                     const device array<bool, 10000>& vertexActiveArr [[ buffer(2) ]],
                                     const device array<UniformIndexArray, 10000>& polyArr [[ buffer(3) ]],
                                     uint3 pos [[ thread_position_in_grid ]],
                                     sampler s [[ sampler(0) ]]) {
    
    if (pos.x >= outTex.get_width() || pos.y >= outTex.get_height() || pos.z >= outTex.get_depth()) {
        return;
    }
    
    float w = float(outTex.get_width());
    float h = float(outTex.get_height());
    float d = float(outTex.get_depth());
    float x = float(pos.x + 0.5) / w;
    float y = float(pos.y + 0.5) / h;
    float z = float(pos.z + 0.5) / d;
    float3 xyz = float3(x, y, z);
    
    float3 trans = float3(in.tx, in.ty, in.tz);
    float3 scale = float3(in.s, in.s, in.s);
    
//    float shape = 0.0;
//    float psize = 2.0;
//    float size = 0.5 / (w / psize);
    float3 closePoint = 0.0;
    float closeDist = 0.0;
    for (int i = 0; i < int(in.numPly); ++i) {
        int ia = polyArr[i].a;
        int ib = polyArr[i].b;
        int ic = polyArr[i].c;
        float3 pa = float3(vertexArr[ia].x, vertexArr[ia].y, vertexArr[ia].z);
        float3 pb = float3(vertexArr[ib].x, vertexArr[ib].y, vertexArr[ib].z);
        float3 pc = float3(vertexArr[ic].x, vertexArr[ic].y, vertexArr[ic].z);
        pa += trans;
        pb += trans;
        pc += trans;
        pa *= scale;
        pb *= scale;
        pc *= scale;
        pa += 0.5;
        pb += 0.5;
        pc += 0.5;
        float3 avg = (pa + pb + pc) / 3;
        float3 dist3 = avg - xyz;
        float dist = sqrt(sqrt(pow(dist3.x, 2) + pow(dist3.y, 2)) + pow(dist3.z, 2));
        if (i == 0 || dist < closeDist) {
            closePoint = avg;
            closeDist = dist;
        }
//        float dist = triangle(xyz, pa, pb, pc);
//        if (dist < size) {
//            shape = 1.0;
//            break;
//        }
    }
    float shape = closeDist;
    
    float4 c = float4(shape, shape, shape, 1.0);

    outTex.write(c, pos);
    
}

