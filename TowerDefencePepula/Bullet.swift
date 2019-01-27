//
//  Bullet.swift
//  TowerDefencePepula
//
//  Created by Lauri Roomere on 27/01/2019.
//  Copyright © 2019 Lauri Roomere. All rights reserved.
//

import Foundation
import SpriteKit


class Bullet{
    
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
    
   public func makeBullet(ofType bulletType: BulletType) -> SKNode {
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
    
    
    
}
