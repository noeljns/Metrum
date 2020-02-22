//
//  MainMenuScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 06.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    var firstEntryOfApp = UserDefaults.standard.bool(forKey: "firstEntry")
    var levelOneIsPassed = UserDefaults.standard.bool(forKey: "level1")
    var levelTwoIsPassed = UserDefaults.standard.bool(forKey: "level2")
    var levelThreeIsPassed = UserDefaults.standard.bool(forKey: "level3")
    var levelFourIsPassed = UserDefaults.standard.bool(forKey: "level4")
    var levelFiveIsPassed = UserDefaults.standard.bool(forKey: "level5")
    var levelSixIsPassed = UserDefaults.standard.bool(forKey: "level6")
    var levelSevenIsPassed = UserDefaults.standard.bool(forKey: "level7")
    var levelEightIsPassed = UserDefaults.standard.bool(forKey: "level8")
    var levelNineIsPassed = UserDefaults.standard.bool(forKey: "level9")
    var levenTenIsPassed = UserDefaults.standard.bool(forKey: "level10")

    lazy var levels = [levelOneIsPassed, levelTwoIsPassed, levelThreeIsPassed, levelFourIsPassed, levelFiveIsPassed,
                       levelSixIsPassed, levelSevenIsPassed, levelEightIsPassed, levelNineIsPassed, levenTenIsPassed]
    
    // overlay windows
    private var backgroundBlocker: SKSpriteNode!
    private var salutation: Salutation!
    private var levelExplanation: LevelExplanation!
    
    func displaySalutation() {
        backgroundBlocker = SKSpriteNode(color: SKColor.white, size: self.size)
        backgroundBlocker.zPosition = 4999
        addChild(backgroundBlocker)
        
        salutation = Salutation(size: CGSize(width: 650, height: 800))
        salutation.delegate = self
        salutation.zPosition = 5000
        addChild(salutation)
    }
    
    func displayLevelExplanation(levelIndex: String) {
        backgroundBlocker = SKSpriteNode(color: SKColor.white, size: self.size)
        backgroundBlocker.alpha = 0.5
        backgroundBlocker.zPosition = 4999
        addChild(backgroundBlocker)
        
        levelExplanation = LevelExplanation(size: CGSize(width: 550, height: 250), levelIndex: levelIndex)
        levelExplanation.delegate = self
        levelExplanation.zPosition = 5000
        addChild(levelExplanation)
    }


    override func didMove(to view: SKView) {
        if !(firstEntryOfApp) {
            displaySalutation()
            UserDefaults.standard.set(true, forKey: "firstEntry")
        }
        
        let header = SKLabelNode(text: "METRUM")
        header.name = "header"
        header.position = CGPoint(x: frame.midX, y: frame.midY + 440)
        header.fontSize = 55
        header.fontColor = SKColor.black
        header.zPosition = 2
        addChild(header)
        
        // draw buttons for level1 to level10
        generateLevels()
        // draw level1 colorful since it is always enterable
        drawLevelColorful(levelName: "level1")
        
        // draw info buttons next to levels
        generateLevelExplanation()
        
        // colorize levels that are able to be entered and flag passed levels with trophy
        markEnterableAndPassedLevels()

        // debug function
//        UserDefaults.standard.set(false, forKey: "level3")
//        UserDefaults.standard.set(true, forKey: "level2")
//        for level in levels {
//            print(level.description)
//        }
    }
    
    func generateLevels() {
        var canvasPosition = 370
        for index in 1...10 {
            let text = "Enter Level " + String(index)
            let name = "level" + String(index)
            generateLevel(text: text, name: name, canvasPosition: frame.midY + CGFloat(canvasPosition))
            
            canvasPosition = canvasPosition-85
        }
    }
    
    func generateLevelExplanation() {
        var infoButtonPosition = 370
        for index in 1...10 {
            let infoButton = SKSpriteNode(imageNamed: "icons8-info-50")
            infoButton.name = "infoButtonLevel" + String(index)
            infoButton.position = CGPoint(x: frame.midX-150, y: frame.midY + CGFloat(infoButtonPosition))
            infoButton.size = CGSize(width: 50, height: 50)
            addChild(infoButton)
            
            infoButtonPosition = infoButtonPosition-85
        }
    }
    
    func generateLevel(text: String, name: String, canvasPosition: CGFloat) {
        let canvas = SKSpriteNode(color: .lightGray, size: CGSize(width: 240, height: 50))
        canvas.name = "canvas" + name
        canvas.position = CGPoint(x: frame.midX, y: canvasPosition)
        canvas.zPosition = 1
        addChild(canvas)
        let label = SKLabelNode(text: text)
        label.name = name
        label.position = CGPoint(x: frame.midX, y: frame.midY-15)
        label.fontColor = SKColor.darkGray
        label.addStroke(color: .darkGray, width: 6.0)
        label.zPosition = 2
        canvas.addChild(label)
    }
    
    
    // TODO caution optinals
    func drawLevelColorful(levelName: String) {
        let canvasName = "canvas" + levelName
        let canvas = self.childNode(withName: canvasName) as? SKSpriteNode
        canvas?.color = .orange
        let label = canvas?.childNode(withName: levelName) as? SKLabelNode
        label?.fontColor = SKColor.white
        label?.addStroke(color: .white, width: 6.0)
    }
    
    
    // colorize levels that are able to be entered and flag passed levels with trophy
    func markEnterableAndPassedLevels() {
        var trophyPosition = 360
        for (index, levelIsPassed) in levels.enumerated() {
            print("levelisPassed: " + String(index) + " " + String(levelIsPassed))
            
            // last index / index = 9 is not necessary since there is no level11
            if levelIsPassed && index<9 {
                print("levelisPassed: " + String(levelIsPassed) + " " + String(index))
                let indexOfNextLevel = index+2
                let nameOfNextLevel = "level" + String(indexOfNextLevel)
                print("nameOfNextLevel: " + nameOfNextLevel)
                drawLevelColorful(levelName: nameOfNextLevel)
            }
            
            if levelIsPassed {
                let trophyLabel = SKLabelNode(text: "🏆")
                trophyLabel.position = CGPoint(x: frame.midX+145, y: frame.midY + CGFloat(trophyPosition))
                addChild(trophyLabel)
            }
            trophyPosition = trophyPosition-85
        }
    }
    
    // https://docs.swift.org/swift-book/LanguageGuide/TypeCasting.html
    // https://developer.apple.com/swift/blog/?id=23
    // https://thatthinginswift.com/guard-statement-swift/
