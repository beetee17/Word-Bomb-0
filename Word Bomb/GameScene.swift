//
//  GameScene.swift
//  Word Bomb
//
//  Created by Brandon Thio on 28/6/21.
//  Copyright © 2021 Brandon Thio. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, UITextFieldDelegate {
    
    let replayButton = addRestartButton()
    let num_players = 2
    var players:[Player] = []
    var curr_player = Player(id_:0)
    
    let topBar = TopBar()
    
    let stopwatchLabel = addStopwatchLabel()
    let currPlayerLabel = addPlayerLabel()
    
    var timeLeft = 10
    var stopwatch:SKAction!
    
    var start = true
    var dictionary = Set<String>()
    var usedWords = Set<String>()
    
    
    let (queryText, inputField) = setUpInput()
    
    
    override func didMove(to view: SKView)  {
    
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        cameraNode.zPosition = 1

        addChild(cameraNode)
        self.camera = cameraNode


        self.view?.isUserInteractionEnabled = true
        self.view?.isMultipleTouchEnabled = true
        
        self.stopwatch = getStopwatch()

        self.camera?.addChild(stopwatchLabel)
        self.camera?.addChild(currPlayerLabel)
        self.camera?.addChild(topBar)
        self.camera?.addChild(replayButton)
        
        
        self.camera?.addChild(self.queryText)
        self.view?.addSubview(self.inputField)
        
        self.inputField.delegate = self
        self.inputField.becomeFirstResponder()
        
        do {
            let path = Bundle.main.path(forResource: "countries", ofType: "txt")
            let string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            self.dictionary = Set(string.components(separatedBy: "\n"))
        }
            
        catch let error {
            Swift.print("Fatal Error: \(error.localizedDescription)")
        }
        
        
        for id_ in 0...self.num_players-1 {
            self.players.append(Player(id_: id_))
        }
        
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if self.start {
            
            // User has started game, start stopwatch
            
            self.run(self.stopwatch, withKey: "stopwatch")
            self.timeLeft = 10
            self.curr_player = self.players[0]
            updatePlayerLabel()
            
            self.start = false
            
        }
        
        
        if self.timeLeft == 0 {
            print( "\(Int(self.curr_player.id_+1)) LOSES")
            self.timeLeft = 10
            gameOver()
        }
        
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // called when text field resigns first responder status
        print("ended")
        let input = textField.text!.lowercased()
        print(textField.text!)

        // Check if input is an answer
        if self.dictionary.contains(input) {
            print("CORRECT")
            self.curr_player = nextPlayer(curr_player: self.curr_player, players: self.players)
            self.dictionary.remove(input)
            self.usedWords.insert(input)
            updatePlayerLabel()
            self.timeLeft = 10
        }

        else {
            
            if self.usedWords.contains(input) {
                print("WRONG - ALREADY USED!")
            }
                
            else {

            print("WRONG - NOT A COUNTRY")
                
            }
            
        }
    
        
        textField.becomeFirstResponder()

    }

      
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Hides the keyboard

        textField.resignFirstResponder()

        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("started")
        textField.text = ""

    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let touchCount = touches.count
            
        if touchCount > 0 {
            
            if let touch = touches.first {
                
                let touchLocation = touch.location(in: self)
                
                let nodesTouched = self.nodes(at: touchLocation)
                
                if nodesTouched.count == 0  {

                    //Hides the keyboard if a blank space is touched
                    
                    self.inputField.resignFirstResponder()
                        
                    }
                for node in nodesTouched {
                
                    let nodeName = node.name
                    
                    if nodeName == "Restart Button" {
                        print("restarting")
                        // User has touched restart button -> restart a new game
                        restartGame()
                        
                        }
                    }
                }
            }
        }
    
    func getStopwatch() -> SKAction {
        
        let SKwait = SKAction.wait(forDuration: 1)
        let SKrun = SKAction.run(
        {
            self.timeLeft -= 1
            self.stopwatchLabel.text = "\(Int(self.timeLeft))"
        }
        )
        
        return SKAction.repeatForever(SKAction.sequence([SKwait, SKrun]))
        
    }
    
    func updatePlayerLabel() {
        self.currPlayerLabel.text = "Player \(Int(self.curr_player.id_+1))'s Turn!"
    }
    
    func gameOver() {
        
        self.removeAction(forKey:"stopwatch")
        self.start = false
        
    }
    
    func restartGame() {
        self.dictionary = self.usedWords.union(self.dictionary)
        self.usedWords = Set<String>()
        self.start = true
        
    }
    
}


// MARK: - UTILITY FUNCTIONS

func nextPlayer(curr_player:Player, players:[Player]) -> Player {
    
    if curr_player.id_ == players.count-1 {
        return players[0]
    }
    else {
        return players[curr_player.id_+1]
    }
}

func addPlayerLabel() -> SKLabelNode {
    let label = SKLabelNode(fontNamed: "Avenir-Medium")
    
    label.isHidden = false
    label.fontColor = UIColor.white
    label.fontSize = UIScreen.main.bounds.size.width/3
    label.verticalAlignmentMode = .center
    label.position = CGPoint(x: 0, y: UIScreen.main.bounds.size.height)
    label.text = ""
    label.zPosition = 5
    
    return label
}

func addStopwatchLabel() -> SKLabelNode {
    
    let label = SKLabelNode(fontNamed: "Avenir-Medium")
    
    label.isHidden = false
    label.fontColor = UIColor.red
    label.fontSize = UIScreen.main.bounds.size.width/3
    label.verticalAlignmentMode = .center
    label.position = CGPoint(x: 0, y: UIScreen.main.bounds.size.height*1.6)
    label.text = "10"
    label.zPosition = 5
    
    return label
    
}

func addRestartButton() -> SKSpriteNode{
    
    let replayButton = RestartButton()
    
    replayButton.texture = SKTexture(imageNamed: "Replay")
    replayButton.size = CGSize(width: UIScreen.main.bounds.size.width*0.5, height: UIScreen.main.bounds.size.width*0.5)
    //Top Right
    replayButton.position = CGPoint(x: UIScreen.main.bounds.size.width*1.5, y: UIScreen.main.bounds.size.height*1.6)
    replayButton.color = UIColor.green
    
    
    return replayButton
}

func setUpInput() -> (SKLabelNode, UITextField) {
        
            
        let queryText = SKLabelNode(fontNamed: "Avenir-Medium")

        queryText.isHidden = false
        queryText.fontColor = UIColor.white
        queryText.fontName = "Futura"
        queryText.fontSize = UIScreen.main.bounds.size.width/4
        queryText.position = CGPoint(x: 0, y: UIScreen.main.bounds.size.height/2)
        queryText.verticalAlignmentMode = .center
        queryText.zPosition = 2
        queryText.text = "Name a Country!"
        
        let inputPos = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/1.8)
        let fieldWidth = CGFloat(250)
        let fieldHeight = CGFloat(50)
        let inputField = UITextField(frame: CGRect(x: inputPos.x - fieldWidth/2, y: inputPos.y - fieldHeight/2, width: fieldWidth, height: fieldHeight))
    
        inputField.text = ""
        inputField.font = UIFont(name: "Futura", size: UIScreen.main.bounds.size.width/16)
        inputField.backgroundColor = .white
        inputField.textColor = .black
        inputField.textAlignment = .center
        inputField.clearButtonMode = .whileEditing
        inputField.clearsOnBeginEditing = true
        inputField.borderStyle = .roundedRect


        return (queryText, inputField)
            
        }



