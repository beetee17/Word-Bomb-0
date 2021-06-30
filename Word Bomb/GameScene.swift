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
    
    var mode:String!
    
    let num_players = 2
    var players:[Player] = []
    var curr_player = Player(id_:0)
    
    let topBar = TopBar()
    let replayButton = addRestartButton()
    let stopwatchLabel = addStopwatchLabel()
    let currPlayerLabel = addPlayerLabel()
    let (queryText, inputField, outPutLabel) = addInputOutput()
    
    var timeLeft = 10
    var stopwatch:SKAction!
    
    var start = true
    var dictionary = Set<String>()
    var usedWords = Set<String>()
    
    var queries = Set<String>()
    var query:String?
    
    
    override func didMove(to view: SKView)  {
    
        let camera = SKCameraNode()
        
        camera.position = CGPoint(x: frame.midX, y: frame.midY)
        camera.zPosition = 1

        addChild(camera)

        stopwatch = getStopwatch()

        camera.addChild(stopwatchLabel)
        camera.addChild(currPlayerLabel)
        camera.addChild(topBar)
        camera.addChild(replayButton)
        
        camera.addChild(queryText)
        camera.addChild(outPutLabel)
        
        inputField.delegate = self
        inputField.becomeFirstResponder()
        
        if let view = self.view as SKView? {
            view.addSubview(inputField)
        }
        
        
        
        for id_ in 0...num_players-1 {
            players.append(Player(id_: id_))
        }
        
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if start {
            
            // User has started game, start stopwatch
            
            run(stopwatch, withKey: "stopwatch")
            timeLeft = 10
            curr_player = players[0]
            updatePlayerLabel()
            getRandQuery()
            
            start = false
            
        }
        
        
        if timeLeft == 0 {
            print( "\(Int(curr_player.id_+1)) LOSES")
            timeLeft = 10
            gameOver()
        }
        
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // called when text field resigns first responder status
        print("ended input")
        let input = textField.text!.lowercased()
        print(textField.text!)

        processInput(input:input)
    
        textField.becomeFirstResponder()

    }

      
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Hides the keyboard

        textField.resignFirstResponder()

        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("started input")
        textField.text = ""

    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let touchCount = touches.count
            
        if touchCount > 0 {
            
            if let touch = touches.first {
                
                let touchLocation = touch.location(in: self)
                
                let nodesTouched = nodes(at: touchLocation)
                
                if nodesTouched.count == 0  {

                    //Hides the keyboard if a blank space is touched
                    
                    inputField.resignFirstResponder()
                        
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
    
    func getRandQuery() {
        if queries.count > 0 {
            let q = queries.randomElement()!
            query = q
            queryText.text = "\(q.uppercased())"
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
    
    func updatePlayerLabel(gameOver:Bool = false) {
        if gameOver {
            currPlayerLabel.text = "\(curr_player.name!) Loses!"
        }
        else {
            currPlayerLabel.text = "\(curr_player.name!)'s Turn!"
        }
    }
    
    func processInput(input:String) {
        
        // make output visible again
        outPutLabel.isHidden = false
        
        if let q = query as String? {
            // if game mode involves query (eg must have syllable in word
            if input.contains(q) && dictionary.contains(input){
                is_correct(input:input)
                getRandQuery()
            }
            else {
                is_wrong(input:input)
            }
        }
            
        else {
            // Check if input is an answer
            if dictionary.contains(input) {
                is_correct(input:input)
            }
                
            else {
                is_wrong(input:input)
            }
        }
        
        // hide the output after some time
        
        let SKwait = SKAction.wait(forDuration: 2)
        let hideOutput = SKAction.run(
        {
            self.outPutLabel.isHidden = true
            }
        )
        
        run(SKAction.sequence([SKwait, hideOutput]))
        
        
        
        print(outPutLabel.text!)
    }
    
    func is_correct(input:String) {
        print("CORRECT")
        curr_player = nextPlayer(curr_player: curr_player, players: players)
        dictionary.remove(input)
        usedWords.insert(input)
        timeLeft = 10
        updatePlayerLabel()
        outPutLabel.fontColor = .green
        outPutLabel.text = "CORRECT!"
    }
    func is_wrong(input:String) {
        outPutLabel.fontColor = .red
        
        if usedWords.contains(input) {
            
            outPutLabel.text = "\(input) already used!"
            
        }
            
        else {
            
            outPutLabel.text = "\(input) is wrong!"
            
        }
    }
    func gameOver() {
        // stop the stopwatch and reset to first player
        removeAction(forKey:"stopwatch")
        updatePlayerLabel(gameOver:true)
        start = false
        
    }
    
    func restartGame() {
        // reset dictionary and used words
        dictionary = usedWords.union(dictionary)
        usedWords = Set<String>()
        start = true
        
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

func addInputOutput() -> (SKLabelNode, UITextField, SKLabelNode) {
        
            
    let queryText = SKLabelNode(fontNamed: "Avenir-Medium")

    queryText.isHidden = false
    queryText.fontColor = UIColor.white
    queryText.fontName = "Futura"
    queryText.fontSize = UIScreen.main.bounds.size.width/4
    queryText.position = CGPoint(x: 0, y: 50)
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
    
    let outputLabel = SKLabelNode(fontNamed: "Avenir-Medium")
    
    outputLabel.fontColor = UIColor.white
    outputLabel.fontSize = UIScreen.main.bounds.size.width/6
    outputLabel.verticalAlignmentMode = .center
    
    outputLabel.position = CGPoint(x: 0, y: queryText.position.y -  CGFloat(450))
    outputLabel.text = ""
    outputLabel.zPosition = 5


    return (queryText, inputField, outputLabel)
        
    }




