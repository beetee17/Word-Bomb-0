//
//  GameViewController.swift
//  Word Bomb
//
//  Created by Brandon Thio on 28/6/21.
//  Copyright © 2021 Brandon Thio. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


final class GameViewController: UIViewController {
    
    
    override func viewDidLoad() {
        
        Constants.fontSize.small = UIScreen.main.bounds.width/16
        Constants.fontSize.med = UIScreen.main.bounds.width/12
        Constants.fontSize.large = UIScreen.main.bounds.width/10
        
        super.viewDidLoad()
        
        
        if let view = self.view as! SKView? {
            
            let scene = MainScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
                
            // Present the scene
            view.presentScene(scene)
            
            // set view settings
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.isUserInteractionEnabled = true
            view.isMultipleTouchEnabled = true
            
        }
        
        
        
    }


}
