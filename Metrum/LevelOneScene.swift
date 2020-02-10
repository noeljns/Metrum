//
//  LevelOneScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 06.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

class LevelOneScene: SKScene {
    // examples of input data
    // https://stackoverflow.com/questions/45423321/cannot-use-instance-member-within-property-initializer#comment101019582_45423454
    lazy var freu = Syllable(syllableString: "Freu", accentuation: Accentuation.stressed)
    lazy var de = Syllable(syllableString: "de", accentuation: Accentuation.unstressed)
    lazy var freude = Word(syllables: [freu, de])
    lazy var schoe = Syllable(syllableString: "schoe", accentuation: Accentuation.stressed)
    lazy var ner = Syllable(syllableString: "ner", accentuation: Accentuation.unstressed)
    lazy var schoener = Word(syllables: [schoe, ner])
    lazy var goe = Syllable(syllableString: "Goe", accentuation: Accentuation.stressed)
    lazy var tter = Syllable(syllableString: "tter", accentuation: Accentuation.unstressed)
    lazy var fun = Syllable(syllableString: "fun", accentuation: Accentuation.stressed)
    lazy var ken = Syllable(syllableString: "tter", accentuation: Accentuation.unstressed)
    lazy var goetterfunken = Word(syllables: [goe, tter, fun, ken])
    lazy var lineOne = Line(words: [freude, schoener, goetterfunken], measure: Measure.trochaeus, audioFile: "lineOne.mp3")
    
    lazy var so = Syllable(syllableString: "So", accentuation: Accentuation.stressed)
    lazy var nne = Syllable(syllableString: "nne", accentuation: Accentuation.unstressed)
    lazy var sonne = Word(syllables: [so, nne])
    lazy var lineTwo = Line(words: [sonne], measure: Measure.trochaeus, audioFile: "Sonne.mp3")
    
    lazy var ge = Syllable(syllableString: "Ge", accentuation: Accentuation.unstressed)
    lazy var spenst = Syllable(syllableString: "spenst", accentuation: Accentuation.stressed)
    lazy var gespenst = Word(syllables: [ge, spenst])
    lazy var lineThree = Line(words: [gespenst], measure: Measure.jambus, audioFile: "Gespenst.mp3")
    
    
    
    // variables
    private var exitLabel = SKLabelNode()
    private var loadingBar = SKSpriteNode()
    
    private let taskLabel = SKLabelNode()
    private let accentOneBin = SKSpriteNode()
    private let accentTwoBin = SKSpriteNode()
    
    private var wordToBeRated = SKLabelNode()
    private var wordToBeRatedBold = SKLabelNode()
    
    private let stressedParent = SKSpriteNode()
    private let stressed = SKLabelNode()
    private let unstressedParent = SKSpriteNode()
    private let unstressed = SKLabelNode()
    
    private var accentuationInfoButton = SKSpriteNode()
    private var accentuationInfo: AccentuationInfo!
    private var backgroundBlocker: SKSpriteNode!
    private var firstEntryOfLevelOne = true
    
    private var soundBoxButton = SKSpriteNode()
    private let audioNode = SKNode()
    
    private var checkButton = SKSpriteNode()

    // old data model
//    let selection = [(["x́", "x"], ["Sonne", "So", "nne", "Sonne.mp3"]),
//                     (["x", "x́"], ["Gespenst", "Ge", "spenst", "Gespenst.mp3"])]
//    var selected = (["x́", "x"], ["Sonne", "So", "nne", "Sonne.WAV"])

    // new data model
    lazy var selection = [lineTwo, lineThree]
    lazy var selected = lineTwo
    
