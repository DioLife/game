//
//  SKNodeViewController.swift
//  game
//
//  Created by lzd_free on 2019/3/21.
//  Copyright © 2019 Dio. All rights reserved.
//

import UIKit
import SpriteKit
//http://www.demodashi.com/demo/10667.html
class SKNodeViewController: UIViewController {

    var skView:SKView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = SKView()
        self.skView = self.view as? SKView
        if self.skView != nil {
            let scene = GameScene1.init(size: CGSize.init(width: ScreenWIDTH - 20, height: ScreenHEIGHT - 100))
            
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
