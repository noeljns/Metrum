//
//  AccentuationInfoScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 06.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import UIKit
import SpriteKit

class AccentuationInfoScene: SKScene {
    
    override func didMove(to view: SKView) {
        let accentuationInfoLabel = SKLabelNode(text: "Accentuation Info Scene")
        accentuationInfoLabel.position = CGPoint(x: frame.midX, y: frame.midY+400)
        accentuationInfoLabel.fontColor = SKColor.black
        addChild(accentuationInfoLabel)
        
        
        let readyForLevelOneLabel = SKLabelNode(text: "Bereit")
        readyForLevelOneLabel.name = "readyForLevelOne"
        readyForLevelOneLabel.position = CGPoint(x: frame.midX+200, y: frame.midY-400)
        readyForLevelOneLabel.fontColor = SKColor.black
        addChild(readyForLevelOneLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // https://code.tutsplus.com/tutorials/spritekit-basics-nodes--cms-28785
        
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if(touchedNode.name == "readyForLevelOne") {
            let levelOneScene = LevelOneScene(fileNamed: "LevelOneScene")
            levelOneScene?.scaleMode = scaleMode
            view?.presentScene(levelOneScene)
        }
    }

}
