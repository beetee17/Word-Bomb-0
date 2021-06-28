//
//  PassPlay.swift
//  Word Bomb
//
//  Created by Brandon Thio on 28/6/21.
//  Copyright © 2021 Brandon Thio. All rights reserved.
//

import Foundation
import SpriteKit

class PassPlay: SKSpriteNode {

    let buttonSize = CGSize(width: UIScreen.main.bounds.size.width*0.5, height: UIScreen.main.bounds.size.width*0.5)
    
    init() {
        
        super.init(texture: SKTexture(imageNamed: "Smiley"), color: UIColor.yellow, size: buttonSize)
        
        self.position = CGPoint(x: 0, y: UIScreen.main.bounds.size.height*1.6)
        self.name = "Restart Button"
        self.zPosition = 5
    }
        
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

