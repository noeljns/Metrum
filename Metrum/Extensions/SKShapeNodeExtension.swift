//
//  SKShapeNodeExtension.swift
//  Metrum
//
//  Created by Jonas Jonas on 01.03.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

extension SKLabelNode {
    /// Function to shake label node non stop
    func shakeLabelNode() {
        let duration = 6.0
        let position = self.position
        let rangeX:Float = 7.5
        let rangeY:Float = 7.5
        let numberOfShakes = duration / 0.2
        var actions:[SKAction] = []
        for _ in 1...Int(numberOfShakes) {
            let moveX = Float(arc4random_uniform(UInt32(rangeX))) - rangeX / 2
            let moveY = Float(arc4random_uniform(UInt32(rangeY))) - rangeY / 2
            let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.2)
            shakeAction.timingMode = SKActionTimingMode.easeOut
            actions.append(shakeAction)
            actions.append(shakeAction.reversed())
        }
        actions.append(SKAction.move(to: position, duration: 0.0))
        let actionSeq = SKAction.sequence(actions)
        let actionLoop = SKAction.repeatForever(actionSeq)
        self.run(actionLoop)
    }
}
