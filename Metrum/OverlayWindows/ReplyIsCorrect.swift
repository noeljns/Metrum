//
//  SolutionIsCorrect.swift
//  Metrum
//
//  Created by Jonas Jonas on 13.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

protocol ReplyIsCorrectDelegate: class {
    func closeReplyIsCorrect()
}

// layover windows: https://stackoverflow.com/questions/46954696/save-state-of-gamescene-through-transitions
class ReplyIsCorrect: SKSpriteNode {
    weak var delegate: ReplyIsCorrectDelegate?
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        name = "replyIsCorrect"
        zPosition = 5000
   
        let background = SKSpriteNode(color: .white, size: self.size)
        background.zPosition = 1
        background.position = CGPoint(x: 0, y: -335)
        background.drawBorder(color: .green, width: 5)
        addChild(background)
  
        let textLabel = SKLabelNode(text: "Super! Die Lösung ist korrekt.")
        textLabel.fontColor = SKColor.black
        textLabel.fontSize = 40
        textLabel.position = CGPoint(x: frame.midX-10 , y: frame.midY-300)
        textLabel.zPosition = 4
        addChild(textLabel)
                        
        let closeButtonFrame = SKSpriteNode(color: .green, size: CGSize(width: 150, height: 55))
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
        self.delegate?.closeReplyIsCorrect()
    }
}
