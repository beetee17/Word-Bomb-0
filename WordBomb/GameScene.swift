//
//  GameScene.swift
//  Word Bomb
//
//  Created by Brandon Thio on 28/6/21.
//  Copyright © 2021 Brandon Thio. All rights reserved.
//

import SpriteKit
//import GameplayKit

final class GameScene: SKScene, UITextFieldDelegate {
    
    var mode:String!
    
    let num_players = 2
    var players:[Player] = []
    var curr_player = Player(id_:0)

    var stopwatchLabel = SKLabelNode()
    var currPlayerLabel = SKLabelNode()
    var outputLabel = SKLabelNode()
    var inputField = UITextField()
    var queryText = SKLabelNode()
   
    
    var timeLeft = Constants.timeLimit
    var stopwatch:SKAction!
    
    var start = true
    var words:[String] = []
    var query:String?
    
    override func sceneDidLoad() {
        
        stopwatch = getStopwatch()

        addStopwatchLabel()
        addPlayerLabel()
        addTopBar()
        addReplayButton()
        
        for id_ in 0...num_players-1 {
            players.append(Player(id_: id_))
        }
    }
    override func didMove(to view: SKView)  {
    
            addInputOutput()
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if start {
            
            // User has started game, start stopwatch
            
            resetStopwatch()
            run(stopwatch, withKey: "stopwatch")

            curr_player = players[0]
            updatePlayerLabel()
            getRandQuery()
            
            start = false
            
        }
        
        
        if timeLeft <= 0 {
            print( "\(Int(curr_player.id_+1)) LOSES")
            resetStopwatch(time:0.0)
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
    
    func getRandQuery() {
        if Constants.queries[mode]?.count ?? -1 > 0 {
            query = Constants.queries[mode]?.randomElement()!
            self.queryText.text = "\(query!.uppercased())"
        }
    }
    
    // MARK: - Stopwatch Functions
    func getStopwatch() -> SKAction {
        
        let SKwait = SKAction.wait(forDuration: 0.1)
        let SKrun = SKAction.run(
        {
            self.timeLeft -= 0.1
            self.stopwatchLabel.text = String(format: "%.1f", (self.timeLeft))
  
        }
        )
        
        return SKAction.repeatForever(SKAction.sequence([SKwait, SKrun]))
        
    }
    
    func resetStopwatch(time:Double=Constants.timeLimit) {
        self.timeLeft = Constants.timeLimit
        self.stopwatchLabel.text = String(format:"%.1f", time)
    }
    
    
    // MARK: - User Input Processing
    func processInput(input:String) {
        
        // make output visible again
        self.outputLabel.isHidden = false
        let searchResult = words.search(element: input)
        
        if Constants.usedWords.contains(searchResult) {
            alreadyUsed(input:input)
        }
        else {
            
            if let q = query as String? {
                // if game mode involves query (eg must have syllable in word)
                if input.contains(q) && (searchResult != -1){
                    isCorrect(input:input, index:searchResult)
                    getRandQuery()
                }
                else {
                    isWrong(input:input)
                }
            }
                
            else {
                // Check if input is an answer
                if (searchResult != -1) {
                    isCorrect(input:input, index:searchResult)
                }
                    
                else {
                    isWrong(input:input)
                }
            }
        }
        
        // hide the output after some time
        
        let SKwait = SKAction.wait(forDuration: 2)
        let hideOutput = SKAction.run(
        {
            self.outputLabel.isHidden = true
            }
        )
        
        run(SKAction.sequence([SKwait, hideOutput]))
        
        
        
        print(outputLabel.text!)
    }
    
    func isCorrect(input:String, index:Int) {
        print("CORRECT")
        curr_player = nextPlayer(curr_player: curr_player, players: players)
        Constants.usedWords.insert(index)
        resetStopwatch()
        updatePlayerLabel()
        self.outputLabel.fontColor = .green
        self.outputLabel.text = "CORRECT!"
    }
    func isWrong(input:String) {
        
        self.outputLabel.fontColor = .red
        self.outputLabel.text = "\(input) is wrong!"
        
    }
    
    func alreadyUsed(input:String) {
        
        self.outputLabel.fontColor = .red
        self.outputLabel.text = "\(input) already used!"
        
    }
    
    // MARK: - Game Loop Functions
    
    func updatePlayerLabel(gameOver:Bool = false) {
        if gameOver {
            self.currPlayerLabel.text = "\(curr_player.name!) Loses!"
        }
        else {
            self.currPlayerLabel.text = "\(curr_player.name!)'s Turn!"
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
        Constants.usedWords = Set<Int>()
        start = true
        
    }
    
    // MARK: - viewDidLoad functions
    func addInputOutput() {
        
        let queryText = SKLabelNode(fontNamed: Constants.fontName)

        queryText.isHidden = false
        queryText.fontColor = UIColor.white
        queryText.fontName = "Futura"
        queryText.fontSize = Constants.fontSize.med!
        queryText.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        queryText.verticalAlignmentMode = .center
        queryText.zPosition = 2
        queryText.text = "Name a Country!"
        
        let inputPos = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/1.8)
        let fieldWidth = CGFloat(250)
        let fieldHeight = CGFloat(50)
        let inputField = UITextField(frame: CGRect(x: inputPos.x - fieldWidth/2, y: inputPos.y - fieldHeight/2, width: fieldWidth, height: fieldHeight))

        inputField.text = ""
        inputField.font = UIFont(name: Constants.fontName, size: UIScreen.main.bounds.size.width/12)
        inputField.backgroundColor = .white
        inputField.textColor = .black
        inputField.textAlignment = .center
        inputField.clearButtonMode = .whileEditing
        inputField.clearsOnBeginEditing = true
        inputField.borderStyle = .roundedRect
        
        let outputLabel = SKLabelNode(fontNamed: Constants.fontName)
        
        outputLabel.fontColor = UIColor.white
        outputLabel.fontSize = Constants.fontSize.small!
        outputLabel.verticalAlignmentMode = .center
        
        outputLabel.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: queryText.position.y -  CGFloat(100))
        outputLabel.text = ""
        outputLabel.zPosition = 5
        
        self.queryText = queryText
        self.inputField = inputField
        self.outputLabel = outputLabel
        
        if let view = self.view as SKView? {
            view.addSubview(self.inputField)
        }

        self.inputField.delegate = self
        self.inputField.becomeFirstResponder()
            
        addChild(self.queryText)
        addChild(self.outputLabel)
            
    }

    func addPlayerLabel() {
        let playerLabel = SKLabelNode(fontNamed: Constants.fontName)
        
        playerLabel.isHidden = false
        playerLabel.fontColor = UIColor.white
        playerLabel.fontSize = Constants.fontSize.med!
        playerLabel.verticalAlignmentMode = .center
        playerLabel.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height*0.7)
        playerLabel.text = ""
        playerLabel.zPosition = 5
        
        self.currPlayerLabel = playerLabel
        addChild(self.currPlayerLabel)
    }

