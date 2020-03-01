//
//  SKSpriteNodeExension.swift
//  Metrum
//
//  Created by Jonas Jonas on 28.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit




extension SKSpriteNode {
    /// Function to shake sprite node non stop
    func shakeSpriteNode() {
        let duration = 6.0
        let position = self.position
        let rangeX:Float = 15
        let rangeY:Float = 15
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
    
    /// Draws border around sprite node and adds border to scene
    ///
    /// - Parameters:
    ///   - color: color in which border shall be drawn
    ///   - width: width in which border shall be drawn
    func drawBorder(color: UIColor, width: CGFloat) {
        let shapeNode = SKShapeNode(rectOf: size)
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = color
        shapeNode.lineWidth = width
        addChild(shapeNode)
    }
    
    /// Returns String as NSMutableAttributedString and when indicated in bold.
    ///
    /// - Parameters:
    ///   - stringToBeMutated: The String which should be returnded.
    ///   - shallBecomceBold: This Boolean says whether String shall be bold or not.
    ///   - size: Size of the String
    /// - Returns: The String as NSMutableAttributedString.
    func makeAttributedString(stringToBeMutated: String, shallBecomeBold: Bool, size: CGFloat) -> NSMutableAttributedString {
        if(shallBecomeBold) {
            let bold = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: size)]
            let attributedString =  NSMutableAttributedString(string:stringToBeMutated, attributes:bold as [NSAttributedString.Key : Any])
            return attributedString
        }
        else {
            let notBold = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-UltraLight", size: size)]
            let normalString = NSMutableAttributedString(string:stringToBeMutated, attributes: notBold as [NSAttributedString.Key : Any])
            return normalString
        }
    }
}
