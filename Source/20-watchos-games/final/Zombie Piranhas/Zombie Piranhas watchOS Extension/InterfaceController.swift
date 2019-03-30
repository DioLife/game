//
//  InterfaceController.swift
//  Zombie Piranhas watchOS Extension
//
//  Created by Michael Briscoe on 9/19/16.
//  Copyright © 2016 Razeware, LLC. All rights reserved.
//

import WatchKit
import Foundation
import SpriteKit
import CoreMotion


class InterfaceController: WKInterfaceController, WKCrownDelegate {
  
  @IBOutlet var skInterface: WKInterfaceSKScene!
  var gameScene: GameScene!
  let motionManager = CMMotionManager()
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    NotificationCenter.default.addObserver(self, selector: #selector(loadScene), name: NSNotification.Name("Reload"), object: nil)
    motionManager.accelerometerUpdateInterval = 1.0/30.0
    loadScene()
  }
  
  func loadScene() {
    gameScene = GameScene(fileNamed:"GameScene")
    gameScene.scaleMode = .aspectFill
    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
    skInterface.presentScene(gameScene, transition: reveal)
    skInterface.preferredFramesPerSecond = 30
  }
  
  @IBAction func didTap(_ sender: AnyObject) {
    // forward to the gameScene
    gameScene.didTap(sender as! WKTapGestureRecognizer)
  }
  
  @IBAction func didSwipe(_ sender: AnyObject) {
    // forward to the gameScene
    gameScene.didSwipe(sender as! WKSwipeGestureRecognizer)
  }
  
  func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
    let rotateSpeed = CGFloat(crownSequencer!.rotationsPerSecond)
    if rotateSpeed != 0.0 {
      gameScene.reelTurn(rotateSpeed: rotateSpeed)
    }
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    crownSequencer.delegate = self
    crownSequencer.focus()
    
    if motionManager.isAccelerometerAvailable {
      motionManager.startAccelerometerUpdates(
        to: OperationQueue.current!,
        withHandler: { data, error in
          guard let data = data else { return }
          self.gameScene.accelerometerUpdate(accelerometerData: data)
      })
    }
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
    motionManager.stopAccelerometerUpdates()
  }
  
}