    func addStopwatchLabel()  {
        
        let stopwatchLabel = SKLabelNode(fontNamed: Constants.fontName)
        
        stopwatchLabel.isHidden = false
        stopwatchLabel.fontColor = UIColor.red
        stopwatchLabel.fontSize = Constants.fontSize.med!
        stopwatchLabel.verticalAlignmentMode = .center
        stopwatchLabel.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height*0.9)
        stopwatchLabel.text = "\(Constants.timeLimit)"
        stopwatchLabel.zPosition = 5
        
        self.stopwatchLabel = stopwatchLabel
        
        addChild(self.stopwatchLabel)
        
    }
    func addReplayButton() {
        
        let replayButton = SKSpriteNode()

        replayButton.name = "Restart Button"
        //Top Right
        replayButton.position = CGPoint(x: UIScreen.main.bounds.size.width*0.8, y: UIScreen.main.bounds.size.height*0.9)
        replayButton.zPosition = 5
        
        replayButton.texture = SKTexture(imageNamed: "Replay")
        replayButton.size = CGSize(width: UIScreen.main.bounds.size.width*0.1, height: UIScreen.main.bounds.size.width*0.1)
        replayButton.color = UIColor.green
        
        addChild(replayButton)
    }
    
    func addTopBar() {
        
        let topBar = SKSpriteNode(texture: nil, color: UIColor.black, size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height*0.3))
            
        topBar.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height)
        topBar.zPosition = 4
        addChild(topBar)
        
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









