//
//  Invader.swift
//  TowerDefencePepula
//
//  Created by Lauri Roomere on 27/01/2019.
//  Copyright © 2019 Lauri Roomere. All rights reserved.
//

import Foundation
import SpriteKit


class Invader:NSObject{
    
   var scene: GameScene!
   let kInvaderCategory: UInt32 = 0x1 << 0
   let kShipFiredBulletCategory: UInt32 = 0x1 << 1
   let kInvaderFiredBulletCategory: UInt32 = 0x1 << 4
   let kTowerFiredBulletName = "towerFiredBullet"
   let kInvaderFiredBulletName = "invaderFiredBullet"
   var lastFired:TimeInterval = 0.0
   var fullRoadPath=[CGPoint]()
   var gameBG: SKShapeNode!
   var invadersArray:[SKNode]=[]
    
  init(scene:GameScene,roadPath:inout Array<CGPoint>,gameBoard:SKShapeNode,invadersArrayIn:inout Array<SKNode>){
        self.scene=scene
        self.fullRoadPath=roadPath
        self.gameBG=gameBoard
        self.invadersArray=invadersArrayIn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    public func loadInvaders()->[SKNode]{
        
       
        return self.invadersArray
    }
    
    
    public func loadInvadersToScene()->[SKNode]{
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
        
        for invader in invadersArray{
            
            perform(#selector(moveInvaders), with:invader, afterDelay: 3)
        }
        
        return invadersArray;
        
        
    }
    
    @objc public func moveInvaders(invader:SKNode){
        //https://www.raywenderlich.com/2250-how-to-make-a-line-drawing-game-with-sprite-kit-and-swift
        
        var lastPath = CGPoint()
        
        var actionSequence:[SKAction]=[]
        //Wait for first waypoiint to be traveled through then add next line to travel, and then next. You have to wait
        
        
        
        for point in fullRoadPath{
            
            if(lastPath.x==0 && lastPath.y==0){
                let path = UIBezierPath()
                
                path.move(to:(invader.position))
                path.addLine(to:point)
                lastPath=point
                let followLine = SKAction.follow(path.cgPath, asOffset: false, orientToPath:true, speed: 50.0)
                actionSequence.append(followLine)
                let shape = SKShapeNode()
                shape.path = path.cgPath
                shape.strokeColor = UIColor.white
                shape.lineWidth = 4
                gameBG.addChild(shape)
                
            }else{
                let path = UIBezierPath()
                path.move(to:lastPath)
                path.addLine(to: point)
                lastPath=point
                let followLine = SKAction.follow(path.cgPath, asOffset: false, orientToPath:true, speed: 50.0)
                actionSequence.append(followLine)
                let shape = SKShapeNode()
                shape.path = path.cgPath
                shape.strokeColor = UIColor.white
                shape.lineWidth = 4
                gameBG.addChild(shape)
            }
            
            
        }
        
        
        
        //https://www.hackingwithswift.com/read/14/4/whack-to-win-skaction-sequences
        
        invader.run(SKAction.sequence(actionSequence))
        
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
    
    
    
    
    
}
