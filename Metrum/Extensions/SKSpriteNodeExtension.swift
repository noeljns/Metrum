//
//  SKSpriteNodeExension.swift
//  Metrum
//
//  Created by Jonas Jonas on 28.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    // https://stackoverflow.com/questions/20889222/can-i-add-a-border-to-an-skspritenode-similar-to-uiview
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
