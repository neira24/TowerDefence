//
//  Road.swift
//  TowerDefencePepula
//
//  Created by Lauri Roomere on 27/01/2019.
//  Copyright © 2019 Lauri Roomere. All rights reserved.
//

import Foundation
import SpriteKit

class Road{
    
    
    public func createRoad(gameArray:inout Array<(node:SKShapeNode, x:Int,y:Int,towerType:TowerType,sqType: SquareType,health:Int?,towerTop:SKSpriteNode?)>,fullRoadPath:inout Array<CGPoint>,endOfRoad: inout (Int,Int)){
        //     https://medium.freecodecamp.org/how-to-make-your-own-procedural-dungeon-map-generator-using-the-random-walk-algorithm-e0085c8aa9a
        var dimensions=16 //grid width and height
        var dimensionRow=16
        var dimensionColumn=8
        var   maxNumOfPaths=16 //max number of different paths
        var   maxLength=8 //max length of one [][][] three squares
        var   currentRow=0 //Int(floor(Float.random(in: 0 ... 16)))
        var   currentColumn=Int(floor(Float.random(in: 1 ... 16)))
        let   directions = [(-1, 0), (1, 0), (0, -1), (0, 1)] //up,down,left,right
        var   lastDirection:(Int,Int) = (0,0)
        var  randomDirection: (Int,Int)
        
        while (dimensionColumn>0) && (dimensionRow>0) && (maxNumOfPaths>0) && (maxLength>0) {
            var isTrue:Bool
            
            repeat{
                
                randomDirection=directions[Int.random(in: 0 ... 3)]
                isTrue=false
                
                if (((randomDirection.0 == lastDirection.0 * -1) && (randomDirection.1 == lastDirection.1 * -1)) || ((randomDirection.0 == lastDirection.0) && (randomDirection.1 == lastDirection.1))){
                    isTrue=true
                }
                
            }while  isTrue == true; do {
                
                let randomLength = Int(ceil(Double.random(in: 10 ... 20)))
                var currentLength = 0
                
                
                for i in 0 ... randomLength {
                    
                    if (((currentRow == 0) && (randomDirection.0 == -1)) ||
                        ((currentColumn == 0) && (randomDirection.0 == -1)) ||
                        ((currentRow == dimensionRow - 1) && (randomDirection.0 == 1)) ||
                        ((currentColumn == dimensionColumn - 1) && (randomDirection.0 == 1))) {
                        break;
                        
                    }else{
                        
                        let index=gameArray.firstIndex { (item) -> Bool in
                            
                            return (item.x,item.y) == (currentRow,currentColumn)
                        }
                        if index != nil{
                            
                            gameArray[index!].node.fillColor=UIColor.white
                            gameArray[index!].node.fillTexture=loadRoadTexture()
                            
                            gameArray.remove(at: index!);
                        gameArray.insert((gameArray[index!].node,gameArray[index!].x,gameArray[index!].y,TowerType.Destroyed,SquareType.Road,gameArray[index!].health,nil), at: index!)
                            fullRoadPath.append(gameArray[index!].node.position)
                            
                        }
                        currentRow=currentRow + randomDirection.0
                        currentColumn=currentColumn + randomDirection.1
                        currentLength=currentLength + 1
                        endOfRoad=(currentRow,currentColumn)
                        
                    }
                    
                }
                if currentLength > 0{
                    
                    lastDirection = randomDirection
                    
                    maxNumOfPaths = maxNumOfPaths - 1
                    
                }
                
                
                
            }
            
        }
        
        print("Last direction %@ %@",endOfRoad.0 , endOfRoad.1)
        
    }
    
    
    private func loadRoadTexture()-> SKTexture{
        
        var prefix: String
        
        prefix=String(Int.random(in: 1 ... 8))
        
        
        // 1
        let imgName=String(format:"road_%@.png", prefix)
        return SKTexture(imageNamed:imgName)
    }
    
}
