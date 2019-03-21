//
//  ViewController.swift
//  game
//
//  Created by lzd_free on 2019/3/21.
//  Copyright © 2019 Dio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    let identifier = "mycell"

    lazy var dataArray: Array<UIViewController> = {
        var dataArray = Array<UIViewController>()
        
        let skSpriteNodeVC = SKSpriteNodeVC()
        skSpriteNodeVC.title = "SKSpriteNode"
        dataArray.append(skSpriteNodeVC)
        
        let skNodeVC = SKNodeViewController()
        skNodeVC.title = "SKNode"
        dataArray.append(skNodeVC)
        
        return dataArray
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.tableFooterView = UIView()
    }


}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = dataArray[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
}

extension ViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let vc = dataArray[indexPath.row]
        cell.textLabel?.text = vc.title
        return cell
    }
    
}
