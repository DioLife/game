//
//  SpriteNodeScene.swift
//  SpriteKitStudy
//
//  Created by lzd_free on 2019/3/22.
//  Copyright © 2019 Dio. All rights reserved.
//

import SpriteKit

class SpriteNodeScene: SKScene {
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.yellow
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scene = GameScene.init(size: CGSize.init(width: ScreenWIDTH, height: ScreenHEIGHT))
        self.view?.presentScene(scene)
    }
    
}
