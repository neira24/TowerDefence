//
//  GameScene.swift
//  TowerDefencePepula
//
//  Created by Lauri Roomere on 15/01/2019.
//  Copyright © 2019 Lauri Roomere. All rights reserved.
//
/*
 HP=100 10*2*10/2
 HP = (ATK1×FRQ1×ELP1/Speed) + (ATK2×FRQ2×ELP2/Speed) +··· (4.1) KILL ENEMY
HP stands for the health of that enemy, ATK stands for a tower’s power, FRQ stands for a tower’s attack frequency, and ELP stands for the effective length of the road. From formula 1, it is easy to transform and get:

HP ×Speed=FRQ1×ATK1×ELP1+FRQ2×ATK2×ELP2+···
 
 Introducing a variable SE to stand for the strength of an enemy and a variable ST to stands for the strength of a tower, we get:
 For an enemy:
 For a tower:
 SE = HP × Speed
 
 For a tower:
  ST =FRQ×ATK×ELP ≈FRQ×ATK×Radius× sqroot(2)
 
 
 Assuming a large number of enemies are spawned at the same time, if they belong
 to the same type, then the difficulty of the game can be expressed as:
 Difficulty=SE× (Num− (Life/ Harm))
 
 
 Therefore, in order to survive, a player should be given a chance to satisfy:
 Difficulty < ST1+ST2+ST3+···
 
 Cost1 + Cost2 + Cost3 + · · · ≤ Money
Game structure architecture
 https://www.oreilly.com/library/view/ios-swift-game/9781491920794/ch01.html
 */
import SpriteKit
import GameplayKit

enum SquareType{
    case Empty
    case Road
    case Tower
    case Enemy
    case Destroyed
}


enum TowerType{
    case Cannon
    case Tower
    case Castle
    case Fort
    case SAM
    case Destroyed
    case Empty
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


class Tower {
    
    var health = 100
    var type=TowerType.self
    var power=100
    var attackTime=1.0 as Double
    var attackArea=2
    var cost=1000
    var nextAttack:TimeInterval=0.0
    
