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
    static var usedWords = Set<Int>() 
    
    static var timeLimit:Double = 10.0
    
    struct fontSize {
        static var small:CGFloat?
        static var med:CGFloat?
        static var large:CGFloat?
    }
}

extension Array where Element: Comparable {
    
    func search(element: Element) -> Int {
        
        var low = 0
        var high = count - 1
        var mid = Int(high / 2)
        
        while low <= high {
            
            let midElement = self[mid]
            
            if element == midElement {
                return mid
            }
            else if element < midElement {
                high = mid - 1
            }
            else {
                low = mid + 1
            }
            
            mid = (low + high) / 2
        }
        
        return -1
    }
}
