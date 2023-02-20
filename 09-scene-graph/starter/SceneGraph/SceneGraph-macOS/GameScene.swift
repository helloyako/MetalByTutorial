//
/**
 * Copyright (c) 2019 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import Foundation

class GameScene: Scene {
    let ground = Model(name: "ground.obj")
    let car = Model(name: "racing-car.obj")
    let skeleton = Model(name: "skeleton.usda")

    var inCar = false

    override func setupScene() {
        inputController.keyboardDelegate = self
        ground.tiling = 32
        add(node: ground)

        car.rotation = [0, .pi / 2, 0]
        car.position = [-0.8, 0, 0]
        add(node: car)

        skeleton.position = [-0.35, -0.2, -0.35]
        skeleton.rotation = [0, 0, 0]
        add(node: skeleton, parent: car)

        skeleton.runAnimation(name: "sit")

        camera.position = [0, 1.2, -4]

        inputController.player = camera
    }

    override func updateScene(deltaTime: Float) {
        
    }
}

extension GameScene: KeyboardDelegate {
    func keyPressed(key: KeyboardControl, state: InputState) -> Bool {
        switch key {
        case .c where state == .ended:
            let camera = cameras[0]
            if inCar {
                remove(node: car)
                add(node: car)
                car.position = camera.position + (camera.rightVector * 1.3)
                car.position.y = 0
                car.rotation = camera.rotation
                inputController.translationSpeed = 2.0

            } else {
                remove(node: skeleton)
                remove(node: car)
                add(node: car, parent: camera)
                car.position = [0.35, -1, 0.1]
                car.rotation = [0, 0, 0]
                inputController.translationSpeed = 10.0
            }
            inCar.toggle()
            return false
        default:
            break
        }
        return true
    }
}