    func setUpScene() {
        exitLabel.name = "exit"
        exitLabel.fontColor = SKColor.black
        exitLabel.text = "x"
        exitLabel.fontSize = 60
        exitLabel.position = CGPoint(x: frame.midX-330, y: frame.midY+435)
        exitLabel.zPosition = 2
        addChild(exitLabel)
        
        loadingBar = SKSpriteNode(imageNamed: "loadingBarOne")
        loadingBar.position = CGPoint(x: frame.midX , y: frame.midY+450)
        loadingBar.size = CGSize(width: 600, height: 35)
        loadingBar.zPosition = 3
        addChild(loadingBar)
        
        taskLabel.fontColor = SKColor.black
        taskLabel.text = "Markiere die betonten (x́) und unbetonten (x) Silben des Wortes.\n" +
        "Ziehe dafür die Betonungszeichen in das jeweilige Kästchen über der Silbe."
        taskLabel.position = CGPoint(x: frame.midX , y: frame.midY+150)
        // break line: https://forums.developer.apple.com/thread/82994
        taskLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        taskLabel.numberOfLines = 0
        taskLabel.preferredMaxLayoutWidth = 480
        taskLabel.zPosition = 4
        addChild(taskLabel)
        
        accentOneBin.color = SKColor.lightGray
        accentOneBin.size = CGSize(width: 40, height: 40)
        accentOneBin.position = CGPoint(x: frame.midX-30, y: frame.midY+70)
        accentOneBin.zPosition = 2
        addChild(accentOneBin)
        
        accentTwoBin.color = SKColor.lightGray
        accentTwoBin.size = CGSize(width: 40, height: 40)
        accentTwoBin.position = CGPoint(x: frame.midX+30, y: frame.midY+70)
        accentTwoBin.zPosition = 2
        addChild(accentTwoBin)
        
        accentuationInfoButton = SKSpriteNode(imageNamed: "info")
        accentuationInfoButton.name = "accentuationInfoBtn"
        accentuationInfoButton.position = CGPoint(x: frame.midX+225 , y: frame.midY+20)
        accentuationInfoButton.size = CGSize(width: 50, height: 50)
        accentuationInfoButton.zPosition = 2
        addChild(accentuationInfoButton)
        
        soundBoxButton = SKSpriteNode(imageNamed: "sound")
        soundBoxButton.name = "soundBoxBtn"
        soundBoxButton.position = CGPoint(x: frame.midX+150 , y: frame.midY+20)
        soundBoxButton.size = CGSize(width: 50, height: 50)
        soundBoxButton.zPosition = 2
        addChild(soundBoxButton)
        
        checkButton = SKSpriteNode(imageNamed: "check")
        checkButton.name = "check"
        checkButton.position = CGPoint(x: frame.midX+200, y: frame.midY-300)
        checkButton.size = CGSize(width: 175, height: 50)
        checkButton.zPosition = 2
        // not working
        checkButton.drawBorder(color: .yellow, width: 5)
        addChild(checkButton)
    }
    
    func setUpUnfixedParts() {
        selected = selection.randomElement()!
        
        wordToBeRated.fontColor = SKColor.black
        // old data model
        // wordToBeRated.attributedText = makeAttributedString(stringToBeMutated: (selected.1[0]), shallBecomeBold: false)
        wordToBeRated.attributedText = makeAttributedString(stringToBeMutated: (selected.words[0].word), shallBecomeBold: false)
        
        wordToBeRated.position = CGPoint(x: frame.midX, y: frame.midY)
        wordToBeRated.zPosition = 2
        addChild(wordToBeRated)
        
        wordToBeRatedBold.fontColor = SKColor.black
        // old data model
        // selected.1[1] contains "So, and selected.1[2] contains "nne"
//        let firstSyllableIsStressed = (selected.0[0] == "x́")
//        let firstSyllable = makeAttributedString(stringToBeMutated: (selected.1[1]), shallBecomeBold: firstSyllableIsStressed)
//        let secondSyllableIsStressed = (selected.0[1] == "x́")
//        let secondSyllable = makeAttributedString(stringToBeMutated: (selected.1[2]), shallBecomeBold: secondSyllableIsStressed)
        // new data model
        let firstSyllableIsStressed = (selected.words[0].syllables[0].accentuation == Accentuation.stressed)
        let firstSyllable = makeAttributedString(stringToBeMutated: (selected.words[0].syllables[0].syllableString), shallBecomeBold: firstSyllableIsStressed)
        let secondSyllableIsStressed = (selected.words[0].syllables[1].accentuation == Accentuation.stressed)
        let secondSyllable = makeAttributedString(stringToBeMutated: (selected.words[0].syllables[1].syllableString), shallBecomeBold: secondSyllableIsStressed)
        
        firstSyllable.append(secondSyllable)
        wordToBeRatedBold.attributedText = firstSyllable
        wordToBeRatedBold.position = CGPoint(x: frame.midX, y: frame.midY)
        wordToBeRatedBold.zPosition = 2
        // addChild(wordToBeRatedBold)
        
        addChild(audioNode)
        
        // https://stackoverflow.com/questions/42026839/make-touch-area-for-sklabelnode-bigger-for-small-characters#comment71238691_42026839
        stressedParent.color = .white
        stressedParent.size = CGSize(width: 50, height: 50)
        stressedParent.position = CGPoint(x: frame.midX-40, y: frame.midY-150)
        stressedParent.zPosition = 1
        stressed.fontColor = SKColor.black
        stressed.text = "x́"
        stressed.fontSize = 40
        stressed.zPosition = 2
        stressedParent.addChild(stressed)
        addChild(stressedParent)
        
        unstressedParent.color = .white
        unstressedParent.size = CGSize(width: 50, height: 50)
        unstressedParent.position = CGPoint(x: frame.midX+40, y: frame.midY-150)
        unstressedParent.zPosition = 1
        unstressed.fontColor = SKColor.black
        unstressed.text = "x"
        unstressed.fontSize = 40
        unstressed.zPosition = 2
        unstressedParent.addChild(unstressed)
        addChild(unstressedParent)
    }
    
    func check() {
        wordToBeRated.removeFromParent()
        audioNode.removeFromParent()
        stressed.removeFromParent()
        stressedParent.removeFromParent()
        unstressed.removeFromParent()
        unstressedParent.removeFromParent()
        
        setUpUnfixedParts()
    }
    
