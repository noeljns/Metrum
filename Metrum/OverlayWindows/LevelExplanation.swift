//
//  LevelExplanation.swift
//  Metrum
//
//  Created by Jonas Jonas on 22.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

protocol LevelExplanationDelegate: class {
    func closeLevelExplanation()
}

class LevelExplanation: SKSpriteNode {
    var levelExplanations = ["level1": "In Level 1 findest du heraus, welche Silben eines Wortes betont werden und welche nicht.",
                             "level2": "Teste dein Wissen über die Betonung von Worten.",
                             "level3": "In Level 2 übst du, die betonten und unbetonten Silben eines Verses zu bestimmen.",
                             "level4": "Zeige, was du über die Betonung von Versen gelernt hast.",
                             "level5": "In Level 3 entdeckst du die vier wichtigsten Versmetriken.",
                             "level6": "Teste dein Wissen über Versmetriken.",
                             "level7": "In Level 4 erkundest du das Versmaß eines Wortes.",
                             "level8": "Zeige, was du über Versmetriken von Worten gelernt hast.",
                             "level9": "In Level 5 geht es darum, das Versmaß eines ganzen Verses zu bestimmen.",
                             "level10": "Teste dein Wissen über das Metrum von Versen."]
    let explanationLabel = SKLabelNode()
    weak var delegate: LevelExplanationDelegate?
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        name = "levelExplanation"
        zPosition = 5000
        
        let background = SKSpriteNode(color: .white, size: self.size)
        background.zPosition = 1
        background.drawBorder(color: .orange, width: 5)
        addChild(background)
        
        explanationLabel.fontColor = SKColor.black
        explanationLabel.fontSize = 30
        explanationLabel.position = CGPoint(x: frame.midX , y: frame.midY-30)
        explanationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        explanationLabel.numberOfLines = 0
        explanationLabel.preferredMaxLayoutWidth = 480
        explanationLabel.zPosition = 2
        addChild(explanationLabel)
        
        let exitButtonFrame = SKSpriteNode(color: .orange, size: CGSize(width: 100, height: 55))
        exitButtonFrame.name = "exitButtonFrame"
        exitButtonFrame.position = CGPoint(x: frame.midX+160, y: frame.midY-70)
        exitButtonFrame.zPosition = 4
        addChild(exitButtonFrame)
        let exitButton = SKLabelNode(text: "Ok")
        exitButton.name = "exitButton"
        exitButton.fontSize = 25
        exitButton.fontColor = SKColor.white
        exitButton.position = CGPoint(x: frame.midX, y: frame.midY-10)
        exitButton.zPosition = 5
        exitButton.addStroke(color: .white, width: 6.0)
        exitButtonFrame.addChild(exitButton)
    }
    
    func setLevelExplanationText(levelIndex: String) {
        explanationLabel.text = levelExplanations[levelIndex]
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
        if (touchedNode.name == "exitButton") || (touchedNode.name == "exitButtonFrame"){
            close()
        }
    }
    
    func close() {
        self.delegate?.closeLevelExplanation()
    }
}
