//
//  StressMark.swift
//  Metrum
//
//  Created by Jonas Jonas on 05.03.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

class StressMark: SKSpriteNode {
    var isClinchedToAccentBin = false
    var wasNeverClinchedToAccentBin = true
    var isAtSpawnLocation = true
    
    init(isStressed: Bool, position: CGPoint) {
        // stressMarkTouchContainer
        super.init(texture: nil, color: .red, size: CGSize(width: 40, height: 50))
        self.position = position
        drawBorder(color: .orange, width: 4)
        zPosition = 1
    
        let stressMarkLabel = SKLabelNode()
        stressMarkLabel.fontColor = SKColor.black
        stressMarkLabel.fontSize = 40
        stressMarkLabel.zPosition = 2
        stressMarkLabel.position = CGPoint(x: -self.frame.width/4+10, y: -self.frame.height/4)
        stressMarkLabel.addStroke(color: .black, width: 6)
        // TODO higher function
        if isStressed {
            stressMarkLabel.text = "x́"
            self.name = "stressed"
        }
        else {
            stressMarkLabel.text = "x"
            self.name = "unstressed"
        }
        addChild(stressMarkLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}



