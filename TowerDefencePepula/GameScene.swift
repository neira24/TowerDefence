//
//  GameScene.swift
//  TowerDefencePepula
//
//  Created by Lauri Roomere on 15/01/2019.
//  Copyright © 2019 Lauri Roomere. All rights reserved.
//

import SpriteKit
import GameplayKit

enum SquareType{
    case Empty
    case Tower
    case Castle
    case Destroyed
}

enum BulletType {
    case towerFired
    case invaderFired
}

enum InvaderType{
    case defaulInfantry
    case tank
    case chopper
    static var size: CGSize {
        return CGSize(width: 24, height: 16)
    }
    static var name: String {
        return "invader"
    }
    var health: Int {
        return 100
    }
   
    
}


//https://www.freesoundeffects.com/free-sounds/cannon-10077/

class GameScene: SKScene,SKPhysicsContactDelegate{
    var timePerMove: CFTimeInterval = 1.0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var gameLogo: SKLabelNode!
    var bestScore: SKLabelNode!
    var playButton: SKShapeNode!
    var game:GameManager!
    var currentScore: SKLabelNode!
    var gameBG: SKShapeNode!
    var invadersArray:[SKNode]=[]
    var gameArray: [(node:SKShapeNode, x:Int,y:Int,type: SquareType,health:Int?)]=[]
    let kTowerFiredBulletName = "towerFiredBullet"
    let kInvaderFiredBulletName = "invaderFiredBullet"
    let kBulletSize = CGSize(width:4, height: 8)
    var contactQueue = [SKPhysicsContact]()
    
    let kInvaderCategory: UInt32 = 0x1 << 0
    let kShipFiredBulletCategory: UInt32 = 0x1 << 1
    let kShipCategory: UInt32 = 0x1 << 2
    let kSceneEdgeCategory: UInt32 = 0x1 << 3
    let kInvaderFiredBulletCategory: UInt32 = 0x1 << 4

    
    
    override func didMove(to view: SKView) {
       
        // Get label node from scene and store it for use later
       physicsWorld.contactDelegate = self
       initializeMenu()
       game=GameManager(scene:self)
       initializeGameView()
     
        
     
    }
 
