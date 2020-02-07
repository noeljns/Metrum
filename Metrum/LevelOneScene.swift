//
//  LevelOneScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 06.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import UIKit
import SpriteKit

class LevelOneScene: SKScene {

    var storage = 7
    
    var accentuationInfo: AccentuationInfo!
    var backgroundBlocker: SKSpriteNode!

    
    override func didMove(to view: SKView) {
        let levelOneLabel = SKLabelNode(text: "Level One")
        levelOneLabel.position = CGPoint(x: frame.midX, y: frame.midY+400)
        levelOneLabel.fontColor = SKColor.black
        addChild(levelOneLabel)
        
        let storageLabel = SKLabelNode(text: "speicher: " + String(storage))
        storageLabel.name = "storage"
        storageLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        storageLabel.fontColor = SKColor.black
        addChild(storageLabel)
        
        let accentuationInfoLabel = SKLabelNode(text: "INFO")
        accentuationInfoLabel.name = "accentuationInfoLbl"
        accentuationInfoLabel.position = CGPoint(x: frame.midX+225, y: frame.midY)
        accentuationInfoLabel.fontColor = SKColor.black
        addChild(accentuationInfoLabel)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched in LevelOneScene.swift")

        
        // https://code.tutsplus.com/tutorials/spritekit-basics-nodes--cms-28785
        
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if(touchedNode.name == "accentuationInfoLbl") {
//            let accentuationInfoScene = AccentuationInfoScene(fileNamed: "AccentuationInfoScene")
//            accentuationInfoScene?.scaleMode = scaleMode
//            view?.presentScene(accentuationInfoScene)
            displayAccentuationInfo()
        }
        
        if(touchedNode.name == "storage") {
            storage += 1
            print(storage)
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





