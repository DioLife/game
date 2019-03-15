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
    
    /*
     SpriteKit内容由SKView类呈现。 SKView对象呈现的内容称为场景，即SKScene对象。场景参与响应者链responder chain，并具有其他功能，使其适合游戏。
     **/
    var skView:SKView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.skView = SKView.init(frame: CGRect.init(x: 10, y: 10, width: ScreenWIDTH, height: <#T##CGFloat#>))
        
    }

}
