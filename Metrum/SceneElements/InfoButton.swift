//
//  infoButton.swift
//  Metrum
//
//  Created by Jonas Jonas on 28.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

class InfoButton: SKSpriteNode {
    
    init(size: CGSize, position: CGPoint) {
        super.init(texture: SKTexture(imageNamed: "icons8-info-50"), color: .clear, size: size)
        self.size = size
        self.position = position
        zPosition = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // fatalError("init(coder:) has not been implemented")
    }
}
