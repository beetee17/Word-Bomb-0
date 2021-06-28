//
//  Player.swift
//  Word Bomb
//
//  Created by Brandon Thio on 28/6/21.
//  Copyright © 2021 Brandon Thio. All rights reserved.
//

import Foundation

class Player {
    
    var id_:Int!
    var score:Int!
    var name:String!
    
    init(id_:Int) {
        self.id_ = id_
        self.score = 0
        self.name = "Player \(Int(self.id_+1))"
    }
    
    func increment_score() {
        self.score += 1
    }
    
    func reset() {
        self.score = 0
    }
    
    func setName(name:String) {
        self.name = name
    }
}
