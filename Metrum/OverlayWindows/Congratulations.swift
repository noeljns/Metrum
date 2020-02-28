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
    
    // https://gist.github.com/mihailt/d793236f31f0b8f8722e
    func shakeSprite(layer:SKSpriteNode, duration:Float) {
        let position = layer.position
        let amplitudeX:Float = 15
        let amplitudeY:Float = 15
        let numberOfShakes = duration / 0.2
        var actionsArray:[SKAction] = []
        for _ in 1...Int(numberOfShakes) {
            let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2
            let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2
            let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.2)
            shakeAction.timingMode = SKActionTimingMode.easeOut
            actionsArray.append(shakeAction)
            actionsArray.append(shakeAction.reversed())
        }
        
        actionsArray.append(SKAction.move(to: position, duration: 0.0))
        
        let actionSeq = SKAction.sequence(actionsArray)
        // http://spritekitlessons.com/sprite-kit-skactions-example/
        let actionLoop = SKAction.repeatForever(actionSeq)
        layer.run(actionLoop)
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
     
        let explanationLabel = SKLabelNode(text: "test")
        explanationLabel.fontColor = SKColor.black
        explanationLabel.text = "Herzlichen Glückwünsch! Du hast das Level bestanden.\n\n" +              "Weiter geht es im nächsten Level."
        explanationLabel.fontSize = 40
        explanationLabel.position = CGPoint(x: frame.midX , y: frame.midY-200)
        // break line: https://forums.developer.apple.com/thread/82994
        explanationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        explanationLabel.numberOfLines = 0
        explanationLabel.preferredMaxLayoutWidth = 480
        explanationLabel.zPosition = 2
        addChild(explanationLabel)
        
        let closeButtonFrame = SKSpriteNode(color: .orange, size: CGSize(width: 150, height: 55))
        closeButtonFrame.name = "closeButtonFrame"
        closeButtonFrame.position = CGPoint(x: frame.midX+200, y: frame.midY-350)
        closeButtonFrame.zPosition = 4
        addChild(closeButtonFrame)
        
        shakeSprite(layer: trophyButton, duration: 6.0)
        
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
        self.delegate?.closeCongratulations()
    }
}
