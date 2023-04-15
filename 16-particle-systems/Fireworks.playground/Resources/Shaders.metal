#include <metal_stdlib>
using namespace metal;

kernel void compute(texture2d<half, access::read_write>
                                     output [[texture(0)]],
                    uint2 id [[thread_position_in_grid]]) {
  output.write(half4(0.0, 0.0, 0.0, 1.0), id);
}
