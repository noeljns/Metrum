//
//  MainMenuScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 06.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import UIKit
import SpriteKit

class MainMenuScene: SKScene {

    override func didMove(to view: SKView) {
        let levelOneLabel = SKLabelNode(text: "Enter Level 1")
        levelOneLabel.name = "levelOne"
        // position label to the center of scene
        levelOneLabel.position = CGPoint(x: frame.midX, y: frame.midY+200)
        levelOneLabel.fontColor = SKColor.black
        addChild(levelOneLabel)
        
        let levelTwoLabel = SKLabelNode(text: "Enter Level 2")
        // position label to the center of scene
        levelTwoLabel.position = CGPoint(x: frame.midX, y: frame.midY+100)
        levelTwoLabel.fontColor = SKColor.black
        addChild(levelTwoLabel)
        
        let levelThreeLabel = SKLabelNode(text: "Enter Level 3")
        // position label to the center of scene
        levelThreeLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        levelThreeLabel.fontColor = SKColor.black
        addChild(levelThreeLabel)
        
        let levelFourLabel = SKLabelNode(text: "Enter Level 4")
        // position label to the center of scene
        levelFourLabel.position = CGPoint(x: frame.midX, y: frame.midY-100)
        levelFourLabel.fontColor = SKColor.black
        addChild(levelFourLabel)
        
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
    }
    
}
