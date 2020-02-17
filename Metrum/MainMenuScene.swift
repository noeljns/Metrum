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
    
    override func didMove(to view: SKView) {
        print("test: " + levelOneIsPassed.description)

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
        
//        let testOneCanvas = SKSpriteNode(color: .lightGray, size: CGSize(width: 200, height: 50))
//        testOneCanvas.position = CGPoint(x: frame.midX, y: frame.midY + 280)
//        testOneCanvas.zPosition = 1
//        addChild(testOneCanvas)
//        let testOneLabel = SKLabelNode(text: "Test 1 🏆")
//        testOneLabel.name = "testOne"
//        testOneLabel.position = CGPoint(x: frame.midX, y: frame.midY-15)
//        testOneLabel.fontColor = SKColor.darkGray
//        testOneLabel.addStroke(color: .darkGray, width: 6.0)
//        testOneLabel.zPosition = 2
//        testOneCanvas.addChild(testOneLabel)
        
//        let levelTwoCanvas = SKSpriteNode(color: .lightGray, size: CGSize(width: 200, height: 50))
//        levelTwoCanvas.position = CGPoint(x: frame.midX, y: frame.midY + 180)
//        levelTwoCanvas.zPosition = 1
//        addChild(levelTwoCanvas)
//        let levelTwoLabel = SKLabelNode(text: "Enter Level 2")
//        levelTwoLabel.name = "levelTwo"
//        levelTwoLabel.position = CGPoint(x: frame.midX, y: frame.midY-15)
//        levelTwoLabel.fontColor = SKColor.darkGray
//        levelTwoLabel.addStroke(color: .darkGray, width: 6.0)
//        levelTwoLabel.zPosition = 2
//        levelTwoCanvas.addChild(levelTwoLabel)
        
//        let testTwoCanvas = SKSpriteNode(color: .lightGray, size: CGSize(width: 200, height: 50))
//        testTwoCanvas.position = CGPoint(x: frame.midX, y: frame.midY + 80)
//        testTwoCanvas.zPosition = 1
//        addChild(testTwoCanvas)
//        let testTwoLabel = SKLabelNode(text: "Test 2 🏆")
//        testTwoLabel.name = "testTwo"
//        testTwoLabel.position = CGPoint(x: frame.midX, y: frame.midY-15)
//        testTwoLabel.fontColor = SKColor.darkGray
//        testTwoLabel.addStroke(color: .darkGray, width: 6.0)
//        testTwoLabel.zPosition = 2
//        testTwoCanvas.addChild(testTwoLabel)

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
