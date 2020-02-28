//
//  TaskLabel.swift
//  Metrum
//
//  Created by Jonas Jonas on 27.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

class TaskLabel: SKLabelNode {
    init(text: String, position: CGPoint) {
        super.init()
        fontColor = SKColor.black
        self.text = text
        self.position = position
        // break line: https://forums.developer.apple.com/thread/82994
        lineBreakMode = NSLineBreakMode.byWordWrapping
        numberOfLines = 0
        preferredMaxLayoutWidth = 600
        zPosition = 4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
