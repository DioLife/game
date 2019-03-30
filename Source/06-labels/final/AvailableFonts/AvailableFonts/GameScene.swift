/**
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
  
  var familyIndex: Int = -1
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(size: CGSize) {
    super.init(size: size)
    showNextFamily()
  }
  
  func showCurrentFamily() -> Bool {
    // 1
    removeAllChildren()

    // 2
    let familyName = UIFont.familyNames[familyIndex]

    // 3
    let fontNames = UIFont.fontNames(forFamilyName: familyName)
    if fontNames.count == 0 {
      return false
    }
    print("Family: \(familyName)")

    // 4
    for (idx, fontName) in fontNames.enumerated() {
      let label = SKLabelNode(fontNamed: fontName)
      label.text = fontName
      label.position = CGPoint(
        x: size.width / 2,
        y: (size.height * (CGFloat(idx+1))) /
          (CGFloat(fontNames.count)+1))
      label.fontSize = 50
      label.verticalAlignmentMode = .center
      addChild(label)
    }
    return true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>,
                             with event: UIEvent?) {
    showNextFamily()
  }
  
  func showNextFamily() {
    var familyShown = false
    repeat {
      familyIndex += 1
      if familyIndex >= UIFont.familyNames.count {
        familyIndex = 0
      }
      familyShown = showCurrentFamily()
    } while !familyShown
  }
}
