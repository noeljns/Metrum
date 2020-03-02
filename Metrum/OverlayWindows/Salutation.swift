//
//  SalutationScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 21.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

protocol SalutationDelegate: class {
    func closeSalutation()
}

class Salutation: SKSpriteNode {
    weak var delegate: SalutationDelegate?
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        name = "salutation"
        zPosition = 5000

        let background = SKSpriteNode(color: .white, size: self.size)
        background.zPosition = 1
        background.drawBorder(color: .orange, width: 5)
        addChild(background)
        
        let headerLabel = SKLabelNode(text: "Herzlichen Willkommen!")
        headerLabel.fontColor = SKColor.black
        headerLabel.fontSize = 50
        headerLabel.position = CGPoint(x: frame.midX-10 , y: frame.midY+280)
        headerLabel.zPosition = 4
        headerLabel.shakeLabelNode()
        addChild(headerLabel)
        
        let explanationLabel = SKLabelNode()
        explanationLabel.fontColor = SKColor.black
        explanationLabel.text = "In der Lernapp Metrum lernst du in verschiedenen Leveln, das Metrum von Gedichtversen zu bestimmen.\n\n"
            + "»Welche Silben eines Wortes oder eines Verses werden betont und welche nicht?«\n"
        + "»Welchem Metrum kann ein Wort oder ein Vers zugeordnet werden«?\n\n"
            + "Diese Fragen wirst du bald selbst beantworten können! Viel Spaß!"
        explanationLabel.position = CGPoint(x: frame.midX , y: frame.midY-230)
        explanationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        explanationLabel.numberOfLines = 0
        explanationLabel.preferredMaxLayoutWidth = 480
        explanationLabel.zPosition = 2
        addChild(explanationLabel)
        
        // let colorCloseButtonFrame = UIColor(hue: 0.9611, saturation: 0.93, brightness: 1, alpha: 1.0) /* #ff1149 */
        // let closeButtonFrame = SKSpriteNode(color: colorCloseButtonFrame, size: CGSize(width: 180, height: 55))
        let closeButtonFrame = SKSpriteNode(color: .orange, size: CGSize(width: 150, height: 55))
        closeButtonFrame.name = "closeButtonFrame"
        closeButtonFrame.position = CGPoint(x: frame.midX+200, y: frame.midY-350)
        closeButtonFrame.zPosition = 4
        addChild(closeButtonFrame)
        let closeButton = SKLabelNode(text: "Los geht's!")
        closeButton.name = "closeButton"
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
        if (touchedNode.name == "closeButton") || (touchedNode.name == "closeButtonFrame") {
            close()
        }
    }
    
    func close() {
        self.delegate?.closeSalutation()
    }
}
