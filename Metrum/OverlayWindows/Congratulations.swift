//
//  CongratulationsScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 17.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

protocol CongratulationsDelegate: class {
    func closeCongratulations()
}

// layover windows: https://stackoverflow.com/questions/46954696/save-state-of-gamescene-through-transitions
class Congratulations: SKSpriteNode {
    weak var delegate: CongratulationsDelegate?
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        name = "congratulations"
        let background = SKSpriteNode(color: .white, size: self.size)
        background.zPosition = 1
        background.drawBorder(color: .orange, width: 5)
        addChild(background)
        
        let headerLabel = SKLabelNode(text: "Prima!")
        headerLabel.fontColor = SKColor.black
        headerLabel.fontSize = 50
        headerLabel.position = CGPoint(x: frame.midX-10 , y: frame.midY+250)
        headerLabel.zPosition = 4
        addChild(headerLabel)
        
        let trophy = SKLabelNode(text: "🏆")
        trophy.fontSize = 140
        trophy.position = CGPoint(x: frame.midX , y: frame.midY+50)
        trophy.zPosition = 4
        addChild(trophy)
     
        let explanationLabel = SKLabelNode(text: "test")
        explanationLabel.fontColor = SKColor.black
        explanationLabel.text = "Herzlichen Glückwünsch! Du hast das Level bestanden.\n\n" +              "Weiter geht es im nächsten Level."
        explanationLabel.fontSize = 40
        explanationLabel.position = CGPoint(x: frame.midX , y: frame.midY-150)
        // break line: https://forums.developer.apple.com/thread/82994
        explanationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        explanationLabel.numberOfLines = 0
        explanationLabel.preferredMaxLayoutWidth = 480
        explanationLabel.zPosition = 2
        addChild(explanationLabel)
        
        let closeButtonFrame = SKSpriteNode(color: .orange, size: CGSize(width: 150, height: 55))
        closeButtonFrame.position = CGPoint(x: frame.midX+200, y: frame.midY-350)
        // closeButtonFrame.drawBorder(color: .orange, width: 5)
        closeButtonFrame.zPosition = 4
        addChild(closeButtonFrame)
        
        let closeButton = SKLabelNode(text: "Weiter")
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
        self.delegate?.closeCongratulations()
    }
}