//    func openLevelIfClicked(touchedNode: SKNode) {
//        for index in 1...10 {
//            if (touchedNode.name == "level" + String(index)) {
//                // generate correct Level Class
//
//                var levelScene = SKScene()
//                if [1, 2, 3, 4].contains(index) {
//                    guard levelScene == SKScene(fileNamed: "LevelOneToFourScene") as! LevelOneToFourScene else {
//                        return
//                    }
//                }
//                else if [5, 6].contains(index) {
//                    guard levelScene == SKScene(fileNamed: "LevelFiveToSixScene") as! LevelFiveToSixScene else {
//                        return
//                    }
//                }
//                else if [7, 8, 9, 10].contains(index) {
//                    guard levelScene == SKScene(fileNamed: "LevelSevenToTenScene") as! LevelSevenToTenScene else {
//                        return
//                    }
//                }
//
//                // set provideHelp variable
//                if index % 2 != 0 {
//                    // in level 1, 3, 5, 7, 9 help is provided
//                    levelScene.provideHelp = true
//                } else {
//                    levelScene.provideHelp = false
//                }
//
//                // set inputFile variable
//                if [1, 2, 7, 8].contains(index) {
//                    levelScene.inputFile = "words.json"
//                }
//                else if [3, 4, 9, 10].contains(index) {
//                    levelScene.inputFile = "lines.json"
//                }
//
//                levelScene.userDefaultsKey = "level" + String(index)
//                levelScene.scaleMode = scaleMode
//                view?.presentScene(levelScene)
//            }
//        }
//    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // https://code.tutsplus.com/tutorials/spritekit-basics-nodes--cms-28785
        
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if (touchedNode.name == "header") {
            displaySalutation()
        }
        
        for index in 1...10 {
            if(touchedNode.name == "infoButtonLevel" + String(index)) {
                displayLevelExplanation(levelIndex: "level" + String(index))
            }
        }
        
        if(touchedNode.name == "level1") {
            let levelOneScene = LevelOneToFourScene(fileNamed: "LevelOneToFourScene")
            levelOneScene?.provideHelp = true
            levelOneScene?.inputFile = "words.json"
            levelOneScene?.userDefaultsKey = "level1"
            levelOneScene?.scaleMode = scaleMode
            view?.presentScene(levelOneScene)
        }
        
        if(touchedNode.name == "level2" && levelOneIsPassed) {
            let levelTwoScene = LevelOneToFourScene(fileNamed: "LevelOneToFourScene")
            levelTwoScene?.provideHelp = false
            levelTwoScene?.inputFile = "words.json"
            levelTwoScene?.userDefaultsKey = "level2"
            levelTwoScene?.scaleMode = scaleMode
            view?.presentScene(levelTwoScene)
        }
        
        if(touchedNode.name == "level3" && levelTwoIsPassed) {
            let levelThreeScene = LevelOneToFourScene(fileNamed: "LevelOneToFourScene")
            levelThreeScene?.provideHelp = true
            levelThreeScene?.inputFile = "lines.json"
            levelThreeScene?.userDefaultsKey = "level3"
            levelThreeScene?.scaleMode = scaleMode
            view?.presentScene(levelThreeScene)
        }
        
        if(touchedNode.name == "level4" && levelThreeIsPassed) {
            let levelFourScene = LevelOneToFourScene(fileNamed: "LevelOneToFourScene")
            levelFourScene?.provideHelp = false
            levelFourScene?.inputFile = "lines.json"
            levelFourScene?.userDefaultsKey = "level4"
            levelFourScene?.scaleMode = scaleMode
            view?.presentScene(levelFourScene)
        }
        
        if(touchedNode.name == "level5" && levelFourIsPassed) {
            let levelFiveScene = LevelFiveToSixScene(fileNamed: "LevelFiveToSixScene")
            levelFiveScene?.provideHelp = true
            levelFiveScene?.userDefaultsKey = "level5"
            levelFiveScene?.scaleMode = scaleMode
            view?.presentScene(levelFiveScene)
        }
        
        if(touchedNode.name == "level6" && levelFiveIsPassed) {
            let levelSixScene = LevelFiveToSixScene(fileNamed: "LevelFiveToSixScene")
            levelSixScene?.provideHelp = false
            levelSixScene?.userDefaultsKey = "level6"
            levelSixScene?.scaleMode = scaleMode
            view?.presentScene(levelSixScene)
        }
        
        if(touchedNode.name == "level7" && levelSixIsPassed) {
            let levelSevenScene = LevelSevenToTenScene(fileNamed: "LevelSevenToTenScene")
            levelSevenScene?.provideHelp = true
            levelSevenScene?.inputFile = "words.json"
            levelSevenScene?.userDefaultsKey = "level7"
            levelSevenScene?.scaleMode = scaleMode
            view?.presentScene(levelSevenScene)
        }
        
        if(touchedNode.name == "level8" && levelSevenIsPassed) {
            let levelEightScene = LevelSevenToTenScene(fileNamed: "LevelSevenToTenScene")
            levelEightScene?.provideHelp = false
            levelEightScene?.inputFile = "words.json"
            levelEightScene?.userDefaultsKey = "level8"
            levelEightScene?.scaleMode = scaleMode
            view?.presentScene(levelEightScene)
        }
        
        if(touchedNode.name == "level9" && levelEightIsPassed) {
            let levelNineScene = LevelSevenToTenScene(fileNamed: "LevelSevenToTenScene")
            levelNineScene?.provideHelp = true
            levelNineScene?.inputFile = "lines.json"
            levelNineScene?.userDefaultsKey = "level9"
            levelNineScene?.scaleMode = scaleMode
            view?.presentScene(levelNineScene)
        }
        
        if(touchedNode.name == "level10" && levelNineIsPassed) {
            let levelTenScene = LevelSevenToTenScene(fileNamed: "LevelSevenToTenScene")
            levelTenScene?.provideHelp = false
            levelTenScene?.inputFile = "lines.json"
            levelTenScene?.userDefaultsKey = "level10"
            levelTenScene?.scaleMode = scaleMode
            view?.presentScene(levelTenScene)
        }
    }
    
}


// https://living-sun.com/swift/825957-sklabelnode-border-and-bounds-issue-swift-text-sprite-kit-border-sklabelnode.html
extension SKLabelNode {
    
    func addStroke(color:UIColor, width: CGFloat) {
        guard let labelText = self.text else { return }
        
        let font = UIFont(name: self.fontName!, size: self.fontSize)
        
        let attributedString:NSMutableAttributedString
        if let labelAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        }
        else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        let attributes:[NSAttributedString.Key:Any] = [.strokeColor: color, .strokeWidth: -width, .font: font!, .foregroundColor: self.fontColor!]
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}


extension MainMenuScene: SalutationDelegate, LevelExplanationDelegate {
    func closeSalutation() {
        backgroundBlocker.removeFromParent()
        salutation?.removeFromParent()
    }
    
    func closeLevelExplanation() {
        backgroundBlocker.removeFromParent()
        levelExplanation?.removeFromParent()
    }
}
