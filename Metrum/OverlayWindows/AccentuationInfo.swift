//
//  AccentuationInfo.swift
//  Metrum
//
//  Created by Jonas Jonas on 07.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

protocol AccentuationInfoDelegate: class {
    func closeAccentuationInfo()
}

// layover windows: https://stackoverflow.com/questions/46954696/save-state-of-gamescene-through-transitions
class AccentuationInfo: SKSpriteNode {
    weak var delegate: AccentuationInfoDelegate?
    private var exampleWordLabel = SKLabelNode()
    private var exampleWordBoldLabel = SKLabelNode()
    
    func generateExampleWord() {
        let soundBoxButton = SKSpriteNode(imageNamed: "QuickActions_Audio")
        soundBoxButton.name = "soundBoxBtn"
        soundBoxButton.position = CGPoint(x: frame.midX+120 , y: frame.midY-140)
        soundBoxButton.size = CGSize(width: 40, height: 40)
        soundBoxButton.zPosition = 2
        addChild(soundBoxButton)
        
        let accentBinOne = SKSpriteNode()
        accentBinOne.color = SKColor.lightGray
        accentBinOne.size = CGSize(width: 40, height: 50)
        accentBinOne.position = CGPoint(x: frame.midX-50, y: frame.midY-195)
        accentBinOne.zPosition = 2
        accentBinOne.drawBorder(color: .orange, width: 4)
        let stressMarkOne = SKLabelNode()
        stressMarkOne.fontColor = SKColor.black
        stressMarkOne.fontSize = 40
        stressMarkOne.zPosition = 2
        stressMarkOne.position = CGPoint(x: -accentBinOne.frame.width/4+10, y: -accentBinOne.frame.height/4)
        stressMarkOne.addStroke(color: .black, width: 6)
        stressMarkOne.text = "x́"
        accentBinOne.addChild(stressMarkOne)
        addChild(accentBinOne)
        
        let accentBinTwo = SKSpriteNode()
        accentBinTwo.color = SKColor.lightGray
        accentBinTwo.size = CGSize(width: 40, height: 50)
        accentBinTwo.position = CGPoint(x: frame.midX+50, y: frame.midY-195)
        accentBinTwo.zPosition = 2
        accentBinTwo.drawBorder(color: .orange, width: 4)
        let stressMarkTwo = SKLabelNode()
        stressMarkTwo.fontColor = SKColor.black
        stressMarkTwo.fontSize = 40
        stressMarkTwo.zPosition = 2
        stressMarkTwo.position = CGPoint(x: -accentBinOne.frame.width/4+10, y: -accentBinOne.frame.height/4)
        stressMarkTwo.addStroke(color: .black, width: 6)
        stressMarkTwo.text = "x"
        accentBinTwo.addChild(stressMarkTwo)
        addChild(accentBinTwo)
        
        let exampleWord = NSMutableAttributedString()
        exampleWord.append(makeAttributedString(stringToBeMutated: "Tor·ben", shallBecomeBold: false))
        exampleWordLabel.attributedText = exampleWord
        exampleWordLabel.fontColor = SKColor.black
        exampleWordLabel.position = CGPoint(x: frame.midX, y: frame.midY-270)
        exampleWordLabel.zPosition = 2
        addChild(exampleWordLabel)
        
        let exampleWordBold = NSMutableAttributedString()
        exampleWordBold.append(makeAttributedString(stringToBeMutated: "Tor·", shallBecomeBold: true))
        exampleWordBold.append(makeAttributedString(stringToBeMutated: "ben", shallBecomeBold: false))
        exampleWordBoldLabel.attributedText = exampleWordBold
        exampleWordBoldLabel.fontColor = SKColor.black
        exampleWordBoldLabel.position = CGPoint(x: frame.midX, y: frame.midY-270)
        exampleWordBoldLabel.zPosition = 2
        // addChild(exampleWordBoldLabel)
    }
    
    
    func makeAttributedString(stringToBeMutated: String, shallBecomeBold: Bool) -> NSMutableAttributedString {
        if(shallBecomeBold) {
            let bold = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 50)]
            let attributedString =  NSMutableAttributedString(string:stringToBeMutated, attributes:bold)
            return attributedString
        }
        else {
            let notBold = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 50)]
            let normalString = NSMutableAttributedString(string:stringToBeMutated, attributes: notBold)
            return normalString
        }
    }
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        name = "accentuationInfo"
        
        let background = SKSpriteNode(color: .white, size: self.size)
        background.zPosition = 1
        background.drawBorder(color: .lightGray, width: 5)
        addChild(background)
        
        let headerLabel = SKLabelNode(text: "Merke")
        headerLabel.fontColor = SKColor.black
        headerLabel.fontSize = 50
        headerLabel.position = CGPoint(x: frame.midX-10 , y: frame.midY+340)
        headerLabel.zPosition = 4
        addChild(headerLabel)
 
        let explanationLabel = SKLabelNode(text: "test")
        explanationLabel.fontColor = SKColor.black
        explanationLabel.text = "Jedes Wort besteht aus einer oder mehreren Silben. Diese können betont (x́) oder unbetont (x) sein.\n\n" +
            "Der Name Torben besteht zum Beispiel aus zwei Silben: Tor·ben.\n" +
            "Die erste Silbe ist betont (x́) und die zweite Silbe ist unbetont (x).\n\n" +
            "Klicke auf den Lautsprecher und die betonte Silbe erscheint fett markiert."
        explanationLabel.position = CGPoint(x: frame.midX , y: frame.midY-110)
        // break line: https://forums.developer.apple.com/thread/82994
        explanationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        explanationLabel.numberOfLines = 0
        explanationLabel.preferredMaxLayoutWidth = 500
        explanationLabel.zPosition = 2
        addChild(explanationLabel)
        
        generateExampleWord()
        
        // let colorCloseButtonFrame = UIColor(hue: 0.9611, saturation: 0.93, brightness: 1, alpha: 1.0) /* #ff1149 */
        // let closeButtonFrame = SKSpriteNode(color: colorCloseButtonFrame, size: CGSize(width: 180, height: 55))
        let closeButtonFrame = SKSpriteNode(color: .orange, size: CGSize(width: 150, height: 55))
        closeButtonFrame.position = CGPoint(x: frame.midX+200, y: frame.midY-350)
        closeButtonFrame.zPosition = 4
        addChild(closeButtonFrame)      
        let closeButton = SKLabelNode(text: "Bereit")
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
    
    /// Relevant for sound button.
    /// Runs an action that adds a node to the scene and removes it after some seconds.
    /// Duration of action is longer in higher levels.
    ///
    /// - Parameters:
    ///   - node: Node that should be added to and removed from the scene.
    func addAndRemoveNode(node: SKLabelNode) {
        let duration = 1.5
        
        addChild(node)
        node.run(SKAction.sequence([
            SKAction.wait(forDuration: duration),
            SKAction.removeFromParent(),
            ])
        )
    }
    
    /// Relevant for sound button.
    /// Runs an action that hides a node frome the scene and unhides it after some seconds.
    /// Duration of action is longer in higher levels.
    ///
    /// - Parameters:
    ///   - node: Node that should be added to and removed from the scene.
    func hideAndUnhideNode(node: SKLabelNode) {
        let duration = 1.5
        
        node.run(SKAction.sequence([
            SKAction.hide(),
            SKAction.wait(forDuration: duration),
            SKAction.unhide()
            ])
        )
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
        
        if(touchedNode.name == "soundBoxBtn") {
            let playSound = SKAction.playSoundFileNamed("Torben.mp3", waitForCompletion: false)
            let action =  SKAction.group([playSound,
                                          SKAction.run{self.addAndRemoveNode(node: self.exampleWordBoldLabel)},
                                          SKAction.run{self.hideAndUnhideNode(node: self.exampleWordLabel)}])
            self.run(action)
        }
        
        if (touchedNode.name == "close") {
            close()
        }
    }
    
    func close() {
        self.delegate?.closeAccentuationInfo()
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
}
