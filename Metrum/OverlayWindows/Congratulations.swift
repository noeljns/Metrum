//
//  CongratulationsScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 17.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

protocol CongratulationsDelegate: class {
    func exitCongratulations()
    func closeCongratulations()
}

class Congratulations: SKSpriteNode {
    weak var delegate: CongratulationsDelegate?
    let explanationLabel = SKLabelNode()
    
    /// Sets final explanation text for last level
    func setExplanationLabelForLastLevel() {
        explanationLabel.text = "Großartig, du hast die Lernapp durchgearbeitet.\n\n"
            + "Jetzt bist du ein Metrum Profi. Herzlichen Glückwünsch!"
    }

    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        name = "congratulations"
        zPosition = 5000
        
        let background = SKSpriteNode(color: .white, size: self.size)
        background.zPosition = 1
        background.drawBorder(color: .orange, width: 5)
        addChild(background)
        
        let headerLabel = SKLabelNode(text: "Prima!")
        headerLabel.fontColor = SKColor.black
        headerLabel.fontSize = 50
        headerLabel.position = CGPoint(x: frame.midX-10 , y: frame.midY+300)
        headerLabel.zPosition = 4
        addChild(headerLabel)
        
        let trophyButton = SKSpriteNode(color: .green, size: CGSize(width: 300, height: 300))
        addChild(trophyButton)
        let trophy = SKLabelNode(text: "🏆")
        trophy.fontSize = 140
        trophy.position = CGPoint(x: frame.midX , y: frame.midY+120)
        trophy.zPosition = 4
        trophyButton.addChild(trophy)
        trophyButton.shakeSpriteNode()

        explanationLabel.fontColor = SKColor.black
        explanationLabel.text = "Herzlichen Glückwünsch! Du hast vier Mal richtig geantwortet.\n\n"
            + "Möchtest du über das Hauptmenü zum nächsten Level oder weiter üben?"
        explanationLabel.fontSize = 40
        explanationLabel.position = CGPoint(x: frame.midX , y: frame.midY-200)
        explanationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        explanationLabel.numberOfLines = 0
        explanationLabel.preferredMaxLayoutWidth = 520
        explanationLabel.zPosition = 2
        addChild(explanationLabel)
        
        let exitButtonFrame = SKSpriteNode(color: .orange, size: CGSize(width: 180, height: 55))
        exitButtonFrame.name = "exitButtonFrame"
        exitButtonFrame.position = CGPoint(x: frame.midX+200, y: frame.midY-300)
        exitButtonFrame.zPosition = 4
        addChild(exitButtonFrame)
        let exitButton = SKLabelNode()
        exitButton.text = "Hauptmenü"
        exitButton.name = "exitButton"
        exitButton.fontSize = 25
        exitButton.fontColor = SKColor.white
        exitButton.position = CGPoint(x: frame.midX, y: frame.midY-10)
        exitButton.zPosition = 5
        exitButton.addStroke(color: .white, width: 6.0)
        exitButtonFrame.addChild(exitButton)
        
        let closeButtonFrame = SKSpriteNode(color: .orange, size: CGSize(width: 180, height: 55))
        closeButtonFrame.name = "closeButtonFrame"
        closeButtonFrame.position = CGPoint(x: frame.midX-200, y: frame.midY-300)
        closeButtonFrame.zPosition = 4
        addChild(closeButtonFrame)
        let closeButton = SKLabelNode(text: "Weiter üben")
        closeButton.name = "closeButton"
        closeButton.fontSize = 25
        closeButton.fontColor = SKColor.white
        closeButton.position = CGPoint(x: frame.midX, y: frame.midY-10)
        closeButton.zPosition = 5
        closeButton.addStroke(color: .white, width: 6.0)
        closeButtonFrame.addChild(closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

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
        if (touchedNode.name == "exitButton") || (touchedNode.name == "exitButtonFrame") {
            exit()
        }
        if (touchedNode.name == "closeButton") || (touchedNode.name == "closeButtonFrame") {
            close()
        }
    }
    
    func exit() {
        self.delegate?.exitCongratulations()
    }
    func close() {
        self.delegate?.closeCongratulations()
    }
}

