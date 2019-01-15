//
//  GameManager.swift
//  TowerDefencePepula
//
//  Created by Lauri Roomere on 15/01/2019.
//  Copyright © 2019 Lauri Roomere. All rights reserved.
//

import Foundation
import SpriteKit


class GameManager{
    var nextTime: Double?
    var scene: GameScene!
    var timeExtension: Double=1
    
    
    init(scene:GameScene){
        self.scene=scene;
        
    }
    
    func initGame(){
        
        
        renderChange()
        
    }
    
    
    func renderChange(){
        
        
    }
    
    
    func contains(a:[(Int,Int)], v:(Int,Int))->Bool{
        let(c1,c2)=v
        for (v1,v2) in a { if v1==c1 && v2==c2 {return true}}
        return false
        
        
    }
    
    func update(time: Double){
        
        if(nextTime==nil){
            
            nextTime=time+timeExtension
            
        }else{
            if time>=nextTime!{
                
                nextTime=time+timeExtension
                print(time)
            }
            
        }
        
        
    }
    
    
}