    func makeAttributedString(stringToBeMutated: String, shallBecomeBold: Bool) -> NSMutableAttributedString {
        if(shallBecomeBold) {
            let bold = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 55)]
            let attributedString = NSMutableAttributedString(string:stringToBeMutated, attributes:bold)
            return attributedString
        }
        else {
            let notBold = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 50)]
            let normalString = NSMutableAttributedString(string:stringToBeMutated, attributes: notBold)
            return normalString
        }
    }
    
    func displayAccentuationInfo() {
        backgroundBlocker = SKSpriteNode(color: SKColor.white, size: self.size)
        backgroundBlocker.zPosition = 4999
        addChild(backgroundBlocker)

        accentuationInfo = AccentuationInfo(size: CGSize(width: 650, height: 800))

        accentuationInfo.delegate = self
        accentuationInfo.zPosition = 5000
        addChild(accentuationInfo)
    }
    
    func addAndRemoveNode(node: SKLabelNode) {
        addChild(node)
        node.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.removeFromParent(),
            ])
        )
    }
    
    func hideAndUnhideNode(node: SKLabelNode) {
        node.run(SKAction.sequence([
            SKAction.hide(),
            SKAction.wait(forDuration: 1.0),
            SKAction.unhide()
            ])
        )
    }
    

    override func didMove(to view: SKView) {
        setUpScene()
        setUpUnfixedParts()
        
        // has to be stored as NSuserData
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
            // https://www.reddit.com/r/swift/comments/2wpspa/running_parallel_skactions_with_different_nodes/
            // https://stackoverflow.com/questions/28823386/skaction-playsoundfilenamed-fails-to-load-sound
            // worked
            // audioNode.run(SKAction.playSoundFileNamed("Sonne.WAV", waitForCompletion: false))
            // audioNode.run(SKAction.playSoundFileNamed("test.WAV", waitForCompletion: false))
            // old data model
//            let playSound = SKAction.playSoundFileNamed(selected.1[3], waitForCompletion: true)
            // new data model
            let playSound = SKAction.playSoundFileNamed(selected.audioFile, waitForCompletion: true)
            let action =  SKAction.group([playSound,
                                          SKAction.run{self.addAndRemoveNode(node: self.wordToBeRatedBold)},
                                          SKAction.run{self.hideAndUnhideNode(node: self.wordToBeRated)}])
            self.run(action)
        }
        
        if (touchedNode.name == "check") {
            print("check!")
            
            // if accent in correct order, then show green overlay
            // if "weiter" clicked, then
            // loadingBar with new image
            // new selected word
            check()
        }
        
        if (touchedNode.name == "exit") {
            // https://stackoverflow.com/questions/46954696/save-state-of-gamescene-through-transitions
            let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
            self.view?.presentScene(mainMenu)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get a touch
        let touch = touches.first!
        
        // if it started in the accent, move it to the new location
        if stressedParent.frame.contains(touch.previousLocation(in: self)) {
            stressedParent.position = touch.location(in: self)
        }
        else if unstressedParent.frame.contains(touch.previousLocation(in: self)) {
            unstressedParent.position = touch.location(in: self)
        }
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if accentOneBin.frame.contains(stressedParent.position) {
            // https://www.hackingwithswift.com/example-code/games/how-to-color-an-skspritenode-using-colorblendfactor
            // https://stackoverflow.com/questions/36136665/how-to-animate-a-matrix-changing-the-sprites-one-by-one
            // einrasten
            stressedParent.position = accentOneBin.position
            stressedParent.position.y = accentOneBin.position.y - 15

            
//            if wordToBeRated.name == "jambus" {
//                counter += 1
//                jambusBin.run(SKAction.sequence([colorizeGreen, colorizeWhite]))
//
//                // remove it and create a new label
//                wordToBeRated.removeFromParent()
//                setupDragLabel()
//            }
//                // else if wordToBeRated.name == "trochaeus" or "daktylus" or "anapaest"
//            else {
//                jambusBin.run(SKAction.sequence([colorizeRed, colorizeWhite]))
//                wordToBeRated.position = CGPoint(x: frame.midX, y: frame.midY)
//            }
        }
        
        if accentOneBin.frame.contains(unstressedParent.position) {
            // einrasten
            unstressedParent.position = accentOneBin.position
            unstressedParent.position.y = accentOneBin.position.y - 15
        }
        
        if accentTwoBin.frame.contains(stressedParent.position) {
            // einrasten
            stressedParent.position = accentTwoBin.position
            stressedParent.position.y = accentTwoBin.position.y - 15
        }
        
        if accentTwoBin.frame.contains(unstressedParent.position) {
            // einrasten
            unstressedParent.position = accentTwoBin.position
            unstressedParent.position.y = accentTwoBin.position.y - 15
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
}



extension LevelOneScene: AccentuationInfoDelegate {
    func close() {
        //at this point you could update any GUI nesc. based on what happened in your dialog
        backgroundBlocker.removeFromParent()
        accentuationInfo?.removeFromParent()
    }
}




