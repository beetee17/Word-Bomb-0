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


class GameViewController: UIViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        if let view = self.view as! SKView? {
            
            let scene = MainScreen(size: CGSize(width: view.bounds.width * 4, height: view.bounds.height*4))
            
            // Set the scale mode to scale to fit the window
 
            scene.scaleMode = .aspectFill
                
            // Present the scene
            view.presentScene(scene)

            view.showsFPS = true
            
        }
    }


}
