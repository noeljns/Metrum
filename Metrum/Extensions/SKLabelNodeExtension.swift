//
//  SKLabelNodeExtension.swift
//  Metrum
//
//  Created by Jonas Zwink on 28.02.20.
//  Copyright © 2020 Jonas Zwink. All rights reserved.
//

import SpriteKit

extension SKLabelNode {
    /// Adds stroke to label in specified color and width
    ///
    /// - Parameters:
    ///   - color: color for the label to be drawn
    ///   - width: width for the label to be drawn
    func addStroke(color:UIColor, width: CGFloat) {
        guard let labelText = self.text else {
            return
        }
        
        let font = UIFont(name: self.fontName!, size: self.fontSize)
        
        let attributedString:NSMutableAttributedString
        if let labelAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        }
        else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        let attributes:[NSAttributedString.Key:Any] = [.strokeColor: color, .strokeWidth: -width, .font: font!, .foregroundColor: self.fontColor!]
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
