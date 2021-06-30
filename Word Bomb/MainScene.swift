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

final class MainScene: SKScene {
    
    
    override func didMove(to view: SKView)  {
        
        addPassPlay()
        
        // load datasets
        
        do {
            var path = Bundle.main.path(forResource: "countries", ofType: "txt")
            var string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)

            Constants.data["countries"] = string.components(separatedBy: "\n")
            
            path = Bundle.main.path(forResource: "words", ofType: "txt")
            string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)

            Constants.data["words"] = string.components(separatedBy: "\n")
            
            path = Bundle.main.path(forResource: "syllables", ofType: "txt")
            string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            
            Constants.queries["words"] = string.components(separatedBy: "\n")

            
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
            
            let scene = ModeSelectScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                       
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
            
                let transition = SKTransition.fade(withDuration: 0.5)

                // Present the scene
                view.presentScene(scene, transition:transition)

        }
        
    }
    
    // MARK: - viewDidLoad functions
    func addPassPlay() {

        
        let buttonSize = CGSize(width: UIScreen.main.bounds.size.width/2, height: UIScreen.main.bounds.size.height/15)
        
        let passPlayButton = SKSpriteNode()
        passPlayButton.size = buttonSize
        passPlayButton.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        passPlayButton.color = UIColor.yellow
        passPlayButton.name = "Pass & Play"
        
        let passPlayText = SKLabelNode(fontNamed: Constants.fontName)

        passPlayText.isHidden = false
        passPlayText.fontColor = UIColor.black
        passPlayText.fontSize = Constants.fontSize.med!
        passPlayText.position = passPlayButton.position
        passPlayText.verticalAlignmentMode = .center
        passPlayText.zPosition = 2
        passPlayText.text = "Pass & Play!"

        addChild(passPlayButton)
        addChild(passPlayText)
    }
}




