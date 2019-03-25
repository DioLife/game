//
//  TargetScene.swift
//  game
//
//  Created by lzd_free on 2019/3/22.
//  Copyright © 2019 Dio. All rights reserved.
//

import SpriteKit

class TargetScene: SKScene {
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.red
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scene = GameScene1.init(size: CGSize.init(width: ScreenWIDTH, height: ScreenHEIGHT))
        
        scene.scaleMode = .aspectFill
        
        self.view?.presentScene(scene)
    }
    
}
