//
//  MeasureInfo.swift
//  Metrum
//
//  Created by Jonas Jonas on 19.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

protocol MeasureInfoDelegate: class {
    func closeMeasureInfo()
}

// layover windows: https://stackoverflow.com/questions/46954696/save-state-of-gamescene-through-transitions
class MeasureInfo: SKSpriteNode {
    weak var delegate: MeasureInfoDelegate?
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        name = "measureInfo"
        
        let background = SKSpriteNode(color: .white, size: self.size)
        background.zPosition = 1
        background.drawBorder(color: .lightGray, width: 5)
        addChild(background)
        
        let headerLabel = SKLabelNode(text: "Merke")
        headerLabel.fontColor = SKColor.black
        headerLabel.fontSize = 50
        headerLabel.position = CGPoint(x: frame.midX-10 , y: frame.midY+300)
        headerLabel.zPosition = 4
        addChild(headerLabel)
        
        // let info = SKSpriteNode(imageNamed: "info")
        let info = SKSpriteNode(imageNamed: "icons8-info-50")
        info.position = CGPoint(x: frame.midX-150 , y: frame.midY+320)
        info.size = CGSize(width: 50, height: 50)
        info.zPosition = 3
        addChild(info)
        
        let explanationLabel = SKLabelNode(text: "test")
        explanationLabel.fontColor = SKColor.black
        explanationLabel.text = "Die Verse vieler Gedichte haben ein bestimmtes Betonungsmuster. "
            + "Das heißt die betonten (x́) und unbetonten (x) Silben eines Verses wechseln sich in einer festen Reihenfolge ab. "
            + "Diese Abfolge nennt man Versmaß oder Metrum. Die vier wichtigsten Grundtypen sind: \n\n" +
            "   Jambus (x x́)    : Ge·spenst 👻\n" +
            "   Trochäus (x́ x)  : So·nne ☀️\n" +
            "   Anapäst (x x x́) : E·le·fant 🐘\n" +
            "   Daktylus (x́ x x) : Bro·kko·li 🥦"
        explanationLabel.position = CGPoint(x: frame.midX , y: frame.midY-250)
        // break line: https://forums.developer.apple.com/thread/82994
        explanationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        explanationLabel.numberOfLines = 0
        explanationLabel.preferredMaxLayoutWidth = 480
        explanationLabel.zPosition = 2
        addChild(explanationLabel)
        
        // let colorCloseButtonFrame = UIColor(hue: 0.9611, saturation: 0.93, brightness: 1, alpha: 1.0) /* #ff1149 */
        // let closeButtonFrame = SKSpriteNode(color: colorCloseButtonFrame, size: CGSize(width: 180, height: 55))
        let closeButtonFrame = SKSpriteNode(color: .orange, size: CGSize(width: 150, height: 55))
        closeButtonFrame.position = CGPoint(x: frame.midX+200, y: frame.midY-350)
        // closeButtonFrame.drawBorder(color: .orange, width: 5)
        closeButtonFrame.zPosition = 4
        addChild(closeButtonFrame)
        
        let closeButton = SKLabelNode(text: "Bereit")
        closeButton.name = "close"
        closeButton.fontColor = SKColor.white
        closeButton.position = CGPoint(x: frame.midX, y: frame.midY-15)
        closeButton.zPosition = 5
        closeButton.addStroke(color: .white, width: 6.0)
        closeButtonFrame.addChild(closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // fatalError("init(coder:) has not been implemented")
    }
    
    // https://developer.apple.com/documentation/spritekit/sknode/controlling_user_interaction_on_nodes
    override var isUserInteractionEnabled: Bool {
        set {
            // ignore
        }
        get {
            return true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if (touchedNode.name == "close") {
            close()
        }
    }
    
    func close() {
        self.delegate?.closeMeasureInfo()
    }
}
