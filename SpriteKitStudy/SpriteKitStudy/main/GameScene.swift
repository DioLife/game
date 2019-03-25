//
//  GameScene.swift
//  SpriteKitStudy
//
//  Created by hello on 2019/3/17.
//  Copyright © 2019 Dio. All rights reserved.
//


import SpriteKit

class GameScene: SKScene {
    
    var myTableView:UITableView!
    let identifier = "mycell"
    
    lazy var dataArray: Array<Dictionary<String,Any>> = {
        var arr = Array<Dictionary<String,Any>>()
        
        let spriteNodeScene = SpriteNodeScene.init(size: CGSize.init(width: ScreenWIDTH, height: ScreenWIDTH))
        let spriteNodeDict = ["title":"SKSpriteNode", "value":spriteNodeScene] as [String : Any]
        arr.append(spriteNodeDict)
        
        return arr
    }()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.yellow
        //设置UItabView的位置
        myTableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWIDTH, height: ScreenHEIGHT), style: UITableView.Style.plain)
        myTableView.backgroundColor = UIColor.orange
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        self.view?.addSubview(myTableView)
        myTableView.tableFooterView = UIView()
        
        //设置数据源
        myTableView.dataSource = self
        //设置代理
        myTableView.delegate = self
    }
    
}

extension GameScene:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let dict = dataArray[indexPath.row]
        cell.textLabel?.text = dict["title"] as? String
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = dataArray[indexPath.row]
        let scene = dict["value"] as! SKScene
        self.view?.presentScene(scene)
        self.myTableView.removeFromSuperview()
    }
    
}