    func didBegin(_ contact: SKPhysicsContact) {
        //contactQueue.append(contact)
        print(contact.bodyA.node?.name!)
        print(contact.bodyB.node?.name!)
      
        if contact.bodyA.node?.name==InvaderType.name && contact.bodyB.node?.name == kTowerFiredBulletName {
            
            print("Contact")
           var health=contact.bodyA.node?.userData?.value(forKey:"health") as! Int
            
            if(health==0){
              contact.bodyA.node?.removeFromParent()
              print("Dealloc tank bf count",self.invadersArray.count)
             self.invadersArray.remove(at: 0);
             print("Dealloc tank count af",self.invadersArray.count)
            }else{
              health=health-10
              contact.bodyA.node?.userData?.setValue(health, forKey: "health")
             
            }
        }
        
    }
    
    
    func handle(_ contact: SKPhysicsContact) {
      
     
    }
    func processContacts(forUpdate currentTime: CFTimeInterval) {
        for contact in contactQueue {
            handle(contact)
            
            if let index = contactQueue.index(of: contact) {
                contactQueue.remove(at: index)
            }
        }
    }

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        game.update(time: currentTime)
        processContacts(forUpdate: currentTime)
    }
    
    private func initializeMenu() {
        //Create game title
        gameLogo = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        gameLogo.zPosition = 1
        gameLogo.position = CGPoint(x: 0, y: (frame.size.height / 2) - 200)
        gameLogo.fontSize = 60
        gameLogo.text = "TowerDefencePepula"
        gameLogo.fontColor = SKColor.red
        self.addChild(gameLogo)
        //Create best score label
        bestScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        bestScore.zPosition = 1
        bestScore.position = CGPoint(x: 0, y: gameLogo.position.y - 50)
        bestScore.fontSize = 40
        bestScore.text = "Best Score: 0"
        bestScore.fontColor = SKColor.white
        self.addChild(bestScore)
        //Create play button
        playButton = SKShapeNode()
        playButton.name = "play_button"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        playButton.fillColor = SKColor.cyan
        let topCorner = CGPoint(x: -50, y: 50)
        let bottomCorner = CGPoint(x: -50, y: -50)
        let middle = CGPoint(x: 50, y: 0)
        let path = CGMutablePath()
        path.addLine(to: topCorner)
        path.addLines(between: [topCorner, bottomCorner, middle])
        playButton.path = path
        self.addChild(playButton)
    }
    //Remove from here
    
    @objc func loadInvadersToScene(){
        let countOfInvaders=Int.random(in: 3 ... 10)
        
        for _ in 0...countOfInvaders{
            var tank: SKNode
            let randomX=Int.random(in: 0 ... 300)
            let randomY=Int.random(in: 0 ... 400)
         
            tank=self.makeInvader(ofType: InvaderType.tank,pos: CGPoint(x:randomX, y:randomY ))
            tank.position=CGPoint(x:randomX, y:randomY )
           // gameArray.append((tank as! SKShapeNode,2,2,SquareType.Empty,100))
           // gameBG.addChild(tank)
            
            gameBG.addChild(tank)
        
          
            invadersArray.append(tank)
        
        }
        
        
        
        
        
    }
    
    
    func loadInvaderTextures(ofType invaderType: InvaderType) -> [SKTexture] {
        
        var prefix: String
        
        switch(invaderType) {
        case .defaulInfantry:
            prefix = "InvaderDefault"
        case .tank:
            prefix = "InvaderTank"
        case .chopper:
            prefix = "InvaderChopper"
        }
        
        // 1
        return [SKTexture(imageNamed: String(format: "%@_00.png", prefix)),
                SKTexture(imageNamed: String(format: "%@_01.png", prefix))]
    }
    
    func loadTowerTextures(ofType towerType: SquareType) -> [SKTexture] {
        
        var prefix: String
        
        switch(towerType) {
        case .Tower:
            prefix = "Tower"
        case .Castle:
            prefix = "Castle"
        case .Empty:
            prefix = "Empty"
        case .Destroyed:
            prefix="Destoryed"
        }
        
        // 1
        return [SKTexture(imageNamed: String(format: "%@_00.png", prefix)),
                SKTexture(imageNamed: String(format: "%@_01.png", prefix))]
    }
    
    func makeInvader(ofType invaderType:InvaderType, pos:CGPoint)->SKNode{
        
        let invaderTextures = loadInvaderTextures(ofType: invaderType)
        
        // 2
        let invader = SKSpriteNode(texture: invaderTextures[0])
        invader.name = InvaderType.name
        invader.userData=NSMutableDictionary()
        invader.position=pos
        
        invader.userData?.setValue(100, forKey: "health")
        
        // 3
        //invader.run(SKAction.repeatForever(SKAction.animate(with: invaderTextures, timePerFrame: timePerMove)))
        
        // invaders' bitmasks setup
        invader.physicsBody = SKPhysicsBody(rectangleOf: invader.frame.size)
        invader.physicsBody!.isDynamic = false
        invader.physicsBody!.categoryBitMask = kInvaderCategory
        invader.physicsBody!.contactTestBitMask = kShipFiredBulletCategory
        invader.physicsBody!.collisionBitMask = 0
        
   
        return invader
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event:UIEvent?){
       
        for touch in touches{
            
            let location=touch.location(in: self)
            let touchedNode=self.nodes(at:location)
              print("Touched at x: ",location.x,"y: ",location.y)
            for node in touchedNode{
                if node.name=="play_button"{
                    startGame()
                }else{
                    //19:39
                  
                  
                    
                }
            }
            for (node,x,y,type,health) in gameArray{
                
                let index=gameArray.firstIndex { (item) -> Bool in
                    
                    return item==(node,x,y,type,health)
                }
                
                
                
                if(node.contains(location)){
                    if(type==SquareType.Tower){
                        node.fillColor=SKColor.blue
                        gameArray.remove(at: index!)
                        node.name="Tower"
                     
                        let invaderTextures = loadTowerTextures(ofType: type)
                        
                        // 2
                       node.fillTexture = invaderTextures[0]
                      
                       // let invader = SKSpriteNode(texture: invaderTextures[0])
                        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.frame.width, height: node.frame.height))
                        node.physicsBody!.isDynamic=false
                        node.physicsBody!.categoryBitMask=kShipCategory
                        node.physicsBody!.contactTestBitMask=kShipFiredBulletCategory
                        node.physicsBody!.collisionBitMask=0
                        
                        gameArray.insert((node,x,y,SquareType.Castle,health), at: index!)
                       
                        let bullet=makeBullet(ofType: .towerFired)
                        bullet.position=CGPoint(
                            x:location.x,
                            y:location.y+node.frame.height-bullet.frame.size.height / 2
                        )
                        
                        let bulletDestination=CGPoint(
                            x:location.x,
                            y:frame.size.height+bullet.frame.size.height/2
                            
                        
                        )
                     
                        fireBullet(bullet: bullet, toDestination: bulletDestination, withDuration: 1.0, andSoundFileName: "Cannon+2.wav")
                        
                        break
                        
                        
                    }
                    
                    if(type==SquareType.Castle){
                        node.name="Castle"
                        
                        let invaderTextures = loadTowerTextures(ofType: type)
                        node.fillTexture = invaderTextures[0]
                        let bullet=makeBullet(ofType: .towerFired)
                        bullet.position=CGPoint(
                            x:location.x,
                            y:location.y+node.frame.height-bullet.frame.size.height / 2
                        )
                        
                        let bulletDestination=CGPoint(
                            x:location.x,
                            y:frame.size.height+bullet.frame.size.height/2
                            
                            
                        )
                        
                        fireBullet(bullet: bullet, toDestination: bulletDestination, withDuration: 1.0, andSoundFileName: "Cannon+2.wav")
                        
                        
                    }
                    if(type==SquareType.Empty){
                        node.fillColor=SKColor.red
                        gameArray.remove(at: index!)
                        gameArray.insert((node,x,y,SquareType.Tower,health), at: index!)
                        break
                    }
                    
                }
            
            
            
        }
      
        
            
            
            
            
            
        }
        
    }
    
    private func startGame(){
        
        print("Start game")
        
        gameLogo.isHidden=true
        playButton.isHidden=true
        let bottomCorner=CGPoint(x: 0, y: (frame.size.height / -2)+20)
        bestScore.run(SKAction.move(to: bottomCorner, duration: 0.4)){
            
            self.gameBG.setScale(0)
            self.currentScore.setScale(0)
            self.gameBG.isHidden=false
            self.currentScore.isHidden=false
            self.gameBG.run(SKAction.scale(to: 1, duration: 0.4))
            self.currentScore.run(SKAction.scale(to: 1, duration: 0.4))
            self.game.initGame()
           
            
        }
        perform(#selector(loadInvadersToScene), with: nil, afterDelay: 3)
        //Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector:Selector("loadInvadersToScene:"), userInfo:nil, repeats: false)
     
    }
    
    private func initializeGameView(){
        
        
        currentScore=SKLabelNode(fontNamed: "ArialRoundedMTBold")
        currentScore.zPosition=1
        currentScore.position=CGPoint(x: 0, y: (frame.size.height / -2)+60)
        currentScore.fontSize=40
        currentScore.isHidden=true
        currentScore.text="Score: 0"
        currentScore.fontColor=SKColor.white
        self.addChild(currentScore)
        let width = frame.size.width-200
        let heigt = frame.size.height-300
        let rect=CGRect(x: -width/2, y: -heigt/2, width: width, height: heigt)
        gameBG=SKShapeNode(rect: rect, cornerRadius:0.02)
        gameBG.fillColor=SKColor.green
        gameBG.fillTexture=SKTexture(image: UIImage(named:"towerDefense_tile157.png")!)
        gameBG.zPosition=2
        gameBG.isHidden=true
        self.addChild(gameBG)
        createGameBoard(width:Int(width),height:Int(heigt))
        
        
        
    }
    
    private func createGameBoard(width: Int,height: Int){
        
        let cellWidth: CGFloat=60.5
        let numRows=17
        let numCols=20
        var x=CGFloat(width / -2)+(cellWidth / 2)
        var y=CGFloat(height / 2)-(cellWidth / 2)
        for i in 0...numRows-1{
            for j in 0...numCols-1{
                let cellNode=SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                cellNode.strokeColor=SKColor.black
                cellNode.zPosition=2
                cellNode.position=CGPoint(x: x, y: y)
                cellNode.name="Empty"
                
                
                
                gameArray.append((node:cellNode , x: i, y: j,type:SquareType.Empty,health:100))
                self.addChild(cellNode)
            
                x+=cellWidth
                
                
            }
            x=CGFloat(width / -2)+(cellWidth / 2)
            y-=cellWidth
            
            
            
        }
        
      
        
    }
    
    func makeBullet(ofType bulletType: BulletType) -> SKNode {
        var bullet: SKNode
        
        switch bulletType {
        case .towerFired:
            bullet = SKSpriteNode(color: SKColor.red, size: kBulletSize)
            bullet.name = kTowerFiredBulletName
            bullet.physicsBody=SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
            bullet.physicsBody?.isDynamic=true
            bullet.physicsBody?.categoryBitMask=kShipFiredBulletCategory
            bullet.physicsBody?.contactTestBitMask=kShipCategory
            bullet.physicsBody?.collisionBitMask=kShipCategory
        case .invaderFired:
            bullet = SKSpriteNode(color: SKColor.magenta, size: kBulletSize)
            bullet.name = kInvaderFiredBulletName
            bullet.physicsBody=SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
            bullet.physicsBody?.isDynamic=true
            bullet.physicsBody?.categoryBitMask=kInvaderFiredBulletCategory
            bullet.physicsBody?.contactTestBitMask=kInvaderCategory
            bullet.physicsBody?.collisionBitMask=kInvaderCategory
            break
        }
        
        return bullet
    }
    
    
    func fireBullet(bullet: SKNode, toDestination destination: CGPoint, withDuration duration: CFTimeInterval, andSoundFileName soundName: String) {
        // 1
        let bulletAction = SKAction.sequence([
            SKAction.move(to: destination, duration: duration),
            SKAction.wait(forDuration: 3.0 / 60.0),
            SKAction.removeFromParent()
            ])
        
        // 2
        let soundAction = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        
        // 3
        bullet.run(SKAction.group([bulletAction, soundAction]))
        
        // 4
       
        gameBG.addChild(bullet)
    }
    
    
    
    
  

}
