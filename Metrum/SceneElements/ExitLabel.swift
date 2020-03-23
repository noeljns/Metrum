//
//  ExitLabel.swift
//  Metrum
//
//  Created by Jonas Zwink on 27.02.20.
//  Copyright © 2020 Jonas Zwink. All rights reserved.
//

import SpriteKit

class ExitLabel: SKLabelNode {
    override init() {
        super.init()
        name = "exit"
        text = "x"
        fontColor = SKColor.black
        fontSize = 60
        position = CGPoint(x: -330, y: 433)
        zPosition = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

