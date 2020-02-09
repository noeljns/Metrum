//
//  LevelOneScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 06.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

class LevelOneScene: SKScene {
    
    private let taskLabel = SKLabelNode()
    
    private let accentOneBin = SKSpriteNode()
    private let accentTwoBin = SKSpriteNode()
    private var wordToBeRated = SKLabelNode()
    
    private let accentOne = SKLabelNode()
    private let accentTwo = SKLabelNode()

    private var accentuationInfo: AccentuationInfo!
    private var backgroundBlocker: SKSpriteNode!
    private var firstEntryOfLevelOne = true
    
    private let audioNode = SKNode()
    
    func setUpScene() {
        // loadingBar = SKSpriteNode(imaged Name: "...")
        let loadingBar = SKSpriteNode(imageNamed: "loadingBarOne")
        loadingBar.position = CGPoint(x: frame.midX , y: frame.midY+450)
        loadingBar.size = CGSize(width: 600, height: 35)
        addChild(loadingBar)
        
        taskLabel.fontColor = SKColor.black
        taskLabel.text = "Markiere die betonten (x́) und unbetonten (x) Silben des Wortes.\n" +
        "Ziehe dafür die Betonungszeichen in das jeweilige Kästchen über der Silbe."
        taskLabel.position = CGPoint(x: frame.midX , y: frame.midY+150)
        // break line: https://forums.developer.apple.com/thread/82994
        taskLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        taskLabel.numberOfLines = 0
        taskLabel.preferredMaxLayoutWidth = 480
        // taskLabel.zPosition = 2
        addChild(taskLabel)
        
        accentOneBin.color = SKColor.lightGray
        accentOneBin.size = CGSize(width: 40, height: 40)
        accentOneBin.position = CGPoint(x: frame.midX-30, y: frame.midY+70)
        addChild(accentOneBin)
        
        accentTwoBin.color = SKColor.lightGray
        accentTwoBin.size = CGSize(width: 40, height: 40)
        accentTwoBin.position = CGPoint(x: frame.midX+30, y: frame.midY+70)
        addChild(accentTwoBin)
        
        wordToBeRated.fontColor = SKColor.black
        wordToBeRated.text = "Sonne"
        wordToBeRated.fontSize = 50
        wordToBeRated.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(wordToBeRated)
        
        accentOne.fontColor = SKColor.black
        accentOne.text = "x́"
        accentOne.fontSize = 40
        accentOne.position = CGPoint(x: frame.midX-40, y: frame.midY-150)
        addChild(accentOne)
        
        accentTwo.fontColor = SKColor.black
        accentTwo.text = "x"
        accentTwo.fontSize = 40
        accentTwo.position = CGPoint(x: frame.midX+40, y: frame.midY-150)
        addChild(accentTwo)
        
        let accentuationInfoButton = SKSpriteNode(imageNamed: "info")
        accentuationInfoButton.name = "accentuationInfoBtn"
        accentuationInfoButton.position = CGPoint(x: frame.midX+225 , y: frame.midY+20)
        accentuationInfoButton.size = CGSize(width: 50, height: 50)
        addChild(accentuationInfoButton)
        
        let soundBoxButton = SKSpriteNode(imageNamed: "sound")
        soundBoxButton.name = "soundBoxBtn"
        soundBoxButton.position = CGPoint(x: frame.midX+150 , y: frame.midY+20)
        soundBoxButton.size = CGSize(width: 50, height: 50)
        addChild(soundBoxButton)
        
        addChild(audioNode)
    }
    
    func displayAccentuationInfo() {
        // backgroundBlocker = SKSpriteNode(imageNamed: "background3")
        backgroundBlocker = SKSpriteNode(color: SKColor.white, size: self.size)
        // backgroundBlocker.size = self.size
        backgroundBlocker.zPosition = 4999
        addChild(backgroundBlocker)

        accentuationInfo = AccentuationInfo(size: CGSize(width: 500, height: 800))
        accentuationInfo.delegate = self
        accentuationInfo.zPosition = 5000
        addChild(accentuationInfo)
    }
    
    override func didMove(to view: SKView) {
        setUpScene()
        
        if firstEntryOfLevelOne {
            displayAccentuationInfo()
            firstEntryOfLevelOne = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // https://code.tutsplus.com/tutorials/spritekit-basics-nodes--cms-28785
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if(touchedNode.name == "accentuationInfoBtn") {
            displayAccentuationInfo()
        }
        
        if(touchedNode.name == "soundBoxBtn") {
            print("soundbox touched")
//            let soundOfWordToBeRated = SKAction.playSoundFileNamed("Sonne.wav", waitForCompletion: true)
            audioNode.run(SKAction.playSoundFileNamed("Sonne.wav", waitForCompletion: true))
        }
        
    }
    
}

extension LevelOneScene: AccentuationInfoDelegate {
    func close() {
        //at this point you could update any GUI nesc. based on what happened in your dialog
        backgroundBlocker.removeFromParent()
        accentuationInfo?.removeFromParent()
    }
}





