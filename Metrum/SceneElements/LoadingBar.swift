//
//  LoadingBar.swift
//  Metrum
//
//  Created by Jonas Jonas on 27.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

class LoadingBar: SKNode {
    var bar: SKSpriteNode?
    var barContainer: SKShapeNode?
    // coding style, _progress should be private
    var _progress: CGFloat = 0.0
    var progress: CGFloat {
        get {
            return _progress
        }
        set {
            // min(newValue, 1.0) returns the lesser of the two values: never a value greater than 1.0
            // max(..., 0.0) returns the greater of the two values: never a value lesser than 0.0
            let value = max(min(newValue, 1.0), 0.0)
            if let bar = bar {
                // multiplies the width of the bar node
                bar.xScale = value
                _progress = value
            }
        }
    }
    
    // convenience initializers are used when a shortcut to a common initialization pattern will save time
    // or make initialization of the class clearer in intent.
    convenience init(color: SKColor, size: CGSize) {
        self.init()

        bar = SKSpriteNode(color: color, size: size)
        if let bar = bar {
            bar.xScale = 0.0
            bar.position = CGPoint(x: -size.width/2, y: 450)
            bar.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            addChild(bar)
        }
        
        barContainer = SKShapeNode(rectOf: CGSize(width: 600, height: 30), cornerRadius: 5)
        if let barContainer = barContainer {
            barContainer.position = CGPoint(x: frame.midX , y: frame.midY+450)
            barContainer.strokeColor = .lightGray
            barContainer.lineWidth = 4
            addChild(barContainer)
        }
    }
}
