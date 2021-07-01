//
//  ModeSelectScene.swift
//  Word Bomb
//
//  Created by Brandon Thio on 29/6/21.
//  Copyright © 2021 Brandon Thio. All rights reserved.
//

import Foundation
import SpriteKit
//import GameplayKit


final class ModeSelectScene: SKScene {
    
    override func didMove(to view: SKView)  {
        
        addModes()
        
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

            let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            
            scene.mode = mode
            scene.words = Constants.data[mode]!
                   
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            let transition = SKTransition.fade(withDuration: 1.5)

            // Present the scene
            view.presentScene(scene, transition:transition)

        }
    }
    
    // MARK: - viewDidLoad functions
    func addModes() {
        
        let buttonSize = CGSize(width: UIScreen.main.bounds.size.width/2, height: UIScreen.main.bounds.size.height/15)
        let modes = Constants.modes
            
        for i in 0..<modes.count {
            
            let modeButton = SKSpriteNode()
            modeButton.size = buttonSize
            modeButton.position = CGPoint(x:UIScreen.main.bounds.size.width/2, y:UIScreen.main.bounds.size.height/2-((buttonSize.height+CGFloat(50))*CGFloat(i)))
            modeButton.zPosition = 2
            modeButton.color = UIColor.yellow
            modeButton.name = "\(modes[i])"
            
            let modeText = SKLabelNode(fontNamed: Constants.fontName)
            modeText.isHidden = false
            modeText.fontColor = UIColor.black
            modeText.fontSize = Constants.fontSize.med!
            modeText.position = modeButton.position
            modeText.verticalAlignmentMode = .center
            modeText.zPosition = 3
            modeText.text = "\(modes[i])"
            modeText.name = "\(modes[i])"
            
            addChild(modeButton)
            addChild(modeText)

        }
        

    }
}



