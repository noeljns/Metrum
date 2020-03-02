//
//  WarningScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 18.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

protocol WarningDelegate: class {
    func exitWarning()
    func closeWarning()
}

class Warning: SKSpriteNode {
    weak var delegate: WarningDelegate?
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        name = "warning"
        zPosition = 5000
        
        let background = SKSpriteNode(color: .white, size: self.size)
        background.zPosition = 1
        background.drawBorder(color: .gray, width: 5)
        addChild(background)
        
        let headerLabel = SKLabelNode(text: "Achtung!")
        headerLabel.fontColor = SKColor.black
        headerLabel.fontSize = 50
        headerLabel.position = CGPoint(x: frame.midX-10 , y: frame.midY+170)
        headerLabel.zPosition = 4
        addChild(headerLabel)
 
        let warningLabel = SKLabelNode()
        warningLabel.fontColor = SKColor.black
        warningLabel.text = "Bist du dir sicher, dass du abbrechen willst?\n\n" +
        "Alle Fortschritte in diesem Level werden verloren gehen."
        warningLabel.fontSize = 40
        warningLabel.position = CGPoint(x: frame.midX , y: frame.midY-100)
        // break line: https://forums.developer.apple.com/thread/82994
        warningLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        warningLabel.numberOfLines = 0
        warningLabel.preferredMaxLayoutWidth = 470
        warningLabel.zPosition = 2
        addChild(warningLabel)
        
        let exitButtonFrame = SKSpriteNode(color: .orange, size: CGSize(width: 180, height: 55))
        exitButtonFrame.position = CGPoint(x: frame.midX+200, y: frame.midY-170)
        exitButtonFrame.zPosition = 4
        addChild(exitButtonFrame)
        let exitButton = SKLabelNode(text: "Level abbrechen")
        exitButton.name = "exit"
        exitButton.fontSize = 25
        exitButton.fontColor = SKColor.white
        exitButton.position = CGPoint(x: frame.midX, y: frame.midY-15)
        exitButton.zPosition = 5
        exitButton.addStroke(color: .white, width: 6.0)
        exitButtonFrame.addChild(exitButton)
        
        let closeButtonFrame = SKSpriteNode(color: .orange, size: CGSize(width: 180, height: 55))
        closeButtonFrame.position = CGPoint(x: frame.midX-200, y: frame.midY-170)
        closeButtonFrame.zPosition = 4
        addChild(closeButtonFrame)
        let closeButton = SKLabelNode(text: "Level fortführen")
        closeButton.name = "close"
        closeButton.fontSize = 25
        closeButton.fontColor = SKColor.white
        closeButton.position = CGPoint(x: frame.midX, y: frame.midY-15)
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
        if (touchedNode.name == "exit") {
            exit()
        }
        if (touchedNode.name == "close") {
            close()
        }
    }
    
    func exit() {
        self.delegate?.exitWarning()
    }
    func close() {
        self.delegate?.closeWarning()
    }
}
