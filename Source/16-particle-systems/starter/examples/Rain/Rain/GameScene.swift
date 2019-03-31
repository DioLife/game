/*
 * Copyright (c) 2016 Razeware LLC
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
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */ 

import SpriteKit

class GameScene: SKScene {
  override func didMove(to view: SKView) {
    backgroundColor = SKColor.black
    let rainTexture = SKTexture(imageNamed: "Rain_Drop.png")
    let emitterNode = SKEmitterNode()
    
    emitterNode.particleTexture = rainTexture
    emitterNode.particleBirthRate = 80.0
    emitterNode.particleColor = SKColor.white
    emitterNode.particleSpeed = -450
    emitterNode.particleSpeedRange = 150
    emitterNode.particleLifetime = 2.0
    emitterNode.particleScale = 0.2
    emitterNode.particleScaleRange = 0.5
    emitterNode.particleAlpha = 0.75
    emitterNode.particleAlphaRange = 0.5
    
    emitterNode.position = CGPoint(x: frame.width / 2, y: frame.height + 10)
    emitterNode.particlePositionRange = CGVector(dx: frame.maxX, dy: 0)
    
    addChild(emitterNode)
  }
    
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    /* Called when a touch begins */
  }
  
  override func update(_ currentTime: TimeInterval) {
    /* Called before each frame is rendered */
  }
}
