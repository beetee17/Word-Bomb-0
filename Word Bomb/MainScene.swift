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

class MainScene: SKScene {
    
    let (passPlayButton, passPlayText) = addPassPlay()
    var data:[String:[String]] = [:]
    var queries:[String:[String]] = [:]
    
    override func didMove(to view: SKView)  {
        
        let camera = SKCameraNode()
        camera.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        camera.zPosition = 1
        addChild(camera)
        
        camera.addChild(self.passPlayButton)
        camera.addChild(self.passPlayText)
   
        if let view = self.view as SKView? {
            view.isUserInteractionEnabled = true
            view.isMultipleTouchEnabled = true
        }
        
        
        // load datasets
        
        do {
            var path = Bundle.main.path(forResource: "countries", ofType: "txt")
            var string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)

            data["countries"] = string.components(separatedBy: "\n")
            
            path = Bundle.main.path(forResource: "words", ofType: "txt")
            string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)

            data["words"] = string.components(separatedBy: "\n")
            
            path = Bundle.main.path(forResource: "syllables", ofType: "txt")
            string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            
            queries["words"] = string.components(separatedBy: "\n")

            
        }
            
        catch let error {
            Swift.print("Fatal Error: \(error.localizedDescription)")
        }
               
        
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
                        presentModeSelect()
                        
                        }
                    }
                }
            }
        }
    func presentModeSelect() {
        
        if let view = self.view as SKView? {
            
            let scene = ModeSelectScene(size: CGSize(width: view.bounds.width*4, height: view.bounds.height*4))
                       
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.data = data
                scene.queries = queries
            
                let transition = SKTransition.fade(withDuration: 0.5)

                // Present the scene
                view.presentScene(scene, transition:transition)

        }
        
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
