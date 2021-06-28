//
//  MainScreen.swift
//  Word Bomb
//
//  Created by Brandon Thio on 28/6/21.
//  Copyright © 2021 Brandon Thio. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class MainScreen: SKScene {
    
    let (passPlayButton, passPlayText) = addPassPlay()
    
    
    override func didMove(to view: SKView)  {
        
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        cameraNode.zPosition = 1

        addChild(cameraNode)
        self.camera = cameraNode

        self.view?.isUserInteractionEnabled = true
        self.view?.isMultipleTouchEnabled = true
        self.camera?.addChild(self.passPlayButton)
        self.camera?.addChild(self.passPlayText)
               
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let touchCount = touches.count
            
        if touchCount > 0 {
            
            if let touch = touches.first {
                
                let touchLocation = touch.location(in: self)
                
                let nodesTouched = self.nodes(at: touchLocation)
                
                for node in nodesTouched {
                
                    let nodeName = node.name
                    
                    if nodeName == "Pass & Play" {
                        startGame()
                        
                        }
                    }
                }
            }
        }
    func startGame() {
        
        let scene = GameScene(size: CGSize(width: (self.view?.bounds.width)! * 4, height: (self.view?.bounds.height)!*4))
                   
       // Set the scale mode to scale to fit the window

       scene.scaleMode = .aspectFill
           
       // Present the scene
       self.view?.presentScene(scene)

       self.view?.showsFPS = true
        
    }
}



func addPassPlay() -> (SKSpriteNode, SKLabelNode) {

    
    let buttonSize = CGSize(width: UIScreen.main.bounds.size.width*1.5, height: UIScreen.main.bounds.size.width*0.5)
    
    let passPlayButton = SKSpriteNode()
    passPlayButton.size = buttonSize
    passPlayButton.position = CGPoint(x: 0, y: 0)
    passPlayButton.color = UIColor.yellow
    passPlayButton.name = "Pass & Play"
    
    let passPlayText = SKLabelNode(fontNamed: "Avenir-Medium")

    passPlayText.isHidden = false
    passPlayText.fontColor = UIColor.black
    passPlayText.fontName = "Futura"
    passPlayText.fontSize = UIScreen.main.bounds.size.width/4
    passPlayText.position = passPlayButton.position
    passPlayText.verticalAlignmentMode = .center
    passPlayText.zPosition = 2
    passPlayText.text = "Pass & Play!"


    return (passPlayButton, passPlayText)
}
