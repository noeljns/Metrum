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
        accentuationInfoLabel.name = "accentuationInfo"
        accentuationInfoLabel.position = CGPoint(x: frame.midX+225, y: frame.midY)
        accentuationInfoLabel.fontColor = SKColor.black
        addChild(accentuationInfoLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // https://code.tutsplus.com/tutorials/spritekit-basics-nodes--cms-28785
        
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if(touchedNode.name == "accentuationInfo") {
            let accentuationInfoScene = AccentuationInfoScene(fileNamed: "AccentuationInfoScene")
            accentuationInfoScene?.scaleMode = scaleMode
            view?.presentScene(accentuationInfoScene)
        }
        
        if(touchedNode.name == "storage") {
            storage += 1
            print(storage)
        }
    }
    
}