    public init(type:TowerType){
        
        
        if(type==TowerType.Cannon){
            attackArea=2
            health=100
            power=20
            attackTime=1
            cost=200
            nextAttack=0.0
            
        }
        if(type==TowerType.Tower){
            attackArea=2
            health=100
            power=20
            attackTime=1
            cost=200
            nextAttack=0.0
        }
        if(type==TowerType.Castle){
            attackArea=2
            health=100
            power=20
            attackTime=1
            cost=200
            nextAttack=0.0
            
        }
        if(type==TowerType.Fort){
            attackArea=2
            health=100
            power=20
            attackTime=1
            cost=200
            nextAttack=0.0
            
        }
        if(type==TowerType.SAM){
            attackArea=2
            health=100
            power=20
            attackTime=1
            cost=200
            nextAttack=0.0
            
        }
        
        
    }
    
    
    
    
}


//create struct or class for health and other stuff.
//https://www.freesoundeffects.com/free-sounds/cannon-10077/

class GameScene: SKScene,SKPhysicsContactDelegate{
    var timePerMove: CFTimeInterval = 1.0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var gameLogo: SKLabelNode!
    var bestScore: SKLabelNode!
    var playButton: SKShapeNode!
    var game:GameManager!
    var road:Road!
    var invaders:Invader!
    var towers:Towers!
    var currentScore: SKLabelNode!
    var gameBG: SKShapeNode!
    var invadersArray:[SKNode]=[]
    var towersInUseArray:[(node:SKShapeNode, x:Int,y:Int,towerType:TowerType,sqType: SquareType,health:Int?,towerTop:SKSpriteNode?,nextAttack:TimeInterval?)]=[]
    var gameArray: [(node:SKShapeNode, x:Int,y:Int,towerType:TowerType,sqType: SquareType,health:Int?,towerTop:SKSpriteNode?)]=[]
    let kTowerFiredBulletName = "towerFiredBullet"
    let kInvaderFiredBulletName = "invaderFiredBullet"
    let kBulletSize = CGSize(width:4, height: 8)
    var contactQueue = [SKPhysicsContact]()
    var endOfRoad:(Int,Int)=(0,0)
    var fullRoadPath=[CGPoint]()
    let kInvaderCategory: UInt32 = 0x1 << 0
    let kShipFiredBulletCategory: UInt32 = 0x1 << 1
    let kShipCategory: UInt32 = 0x1 << 2
    let kSceneEdgeCategory: UInt32 = 0x1 << 3
    let kInvaderFiredBulletCategory: UInt32 = 0x1 << 4
    var lastFired:TimeInterval = 0.0
    
    
    override func didMove(to view: SKView) {
       
        // Get label node from scene and store it for use later
       physicsWorld.contactDelegate = self
       initializeMenu()
       game=GameManager(scene:self)
       initializeGameView()
       road=Road()
       towers=Towers.init(scene: self, gameBG: self.gameBG)
     
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
        
        
        //Store node names in data structure
        //Generalize the collision detection for tower types
        //Refactor Collision part, separate into different class or parts, make it more readable
        //Refactor other game logic, make a nice how to for your self, to structure the project
        if contact.bodyA.node?.name=="Tower" && contact.bodyB.node?.name == kInvaderFiredBulletName{
       
            var health:Int
            let index=gameArray.firstIndex { (item) -> Bool in

                return item.node == (contact.bodyA.node)
            }
            
            health=gameArray[index!].health!
            health=health-30
            gameArray.remove(at: index!)
            gameArray.insert((gameArray[index!].node,gameArray[index!].x,gameArray[index!].y,gameArray[index!].towerType,gameArray[index!].sqType,health,gameArray[index!].towerTop), at: index!)
            
        }
      /*  if contact.bodyA.node?.name=="Castle" && contact.bodyB.node?.name == kInvaderFiredBulletName{
            
            
        }*/
        
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

    //REFAAAACTOR PLS
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        game.update(time: currentTime)
        
        for tower in towersInUseArray{
           
                                    let bullet = Bullet.init().makeBullet(ofType: .towerFired)
                                    bullet.position=CGPoint(
                                        x:tower.towerTop!.position.x,
                                        y:tower.towerTop!.position.y+tower.towerTop!.frame.height-bullet.frame.size.height / 2
                                    )
            
                                    let bulletDestination=CGPoint(
                                        x:invadersArray.last?.position.x ?? tower.node.position.x,
                                        y:invadersArray.last?.position.y ?? frame.size.height+bullet.frame.size.height/2
            
            
                                    )
            if(invadersArray.count>0){
                let angle = atan2(tower.node.position.y - (invadersArray.last?.position.y)!,tower.node.position.x - (invadersArray.last?.position.x)!)
                //rotate tower
                //SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
                //vaata yle
                
                tower.towerTop!.zRotation=angle+CGFloat(.pi*0.5)
                let tower2 = Tower(type:tower.towerType)
              
                if(currentTime>tower.nextAttack!){
                  
                    towers.fireBullet(bullet: bullet, toDestination: bulletDestination, withDuration:tower2.attackTime, andSoundFileName: "Cannon+2.wav")
                
                    
                        
                        let index=towersInUseArray.firstIndex { (item) -> Bool in
                            
                            return item.node==tower.node
                        }
                    towersInUseArray.remove(at:index!)
                    towersInUseArray.append((node:tower
                        .node, x: tower
                            .x, y: tower
                                .y, towerType: tower
                                    .towerType, sqType: tower
                                        .sqType, health: tower
                                            .health, towerTop: tower
.towerTop, nextAttack: currentTime+5))
                   
                }
                
            }
            
            
            
            
         

            
        }
        
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
            
            if((towers) != nil){
                    towers.createUpgradeTower(gameArray: &gameArray, location: location, towersInUserArray: &towersInUseArray)
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
            
            self.road.createRoad(gameArray: &self.gameArray, fullRoadPath: &self.fullRoadPath, endOfRoad: &self.endOfRoad)
            
            self.invaders=Invader.init(scene:self,roadPath:&self.fullRoadPath,gameBoard:self.gameBG,invadersArrayIn:&self.invadersArray)
            self.invadersArray=self.invaders.loadInvadersToScene()
            
        }
        
       
        
        //perform(#selector(loadInvadersToScene), with: nil, afterDelay: 3)
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
        let numCols=9
        var x=CGFloat(width / -2)+(cellWidth / 2)
        var y=CGFloat(height / 2)-(cellWidth / 2)
        for i in 0...numRows-1{
            for j in 0...numCols-1{
                
                let cellNode=SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                cellNode.strokeColor=SKColor.black
                cellNode.zPosition=2
                cellNode.position=CGPoint(x: x, y: y)
                cellNode.name="Empty"
                
                let cellPos:SKLabelNode!
                cellPos=SKLabelNode(fontNamed: "ArialRoundedMTBold")
                cellPos.position=CGPoint(x:x, y:y)
                cellPos.fontSize=20
                cellPos.text=String(format: "(%i;%i)",i,j)
                cellPos.fontColor=SKColor.red
                gameBG.addChild(cellPos)
              
                
                
                gameArray.append((node:cellNode , x: i, y: j,towerType:TowerType.Tower, sqType:SquareType.Empty,health:100,nil))
                self.addChild(cellNode)
               
               
                x+=cellWidth
                
                
            }
            x=CGFloat(width / -2)+(cellWidth / 2)
            y-=cellWidth
            
            
            
        }
        
      
        
    }
    /*
 
     ------
  tank-----
 */
  
    
    
    
  

}
