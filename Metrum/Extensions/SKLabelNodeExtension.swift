//
//  SKLabelNodeExtension.swift
//  Metrum
//
//  Created by Jonas Jonas on 28.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

// https://living-sun.com/swift/825957-sklabelnode-border-and-bounds-issue-swift-text-sprite-kit-border-sklabelnode.html
extension SKLabelNode {
    
    func addStroke(color:UIColor, width: CGFloat) {
        guard let labelText = self.text else { return }
        
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
