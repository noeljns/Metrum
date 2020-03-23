//
//  TaskLabel.swift
//  Metrum
//
//  Created by Jonas Zwink on 27.02.20.
//  Copyright © 2020 Jonas Zwink. All rights reserved.
//

import SpriteKit

class TaskLabel: SKLabelNode {
    init(text: String, position: CGPoint) {
        super.init()
        fontColor = SKColor.black
        self.text = text
        self.position = position
        lineBreakMode = NSLineBreakMode.byWordWrapping
        numberOfLines = 0
        preferredMaxLayoutWidth = 600
        zPosition = 4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
