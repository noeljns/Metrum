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

// layover windows: https://stackoverflow.com/questions/46954696/save-state-of-gamescene-through-transitions
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
        
        let headerLabel = SKLabelNode(text: "Willkommen!")
        headerLabel.fontColor = SKColor.black
        headerLabel.fontSize = 50
        headerLabel.position = CGPoint(x: frame.midX-10 , y: frame.midY+340)
        headerLabel.zPosition = 4
        addChild(headerLabel)
        
        let explanationLabel = SKLabelNode(text: "test")
        explanationLabel.fontColor = SKColor.black
        explanationLabel.text = "Herzlichen Willkommen in der Lernapp Metrum. Hier kannst du in verschiedenen Leveln üben, das Metrum von Gedichtversen zu bestimmen.\n\n" +
            "Am Anfang lernst du, betonte von unbetonten Silben von Worten und Versen zu unterscheiden. Danach lernst du die vier wichtigsten Metriken kennen. In den finalen Leveln bist du dann bereit, das Metrum von Worten und Versen zu bestimmen.\n\n" + "Viel Spaß!"
        explanationLabel.position = CGPoint(x: frame.midX , y: frame.midY-270)
        // break line: https://forums.developer.apple.com/thread/82994
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
        self.delegate?.closeSalutation()
    }
}

extension SKSpriteNode {
    // https://stackoverflow.com/questions/20889222/can-i-add-a-border-to-an-skspritenode-similar-to-uiview
    func drawBorder(color: UIColor, width: CGFloat) {
        let shapeNode = SKShapeNode(rectOf: size)
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = color
        shapeNode.lineWidth = width
        addChild(shapeNode)
    }
    
    /// Returns String as NSMutableAttributedString and when indicated in bold.
    ///
    /// - Parameters:
    ///   - stringToBeMutated: The String which should be returnded.
    ///   - shallBecomceBold: This Boolean says whether String shall be bold or not.
    ///   - size: Size of the String
    /// - Returns: The String as NSMutableAttributedString.
    func makeAttributedString(stringToBeMutated: String, shallBecomeBold: Bool, size: CGFloat) -> NSMutableAttributedString {
        if(shallBecomeBold) {
            let bold = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: size)]
            let attributedString =  NSMutableAttributedString(string:stringToBeMutated, attributes:bold as [NSAttributedString.Key : Any])
            return attributedString
        }
        else {
            let notBold = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-UltraLight", size: size)]
            let normalString = NSMutableAttributedString(string:stringToBeMutated, attributes: notBold as [NSAttributedString.Key : Any])
            return normalString
        }
    }
}
