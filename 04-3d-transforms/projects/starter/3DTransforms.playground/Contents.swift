import MetalKit
import PlaygroundSupport

// set up View
device = MTLCreateSystemDefaultDevice()!
let frame = NSRect(x: 0, y: 0, width: 600, height: 600)
let view = MTKView(frame: frame, device: device)
view.clearColor = MTLClearColor(red: 1, green: 1, blue: 0.8, alpha: 1)
view.device = device

// Metal set up is done in Utility.swift

// set up render pass
guard let drawable = view.currentDrawable,
  let descriptor = view.currentRenderPassDescriptor,
  let commandBuffer = commandQueue.makeCommandBuffer(),
  let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
    fatalError()
}

renderEncoder.setRenderPipelineState(pipelineState)

// drawing code here
var vertices: [float3] = [[0, 0, 0.5]]
var matrix = matrix_identity_float4x4
let originalBuffer = device.makeBuffer(bytes: &vertices,
      length: MemoryLayout<float3>.stride * vertices.count,
      options: [])

renderEncoder.setVertexBuffer(originalBuffer,
                              offset: 0, index: 0)
renderEncoder.setFragmentBytes(&lightGrayColor,
                    length: MemoryLayout<float4>.stride,
                    index: 0)

//renderEncoder.setVertexBytes(&matrix, length: MemoryLayout<float4x4>.stride, index: 1)

renderEncoder.drawPrimitives(type: .point, vertexStart: 0,
                             vertexCount: vertices.count)

matrix.columns.3 = [0.3, -0.4, 0, 1]

renderEncoder.setVertexBytes(&matrix, length: MemoryLayout<float4x4>.stride, index: 1)

var transformedBuffer = device.makeBuffer(bytes: &vertices,
       length: MemoryLayout<float3>.stride * vertices.count,
       options: [])

renderEncoder.setVertexBuffer(transformedBuffer,
                              offset: 0, index: 0)
renderEncoder.setFragmentBytes(&redColor,
                       length: MemoryLayout<float4>.stride,
                       index: 0)
renderEncoder.drawPrimitives(type: .point, vertexStart: 0,
                       vertexCount: vertices.count)

renderEncoder.endEncoding()
commandBuffer.present(drawable)
commandBuffer.commit()

PlaygroundPage.current.liveView = view
