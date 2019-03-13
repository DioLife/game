//
//  GameScene.swift
//  MyGame
//
//  Created by hello on 2019/2/26.
//  Copyright © 2019 game. All rights reserved.
//

//https://www.jianshu.com/p/304e84a12b91
import SpriteKit

enum GameStatus {
    case idle    //初始化
    case running    //游戏运行中
    case over    //游戏结束
}

class GameScene: SKScene {
    
    // 布置地面
    var floor1:SKSpriteNode!
    var floor2:SKSpriteNode!
    
    var bird: SKSpriteNode!//鸟
    
    var gameStatus: GameStatus = .idle  //表示当前游戏状态的变量，初始值为初始化状态
    
    
    //didMove()方法会在当前场景被显示到一个view上的时候调用，你可以在里面做一些初始化的工作
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        /*
         可以看到为什么我弄了两个floor？因为我们一会要让floor向左移动，使得看起来小鸟在向右飞，所以我弄了两个floor头尾两连地放着，等会我们就让两个floor一起往左边移动，当左边的floor完全超出屏幕的时候，就马上把左边的floor移动凭借到右边的floor后面然后继续向左移动，如此循环下去。
         **/
        floor1 = SKSpriteNode.init(imageNamed: "floor")
        floor1.anchorPoint = CGPoint.init(x: 0, y: 0)
        floor1.position = CGPoint.init(x: 0, y: 0)
        self.addChild(floor1)
        
        floor2 = SKSpriteNode.init(imageNamed: "floor")
        floor2.anchorPoint = CGPoint.init(x: 0, y: 0)
        floor2.position = CGPoint.init(x: floor1.size.width, y: 0)
        self.addChild(floor2)
        
        
        //配置 鸟
        bird = SKSpriteNode(imageNamed: "player1")
        addChild(bird)
        
