//
//  Constants.swift
//  Word Bomb
//
//  Created by Brandon Thio on 30/6/21.
//  Copyright © 2021 Brandon Thio. All rights reserved.
//

import Foundation
import SpriteKit

struct Constants {
    
    static var modes = ["WORDS", "COUNTRIES"]
    static var fontName = "Avenir-Medium"
    
    static var data:[String:[String]] = [:]
    static var queries:[String:[String]] = [:]
    static var usedWords = Set<String>() 
    
    static var timeLimit:Double = 10.0
    
    struct fontSize {
        static var small:CGFloat?
        static var med:CGFloat?
        static var large:CGFloat?
    }
}


