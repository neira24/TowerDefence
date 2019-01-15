//
//  GameScene.swift
//  TowerDefencePepula
//
//  Created by Lauri Roomere on 15/01/2019.
//  Copyright © 2019 Lauri Roomere. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var gameLogo: SKLabelNode!
    var bestScore: SKLabelNode!
    var playButton: SKShapeNode!
    var game:GameManager!
    var currentScore: SKLabelNode!
    var gameBG: SKShapeNode!
    var gameArray: [(node:SKShapeNode, x:Int,y:Int)]=[]
    
    override func didMove(to view: SKView) {
       
        // Get label node from scene and store it for use later
       initializeMenu()
       game=GameManager(scene:self)
       initializeGameView()
     
    }
    
    
    
    
    
   /* func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }*/
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        game.update(time:currentTime)
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
    override func touchesBegan(_ touches: Set<UITouch>, with event:UIEvent?){
        
        for touch in touches{
            
            let location=touch.location(in: self)
            let touchedNode=self.nodes(at:location)
            for node in touchedNode{
                if node.name=="play_button"{
                    startGame()
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
        gameBG.zPosition=2
        gameBG.isHidden=true
        self.addChild(gameBG)
        createGameBoard(width:Int(width),height:Int(heigt))
        
        
        
        
    }
    
    private func createGameBoard(width: Int,height: Int){
        
        let cellWidth: CGFloat=27.5
        let numRows=40
        let numCols=20
        var x=CGFloat(width / -2)+(cellWidth / 2)
        var y=CGFloat(height / 2)-(cellWidth / 2)
        for i in 0...numRows-1{
            for j in 0...numCols-1{
                let cellNode=SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                cellNode.strokeColor=SKColor.black
                cellNode.zPosition=2
                cellNode.position=CGPoint(x: x, y: y)
                gameArray.append((node:cellNode , x: i, y: j))
                gameBG.addChild(cellNode)
                x+=cellWidth
                
                
            }
            x=CGFloat(width / -2)+(cellWidth / 2)
            y-=cellWidth
            
            
            
        }
        
        
        
    }
    
}