        //首先在场景初始化完成的时候，肯定要先调用一下shuffle()初始化
        shuffle()
    }

    //update()方法为SKScene自带的系统方法，在画面每一帧刷新的时候就会调用一次
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if gameStatus != .over {
            moveScene()
        }
    }
    
    
    //现在我们知道了整个游戏会有三个进程状态，那么我们就给GameScene增加三个对应的方法，分别来处理这个三个状态。
    func shuffle()  {
        //游戏初始化处理方法
        gameStatus = .idle
        removeAllPipesNode()
        bird.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        birdStartFly()
    }
    func startGame()  {
        //游戏开始处理方法
        gameStatus = .running
        startCreateRandomPipesAction()  //开始循环创建随机水管
    }
    func gameOver()  {
        //游戏结束处理方法
        gameStatus = .over
        birdStopFly()
        stopCreateRandomPipesAction()
    }
    
    
    /*
     touchesBegan()是SKScene自带的系统方法，当玩家手指点击到屏幕上的时候会调用，可以看到我们用switch语句来处理了三种不同的游戏状态下，玩家点击屏幕后做出的不同响应
     **/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameStatus {
        case .idle:
            startGame()//如果在初始化状态下，玩家点击屏幕则开始游戏
        case .running:
            print("给小鸟一个向上的力")//如果在游戏进行中状态下，玩家点击屏幕则给小鸟一个向上的力(暂时用print一句话代替)
        case .over:
            shuffle() //如果在游戏结束状态下，玩家点击屏幕则进入初始化状态
        }
    }

    
    //移动地面
    func moveScene() {
        /*
         我们在这个方法里先让两个floor向左移动1的位置，然后检查两个floor是否已经完全超出屏幕的左边，超出的floor则移动到另一个floor的右边。
         **/
        //make floor move
        floor1.position = CGPoint(x: floor1.position.x - 1, y: floor1.position.y)
        floor2.position = CGPoint(x: floor2.position.x - 1, y: floor2.position.y)
        //check floor position
        if floor1.position.x < -floor1.size.width {
            floor1.position = CGPoint(x: floor2.position.x + floor2.size.width, y: floor1.position.y)
        }
        if floor2.position.x < -floor2.size.width {
            floor2.position = CGPoint(x: floor1.position.x + floor1.size.width, y: floor2.position.y)
        }
        
        //循环检查场景的子节点，同时这个子节点的名字要为pipe
        for pipeNode in self.children where pipeNode.name == "pipe" {
            //因为我们要用到水管的size，但是SKNode没有size属性，所以我们要把它转成SKSpriteNode
            if let pipeSprite = pipeNode as? SKSpriteNode {
                //将水管左移1
                pipeSprite.position = CGPoint(x: pipeSprite.position.x - 1, y: pipeSprite.position.y)
                //检查水管是否完全超出屏幕左侧了，如果是则将它从场景里移除掉
                if pipeSprite.position.x < -pipeSprite.size.width * 0.5 {
                    pipeSprite.removeFromParent()
                }
            }
        }
    }
    
    
    /*
     先给GameScene添加两个新的方法，一个是让小鸟开始飞，一个是让小鸟停止飞(游戏结束，小鸟坠地了就要停止飞)
     **/
    //开始飞
    func birdStartFly() {
        /*
         我们用了准备的3张小鸟的图片生成了四个SKTexture纹理对象，他们四个连起来就是小鸟的翅膀从上->中->下->中这样一个循环过程然后用这一组纹理创建了一个飞的动作(flyAction)，同时设置纹理的变化时间为0.15秒然后让小鸟重复循环执行这个飞的动作，同时给这个动作使用了一个叫"fly"的key来标识在birdStopFly()方法里只有一句代码，就是把fly这个动作从小鸟身上移除掉
         **/
        let flyAction = SKAction.animate(with: [SKTexture(imageNamed: "player1"), SKTexture(imageNamed: "player2"),SKTexture(imageNamed: "player3"),SKTexture(imageNamed: "player2")],timePerFrame: 0.15)
        bird.run(SKAction.repeatForever(flyAction), withKey: "fly")
    }
    //停止飞
    func birdStopFly() {
        bird.removeAction(forKey: "fly")
    }
 
    
    //添加一对水管到场景里，这个方法有两个参数分别是上水管和下水管的大小，在此方法里仅仅做的是创建两个SKSpriteNode对象，然后将他们加到场景里
    func addPipes(topSize: CGSize, bottomSize: CGSize) {
        //创建上水管
        let topTexture = SKTexture(imageNamed: "topPipe")      //利用上水管图片创建一个上水管纹理对象
        let topPipe = SKSpriteNode(texture: topTexture, size: topSize)  //利用上水管纹理对象和传入的上水管大小参数创建一个上水管对象
        topPipe.name = "pipe"   //给这个水管取个名字叫pipe
        topPipe.position = CGPoint(x: self.size.width + topPipe.size.width * 0.5, y: self.size.height - topPipe.size.height * 0.5) //设置上水管的垂直位置为顶部贴着屏幕顶部，水平位置在屏幕右侧之外
        
        //创建下水管，每一句方法都与上面创建上水管的相同意义
        let bottomTexture = SKTexture(imageNamed: "bottomPipe")
        let bottomPipe = SKSpriteNode(texture: bottomTexture, size: bottomSize)
        bottomPipe.name = "pipe"
        bottomPipe.position = CGPoint(x: self.size.width + bottomPipe.size.width * 0.5, y: self.floor1.size.height + bottomPipe.size.height * 0.5)  //设置下水管的垂直位置为底部贴着地面的顶部，水平位置在屏幕右侧之外
        
        //将上下水管添加到场景里
        addChild(topPipe)
        addChild(bottomPipe)
    }
 
    //具体某一次创建一对水管方法，在此方法里计算上下水管大小随机数
    func createRandomPipes() {
        //先计算地板顶部到屏幕顶部的总可用高度
        let height = self.size.height - self.floor1.size.height
        //计算上下管道中间的空档的随机高度，最小为空档高度为2.5倍的小鸟的高度，最大高度为3.5倍的小鸟高度
        let pipeGap = CGFloat(arc4random_uniform(UInt32(bird.size.height))) + bird.size.height * 2.5
        //管道宽度在60
        let pipeWidth = CGFloat(60.0)
        //随机计算顶部pipe的随机高度，这个高度肯定要小于(总的可用高度减去空档的高度)
        let topPipeHeight = CGFloat(arc4random_uniform(UInt32(height - pipeGap)))
        //总可用高度减去空档gap高度减去顶部水管topPipe高度剩下就为底部的bottomPipe高度
        let bottomPipeHeight = height - pipeGap - topPipeHeight
        //调用添加水管到场景方法
        addPipes(topSize: CGSize(width: pipeWidth, height: topPipeHeight), bottomSize: CGSize(width: pipeWidth, height: bottomPipeHeight))
    }
    
    // 开始重复创建水管的动作方法
    func startCreateRandomPipesAction() {
        //创建一个等待的action,等待时间的平均值为3.5秒，变化范围为1秒
        let waitAct = SKAction.wait(forDuration: 3.5, withRange: 1.0)
        //创建一个产生随机水管的action，这个action实际上就是调用一下我们上面新添加的那个createRandomPipes()方法
        let generatePipeAct = SKAction.run {
            self.createRandomPipes()
        }
        //让场景开始重复循环执行"等待" -> "创建" -> "等待" -> "创建"。。。。。
        //并且给这个循环的动作设置了一个叫做"createPipe"的key来标识它
        run(SKAction.repeatForever(SKAction.sequence([waitAct, generatePipeAct])), withKey: "createPipe")
    }
    
    // 停止创建水管的动作方法
    func stopCreateRandomPipesAction() {
        self.removeAction(forKey: "createPipe")
    }
    
    // 移除掉场景里的所有水管
    func removeAllPipesNode() {
        for pipe in self.children where pipe.name == "pipe" {  //循环检查场景的子节点，同时这个子节点的名字要为pipe
            pipe.removeFromParent()  //将水管这个节点从场景里移除掉
        }
    }
    
}
