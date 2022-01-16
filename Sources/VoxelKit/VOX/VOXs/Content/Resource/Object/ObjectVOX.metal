//
//  ContentResourceObjectVOX.metal
//  VoxelKitShaders
//
//  Created by Hexagons on 2019-10-05.
//  Copyright © 2019 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

constant int MAX = 10000;

struct Uniforms {
    float mode;
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
    uint a;
    uint b;
    uint c;
};

constant int TRICOUNT = 4;
struct Triangle {
    bool active;
    bool hit;
    float3 a;
    float3 b;
    float3 c;
};

float dot2(float3 v) { return dot(v,v); }

// http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
float triangleDist(float3 p, float3 a, float3 b, float3 c) {
    float3 ba = b - a; float3 pa = p - a;
    float3 cb = c - b; float3 pb = p - b;
    float3 ac = a - c; float3 pc = p - c;
    float3 nor = cross( ba, ac );
    return sqrt(
    (sign(dot(cross(ba,nor),pa)) +
     sign(dot(cross(cb,nor),pb)) +
     sign(dot(cross(ac,nor),pc))<2.0)
     ?
     min( min(
     dot2(ba*clamp(dot(ba,pa)/dot2(ba),0.0,1.0)-pa),
     dot2(cb*clamp(dot(cb,pb)/dot2(cb),0.0,1.0)-pb) ),
     dot2(ac*clamp(dot(ac,pc)/dot2(ac),0.0,1.0)-pc) )
     :
     dot(nor,pa)*dot(nor,pa)/dot2(nor) );
}

float sign(float2 p1, float2 p2, float2 p3) {
    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
}

bool pointInTriangle(float2 pt, float2 v1, float2 v2, float2 v3) {
    float d1, d2, d3;
    bool has_neg, has_pos;
    d1 = sign(pt, v1, v2);
    d2 = sign(pt, v2, v3);
    d3 = sign(pt, v3, v1);
    has_neg = (d1 < 0) || (d2 < 0) || (d3 < 0);
    has_pos = (d1 > 0) || (d2 > 0) || (d3 > 0);
    return !(has_neg && has_pos);
}

int triangleCount(array<Triangle, TRICOUNT> triangles) {
    for (int i = 0; i < TRICOUNT; ++i) {
        if (!triangles[i].active) {
            return i;
        }
    }
    return TRICOUNT;
}

kernel void contentResourceObjectVOX(const device Uniforms& in [[ buffer(0) ]],
                                     texture3d<float, access::write> outTex [[ texture(0) ]],
                                     const device array<UniformArray, MAX>& vertexArr [[ buffer(1) ]],
                                     const device array<bool, MAX>& vertexActiveArr [[ buffer(2) ]],
                                     const device array<UniformIndexArray, MAX>& polyArr [[ buffer(3) ]],
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
    // FIXME: Y Flip
    y = 1.0 - y;
    float3 xyz = float3(x, y, z);
    
    float3 trans = float3(in.tx, in.ty, in.tz);
    float3 scale = float3(in.s, in.s, in.s);
    
    bool color = false;
    array<Triangle, TRICOUNT> triangles;
    bool edge = false;
    bool inside = false;
    float psize = 2.0;
    float size = 0.5 / (d / psize);
    switch (int(in.mode)) {
        case 0: // Solid
            for (int i = 0; i < TRICOUNT; ++i) {
                Triangle triangle = Triangle();
                triangle.active = false;
                triangles[i] = triangle;
            }
            for (int i = 0; i < int(in.numPly); ++i) {
                int ia = polyArr[i].a;
                int ib = polyArr[i].b;
                int ic = polyArr[i].c;
                float3 pa = float3(vertexArr[ia].x, vertexArr[ia].y, vertexArr[ia].z);
                float3 pb = float3(vertexArr[ib].x, vertexArr[ib].y, vertexArr[ib].z);
                float3 pc = float3(vertexArr[ic].x, vertexArr[ic].y, vertexArr[ic].z);
                pa = (pa + trans) * scale + 0.5;
                pb = (pb + trans) * scale + 0.5;
                pc = (pc + trans) * scale + 0.5;
                if (pointInTriangle(float2(x, y), float2(pa.x, pa.y), float2(pb.x, pb.y), float2(pc.x, pc.y))) {
                    int count = triangleCount(triangles);
                    Triangle triangle = Triangle();
                    triangle.active = true;
                    triangle.hit = false;
                    triangle.a = pa;
                    triangle.b = pb;
                    triangle.c = pc;
                    triangles[count] = triangle;
                    if (count + 1 == TRICOUNT) {
                        break;
                    }
                }
            }
            for (int i = 0; i < int(d); ++i) {
                float3 p = float3(x, y, (float(i) + 0.5) / d);
                for (int j = 0; j < TRICOUNT; ++j) {
                    Triangle triangle = triangles[j];
                    if (!triangle.active) {
                        break;
                    }
                    if (triangle.hit) {
                        continue;
                    }
                    float dist = triangleDist(p, triangle.a, triangle.b, triangle.c);
                    if (dist < size) {
                        inside = !inside;
                        triangles[j].hit = true;
                        break;
                    }
                }
                if (i >= int(z * d)) {
                    break;
                }
            }
            color = inside;
            break;
        case 1: // Edge
            for (int i = 0; i < int(in.numPly); ++i) {
                int ia = polyArr[i].a;
                int ib = polyArr[i].b;
                int ic = polyArr[i].c;
                float3 pa = float3(vertexArr[ia].x, vertexArr[ia].y, vertexArr[ia].z);
                float3 pb = float3(vertexArr[ib].x, vertexArr[ib].y, vertexArr[ib].z);
                float3 pc = float3(vertexArr[ic].x, vertexArr[ic].y, vertexArr[ic].z);
                pa = (pa + trans) * scale + 0.5;
                pb = (pb + trans) * scale + 0.5;
                pc = (pc + trans) * scale + 0.5;
                float dist = triangleDist(xyz, pa, pb, pc);
                if (dist < size) {
                    edge = true;
                    break;
                }
            }
            color = edge;
            break;
    }
    
    float4 c = color ? 1.0 : 0.0;
    
    outTex.write(c, pos);
    
}

