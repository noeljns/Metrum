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
    private var closeButton: SKSpriteNode!
    weak var delegate: ReplyIsCorrectDelegate?
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        name = "solutionIsCorrect"
   
        let background = SKSpriteNode(color: .white, size: self.size)
        background.zPosition = 1
        background.position = CGPoint(x: frame.midX, y: frame.midY-323)
        background.drawBorder(color: .green, width: 5)
        addChild(background)
  
        let textLabel = SKLabelNode(text: "Super! Die Lösung ist korrekt.")
        textLabel.fontColor = SKColor.black
        textLabel.fontSize = 50
        textLabel.position = CGPoint(x: frame.midX-10 , y: frame.midY-260)
        textLabel.zPosition = 4
        addChild(textLabel)
                
        closeButton = SKSpriteNode(texture: SKTexture(imageNamed: "bereit"))
        closeButton.name = "close"
        closeButton.position = CGPoint(x: frame.midX+200, y: frame.midY-350)
        closeButton.size = CGSize(width: 175, height: 50)
        closeButton.zPosition = 5
        // not working
        // TODO: bei IPhone war der irgendwo rechts unten zu sehen außerhalb des Screens
        // closeButton.drawBorder(color: .yellow, width: 5)
        addChild(closeButton)
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
        self.delegate?.closeReplyIsCorrect()
    }
}
