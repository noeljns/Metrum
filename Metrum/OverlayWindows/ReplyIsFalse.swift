//
//  ReplyIsIncorrect.swift
//  Metrum
//
//  Created by Jonas Jonas on 15.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

protocol ReplyIsFalseDelegate: class {
    func closeReplyIsFalse()
}

// layover windows: https://stackoverflow.com/questions/46954696/save-state-of-gamescene-through-transitions
class ReplyIsFalse: SKSpriteNode {
    weak var delegate: ReplyIsFalseDelegate?
    let textLabel = SKLabelNode()

    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        name = "replyIsFalse"
        zPosition = 5000
        
        let background = SKSpriteNode(color: .white, size: self.size)
        background.zPosition = 1
        background.position = CGPoint(x: frame.midX, y: frame.midY-323)
        background.drawBorder(color: .red, width: 5)
        addChild(background)
        
        // break line: https://forums.developer.apple.com/thread/82994
        textLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        textLabel.numberOfLines = 0
        textLabel.preferredMaxLayoutWidth = 520
        textLabel.fontColor = SKColor.black
        textLabel.fontSize = 40
        textLabel.position = CGPoint(x: frame.midX-10 , y: frame.midY-340)
        textLabel.zPosition = 4
        addChild(textLabel)
        
        let closeButtonFrame = SKSpriteNode(color: .red, size: CGSize(width: 150, height: 55))
        closeButtonFrame.name = "closeButtonFrame"
        closeButtonFrame.position = CGPoint(x: frame.midX+250, y: frame.midY-420)
        closeButtonFrame.zPosition = 4
        addChild(closeButtonFrame)
        let closeButton = SKLabelNode(text: "Weiter")
        closeButton.name = "closeButton"
        closeButton.fontColor = SKColor.white
        closeButton.position = CGPoint(x: frame.midX, y: frame.midY-15)
        closeButton.zPosition = 5
        closeButton.addStroke(color: .white, width: 6.0)
        closeButtonFrame.addChild(closeButton)
    }
    
    func addSolutionToText(solution: String) {
        textLabel.text = "Das war leider falsch. \nRichtig ist: \n" + solution // + "\n\n" +
        // "Tipp: Im Deutschen wird meistens die erste Silbe von Worten betont."
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
        if (touchedNode.name == "closeButton") || (touchedNode.name == "closeButtonFrame") {
            close()
        }
    }
    
    func close() {
        self.delegate?.closeReplyIsFalse()
    }
}
