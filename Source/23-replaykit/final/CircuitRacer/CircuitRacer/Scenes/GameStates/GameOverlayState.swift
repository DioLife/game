/*
* Copyright (c) 2016-2017 Razeware LLC
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
import GameplayKit

class GameOverlayState: GKState {
  
  unowned let gameScene: GameScene
  
  var overlay: SceneOverlay!
  var overlaySceneFileName: String { fatalError("Unimplemented overlaySceneName") }
  
  init(gameScene: GameScene) {
    self.gameScene = gameScene
    super.init()
    
    overlay = SceneOverlay(overlaySceneFileName: overlaySceneFileName, zPosition: 2)
    
    ButtonNode.parseButtonInNode(containerNode: overlay.contentNode)
  }
  
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    gameScene.isPaused = true
    gameScene.overlay = overlay
    
    // 1
    if self is GameSuccessState || self is GameFailureState {
      // 2
      if let autoRecordToggleButton = buttonWithIdentifier(identifier: .screenRecordingToggle) {
        autoRecordToggleButton.isHidden = !gameScene.screenRecordingAvailable
        autoRecordToggleButton.isSelected = gameScene.screenRecordingToggleEnabled
      }
      
      if let viewRecordedContentButton = buttonWithIdentifier(identifier: .viewRecordedContent) {
        // 3
        viewRecordedContentButton.isHidden = true
        
        // 4
        gameScene.stopScreenRecording {
          // 5
          if self.gameScene.levelType == .easy {
            viewRecordedContentButton.texture = SKTexture(imageNamed: "level_1_preview_frame")
          } else if self.gameScene.levelType == .medium {
            viewRecordedContentButton.texture = SKTexture(imageNamed: "level_2_preview_frame")
          } else {
            viewRecordedContentButton.texture = SKTexture(imageNamed: "level_3_preview_frame")
          }
          // 6
          let recordingEnabledAndPreviewAvailable = self.gameScene.screenRecordingToggleEnabled && self.gameScene.previewViewController != nil
          viewRecordedContentButton.isHidden = !recordingEnabledAndPreviewAvailable
        }
      }
    }
  }
  
  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    gameScene.isPaused = false
    gameScene.overlay = nil
  }
  
  func buttonWithIdentifier(identifier: ButtonIdentifier) -> ButtonNode? {
    return overlay.contentNode.childNode(withName: "//\(identifier.rawValue)") as? ButtonNode
  }
}
