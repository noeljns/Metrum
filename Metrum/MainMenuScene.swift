//
//  MainMenuScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 06.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    var levelOneIsPassed = UserDefaults.standard.bool(forKey: "levelOne")
    var testOneIsPassed = UserDefaults.standard.bool(forKey: "testOne")
    var levelTwoIsPassed = UserDefaults.standard.bool(forKey: "levelTwo")
    var testTwoIsPassed = UserDefaults.standard.bool(forKey: "testTwo")
    var levelThreeIsPassed = UserDefaults.standard.bool(forKey: "levelThree")
    var testThreeIsPassed = UserDefaults.standard.bool(forKey: "testThree")
    var levelFourIsPassed = UserDefaults.standard.bool(forKey: "levelFour")
    var testFourIsPassed = UserDefaults.standard.bool(forKey: "testFour")
    var levelFiveIsPassed = UserDefaults.standard.bool(forKey: "levelFive")
    var testFiveIsPassed = UserDefaults.standard.bool(forKey: "testFive")

    override func didMove(to view: SKView) {
        let header = SKLabelNode(text: "METRUM")
        header.position = CGPoint(x: frame.midX, y: frame.midY + 450)
        header.fontSize = 55
        header.fontColor = SKColor.black
        header.zPosition = 2
        addChild(header)
        
        let levelOneCanvas = SKSpriteNode(color: .orange, size: CGSize(width: 200, height: 50))
        levelOneCanvas.position = CGPoint(x: frame.midX, y: frame.midY + 380)
        levelOneCanvas.zPosition = 1
        // levelOneCanvas.drawBorder(color: .yellow, width: 5)
        addChild(levelOneCanvas)
        let levelOneLabel = SKLabelNode(text: "Enter Level 1")
        levelOneLabel.name = "levelOne"
        levelOneLabel.position = CGPoint(x: frame.midX, y: frame.midY-15)
        levelOneLabel.fontColor = SKColor.white
        levelOneLabel.addStroke(color: .white, width: 6.0)
        levelOneLabel.zPosition = 2
        levelOneCanvas.addChild(levelOneLabel)
        
        generateLevel(text: "Test 1 🏆", name: "testOne", canvasPosition: frame.midY + 290)
        generateLevel(text: "Enter Level 2", name: "levelTwo", canvasPosition: frame.midY + 200)
        generateLevel(text: "Test 2 🏆", name: "testTwo", canvasPosition: frame.midY + 110)
        generateLevel(text: "Enter Level 3", name: "levelThree", canvasPosition: frame.midY + 20)
        generateLevel(text: "Test 3 🏆", name: "testThree", canvasPosition: frame.midY - 70)
        generateLevel(text: "Enter Level 4", name: "levelFour", canvasPosition: frame.midY - 160)
        generateLevel(text: "Test 4 🏆", name: "testFour", canvasPosition: frame.midY - 250)
        generateLevel(text: "Enter Level 5", name: "levelFive", canvasPosition: frame.midY - 340)
        generateLevel(text: "Test 5 🏆", name: "testFive", canvasPosition: frame.midY - 430)
        
        if levelOneIsPassed {
            // node testOne needs other colors
            // children.
        }
    }
    
    func generateLevel(text: String, name: String, canvasPosition: CGFloat) {
        let canvas = SKSpriteNode(color: .lightGray, size: CGSize(width: 200, height: 50))
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // https://code.tutsplus.com/tutorials/spritekit-basics-nodes--cms-28785
        
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if(touchedNode.name == "levelOne") {
            let leveOneScene = LevelOneScene(fileNamed: "LevelOneScene")
            leveOneScene?.scaleMode = scaleMode
            view?.presentScene(leveOneScene)
        }
        
        if(touchedNode.name == "levelTwo") {
            let levelTwoScene = LevelTwoScene(fileNamed: "LevelTwoScene")
            levelTwoScene?.scaleMode = scaleMode
            view?.presentScene(levelTwoScene)
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
