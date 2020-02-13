//
//  SolutionIsCorrect.swift
//  Metrum
//
//  Created by Jonas Jonas on 13.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

protocol SolutionIsCorrectDelegate: class {
    func closeSolutionIsCorrect()
}

// layover windows: https://stackoverflow.com/questions/46954696/save-state-of-gamescene-through-transitions
class SolutionIsCorrect: SKSpriteNode {
    private var closeButton: SKSpriteNode!
    weak var delegate: SolutionIsCorrectDelegate?
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        name = "solutionIsCorrect"
        
        // brauchen oben und unten background, oben transparent, unten nicht transparent
        // oben (size.height / 4) * 3, unten size.height / 4
        let background = SKSpriteNode(color: .white, size: self.size)
        background.zPosition = 1
        // background.alpha = 0.0
        background.drawBorder(color: .lightGray, width: 5)
        addChild(background)
        
        // background below
        // accentuationInfo = AccentuationInfo(size: CGSize(width: 650, height: 800))

        
        let textLabel = SKLabelNode(text: "Super! Die Lösung ist korrekt.")
        textLabel.fontColor = SKColor.black
        textLabel.fontSize = 50
        textLabel.position = CGPoint(x: frame.midX-10 , y: frame.midY-250)
        textLabel.zPosition = 4
        addChild(textLabel)
                
        closeButton = SKSpriteNode(texture: SKTexture(imageNamed: "bereit"))
        closeButton.name = "close"
        closeButton.position = CGPoint(x: frame.midX+200, y: frame.midY-300)
        closeButton.size = CGSize(width: 175, height: 50)
        closeButton.zPosition = 5
        // not working
        closeButton.drawBorder(color: .yellow, width: 5)
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
        self.delegate?.closeSolutionIsCorrect()
    }
}
