//
//  MeasureLabel.swift
//  Metrum
//
//  Created by Jonas Jonas on 28.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

class MeasureContainer: SKSpriteNode {
    init(position: CGPoint) {
        super.init(texture: nil, color: .clear, size: CGSize(width: 300, height: 300))
        color = SKColor.white
        self.position = position
        drawBorder(color: .lightGray, width: 5.0)
        zPosition = 1
        
        let measureLabel = SKLabelNode()
        measureLabel.name = "measureLabel"
        measureLabel.fontColor = SKColor.black
        measureLabel.position = CGPoint(x: 0, y: 100)
        measureLabel.zPosition = 2
        self.addChild(measureLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // fatalError("init(coder:) has not been implemented")
    }
    
    // https://developer.apple.com/documentation/spritekit/sknode/controlling_user_interaction_on_nodes
//    override var isUserInteractionEnabled: Bool {
//        set {
//            // ignore
//        }
//        get {
//            return true
//        }
//    }
}
