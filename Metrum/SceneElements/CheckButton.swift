//
//  CheckButton.swift
//  Metrum
//
//  Created by Jonas Jonas on 27.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

class CheckButton: SKSpriteNode {
    let checkButtonLabel = SKLabelNode(text: "Check")
    
    init(size: CGSize) {
        super.init(texture: nil, color: .lightGray, size: size)
        position = CGPoint(x: frame.midX+200, y: frame.midY-350)
        
        checkButtonLabel.name = "checkButtonLabel"
        checkButtonLabel.position = CGPoint(x: 0, y: -15)
        checkButtonLabel.zPosition = 2
        checkButtonLabel.fontColor = SKColor.darkGray
        checkButtonLabel.addStroke(color: .darkGray, width: 6.0)
        self.addChild(checkButtonLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func activate() {
        color = .green
        checkButtonLabel.fontColor = .white
        checkButtonLabel.addStroke(color: .white, width: 6.0)
    }
    func deactivate() {
        color = .lightGray
        checkButtonLabel.fontColor = .darkGray
        checkButtonLabel.addStroke(color: .darkGray, width: 6.0)
    }
}
