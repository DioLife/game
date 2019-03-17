//
//  MainViewController.swift
//  SpriteKitStudy
//
//  Created by hello on 2019/3/15.
//  Copyright © 2019 Dio. All rights reserved.
//
//https://www.jianshu.com/p/370ab95c0815
import UIKit
import SpriteKit

class MainViewController: UIViewController {
    
    var skView:SKView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = SKView()
        self.skView = self.view as? SKView
        if self.skView != nil {
            let scene = GameScene.init(size: CGSize.init(width: ScreenWIDTH - 20, height: ScreenHEIGHT - 100))
            
            scene.scaleMode = .aspectFill
            
            self.skView!.presentScene(scene)
            
            self.skView!.ignoresSiblingOrder = true
            
            self.skView!.showsFPS = true
            self.skView!.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
