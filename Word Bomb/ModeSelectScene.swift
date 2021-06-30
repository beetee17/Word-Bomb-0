//
//  ModeSelectScene.swift
//  Word Bomb
//
//  Created by Brandon Thio on 29/6/21.
//  Copyright © 2021 Brandon Thio. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

let MODES = ["WORDS", "COUNTRIES"]

class ModeSelectScene: SKScene {
    
    var data:[String:[String]] = [:]
    var queries:[String:[String]] = [:]
    
    override func didMove(to view: SKView)  {
        
        let camera = SKCameraNode()
        camera.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        camera.zPosition = 1

        addChild(camera)
        
        let modeButtonSize = CGSize(width: UIScreen.main.bounds.size.width*1.5, height: UIScreen.main.bounds.size.width*0.5)
        
        for i in 0..<MODES.count {

            let (modeButton, modeText) = addMode(modeName:MODES[i], size:modeButtonSize, pos:CGPoint(x:0, y:(CGFloat(400)*CGFloat(i))))
        
            camera.addChild(modeButton)
            camera.addChild(modeText)
    
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
                
                    if let mode = node.name as String? {
                        
                        startGame(mode:mode.lowercased())
                    }
                }
            }
        }
    }
    
    func startGame(mode:String) {
        
        if let view = self.view as SKView? {

            let scene = GameScene(size: CGSize(width: (view.bounds.width) * 4, height: (view.bounds.height)*4))
            
            scene.mode = mode
            
            scene.dictionary = Set(data[mode]!)
            
            if mode == "words" {
                scene.queries = Set(queries[mode]!)
            }
                   
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            let transition = SKTransition.fade(withDuration: 0.5)

            // Present the scene
            view.presentScene(scene, transition:transition)
            view.showsFPS = true
        }
    }
}



func addMode(modeName:String, size:CGSize, pos:CGPoint) -> (SKSpriteNode, SKLabelNode) {
    
    let modeButton = SKSpriteNode()
    modeButton.size = size
    modeButton.position = pos
    modeButton.zPosition = 2
    modeButton.color = UIColor.yellow
    modeButton.name = "\(modeName)"
    
    let modeText = SKLabelNode(fontNamed: "Avenir-Medium")

    modeText.isHidden = false
    modeText.fontColor = UIColor.black
    modeText.fontName = "Futura"
    modeText.fontSize = UIScreen.main.bounds.size.width/4
    modeText.position = modeButton.position
    modeText.verticalAlignmentMode = .center
    modeText.zPosition = 3
    modeText.text = "\(modeName)"
    modeText.name = "\(modeName)"


    return (modeButton, modeText)
}
