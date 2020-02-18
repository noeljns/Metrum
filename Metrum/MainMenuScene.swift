//
//  MainMenuScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 06.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
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

    override func didMove(to view: SKView) {
        let header = SKLabelNode(text: "METRUM")
        header.position = CGPoint(x: frame.midX, y: frame.midY + 450)
        header.fontSize = 55
        header.fontColor = SKColor.black
        header.zPosition = 2
        addChild(header)
        
        // draw buttons for level1 to level10
        generateLevels()
        // draw level1 colorful since it is always enterable
        drawLevelColorful(levelName: "level1")
        
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
        var canvasPosition = 380
        for index in 1...10 {
            let text = "Enter Level " + String(index)
            let name = "level" + String(index)
            generateLevel(text: text, name: name, canvasPosition: frame.midY + CGFloat(canvasPosition))
            
            canvasPosition = canvasPosition-90
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
    
    // colorize levels that are able to be entered and flag passed levels with trophy
    func markEnterableAndPassedLevels() {
        var trophyPosition = 370
        for (index, levelIsPassed) in levels.enumerated() {
            // last index / index = 9 is not necessary since there is no level11
            if levelIsPassed && index<9 {
                let indexOfNextLevel = index+2
                let nameOfNextLevel = "level" + String(indexOfNextLevel)
                drawLevelColorful(levelName: nameOfNextLevel)
            }
            
            if levelIsPassed {
                let trophyLabel = SKLabelNode(text: "🏆")
                trophyLabel.position = CGPoint(x: frame.midX + 150, y: frame.midY + CGFloat(trophyPosition))
                addChild(trophyLabel)
            }
            trophyPosition = trophyPosition-90
        }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // https://code.tutsplus.com/tutorials/spritekit-basics-nodes--cms-28785
        
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if(touchedNode.name == "level1") {
            let leveOneScene = LevelOneScene(fileNamed: "LevelOneScene")
            leveOneScene?.provideAudioHelp = false;
            leveOneScene?.provideInfoHelp = false;
            leveOneScene?.scaleMode = scaleMode
            view?.presentScene(leveOneScene)
        }
        
        if(touchedNode.name == "level2") {
            if levelOneIsPassed {
                let levelTwoScene = LevelTwoScene(fileNamed: "LevelTwoScene")
                levelTwoScene?.scaleMode = scaleMode
                view?.presentScene(levelTwoScene)
            }
            else {
                print("level 1 is not passed yet, you can't enter level 2!")
            }
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
