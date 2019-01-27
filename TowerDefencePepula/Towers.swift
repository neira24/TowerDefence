//
//  Towers.swift
//  TowerDefencePepula
//
//  Created by Lauri Roomere on 27/01/2019.
//  Copyright © 2019 Lauri Roomere. All rights reserved.
//

import Foundation
import SpriteKit

class Towers{
    var scene: GameScene!
    var gameBG:SKShapeNode!
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
    
    init(scene:GameScene,gameBG:SKShapeNode){
        
        self.scene=scene
        self.gameBG=gameBG
        
    }
    
    public func createUpgradeTower(gameArray:inout Array<(node:SKShapeNode, x:Int,y:Int,towerType:TowerType,sqType: SquareType,health:Int?,towerTop:SKSpriteNode?)>,location:CGPoint,towersInUserArray:inout Array<(node:SKShapeNode, x:Int,y:Int,towerType:TowerType,sqType: SquareType,health:Int?,towerTop:SKSpriteNode?,nextAttack:TimeInterval?)>){
        
        
        for (node,x,y,typeTower,typeSquare,health,towerTOP) in gameArray{
            
            let index=gameArray.firstIndex { (item) -> Bool in
                
                return item.node==node
            }
            
            
            
            
            
            
            
            if(node.contains(location) && gameArray[index!].sqType != SquareType.Road){
                if(typeTower==TowerType.Tower){
                    node.fillColor=SKColor.white
                    gameArray.remove(at: index!)
                    node.name="Tower"
                    
                    let invaderTextures = loadTowerTextures(ofType: typeTower)
                    
                    // 2
                    node.fillTexture = invaderTextures[1]
                    
                    
                    // let invader = SKSpriteNode(texture: invaderTextures[0])
                    node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.frame.width, height: node.frame.height))
                    node.physicsBody!.isDynamic=false
                    node.physicsBody!.categoryBitMask=kShipCategory
                    node.physicsBody!.contactTestBitMask=kShipFiredBulletCategory
                    node.physicsBody!.collisionBitMask=0
                    
                    let weaponType = SKShapeNode()
                    
                    let texture=SKTexture(imageNamed: "Cannon_00.png")
                    let invader = SKSpriteNode(texture: texture)
                    invader.name = InvaderType.name
                    invader.userData=NSMutableDictionary()
                    invader.position=CGPoint(x:node.position.x, y: node.position.y)
                    invader.scale(to: CGSize(width: node.frame.width/1.2, height: node.frame.width/1.2))
                    
                    
                    gameBG.addChild(invader)
                    
                    
                    gameArray.insert((node,x,y,TowerType.Castle,SquareType.Tower,health,invader), at: index!)
                    towersInUserArray.append((node,x,y,TowerType.Castle,SquareType.Tower,health,invader,0.0))
                    
                    
                    break
                    
                    
                }
                
                if(typeTower==TowerType.Castle){
                    node.name="Castle"
                    
                    let invaderTextures = loadTowerTextures(ofType: typeTower)
                    node.fillTexture = invaderTextures[0]
  
                    
                }
                /* if(sq==TowerType.Tower){
                 node.fillColor=SKColor.red
                 gameArray.remove(at: index!)
                 gameArray.insert((node,x,y,TowerType.Tower,health), at: index!)
                 break
                 }*/
                
            }
            
            
            
        }
        
        
        
        
    }
    
    
    
    
    func loadTowerTextures(ofType towerType: TowerType) -> [SKTexture] {
        
        var prefix: String
        
        switch(towerType) {
        case .Tower:
            prefix = "Tower"
        case .Castle:
            prefix = "Castle"
        case .Cannon:
            prefix = "Cannon"
        case .Destroyed:
            prefix="Destoryed"
        case .SAM:
            prefix = "SAM"
        case .Fort:
            prefix = "Fort"
        case .Empty:
            prefix = "Empty"
        }
        
        
        // 1
        return [SKTexture(imageNamed: String(format: "%@_00.png", prefix)),
                SKTexture(imageNamed: String(format: "%@_01.png", prefix))]
    }
    
    
    
    
   public func fireBullet(bullet: SKNode, toDestination destination: CGPoint, withDuration duration: CFTimeInterval, andSoundFileName soundName: String) {
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
