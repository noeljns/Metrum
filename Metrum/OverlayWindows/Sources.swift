//
//  Sources.swift
//  Metrum
//
//  Created by Jonas Jonas on 23.03.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

protocol SourcesDelegate: class {
    func closeSources()
}

class Sources: SKSpriteNode {
    weak var delegate: SourcesDelegate?
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        name = "source"
        zPosition = 5000
        
        let background = SKSpriteNode(color: .white, size: self.size)
        background.zPosition = 1
        background.drawBorder(color: .lightGray, width: 5)
        addChild(background)
        
        let headerLabel = SKLabelNode(text: "Diese Audiodateien werden in der App verwendet: \n")
        headerLabel.fontColor = SKColor.black
        headerLabel.fontSize = 26
        headerLabel.position = CGPoint(x: frame.midX , y: frame.midY+410)
        headerLabel.zPosition = 4
        addChild(headerLabel)
        
        let sourcesLabel = SKLabelNode()
        sourcesLabel.fontColor = SKColor.black
        sourcesLabel.text = "Lizenziert unter CC BY-SA: \n" +
            "De-Anker.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Anker.ogg \n" +
            "De-Flasche.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Flasche.ogg \n" +
            "De-Zebra.ogg von Kampy, https://de.wiktionary.org/wiki/Datei:De-Zebra.ogg \n" +
            "De-Blume.ogg von T.Voekler, https://de.wiktionary.org/wiki/Datei:De-Blume.ogg \n" +
            "De-Lampe.ogg von Kampy, https://de.wiktionary.org/wiki/Datei:De-Lampe.ogg \n" +
            "De-Messer.ogg von Kampy, https://de.wiktionary.org/wiki/Datei:De-Messer.ogg \n" +
            "De-Verstand.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Verstand.ogg \n" +
            "De-genau.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-genau2.ogg \n" +
            "De-Ersatz.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Ersatz.ogg \n" +
            "De-Regal.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Regal.ogg \n" +
            "De-Gesang.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Gesang.ogg \n" +
            "De-Gestell.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Gestell.ogg \n" +
            "De-kaputt.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-kaputt.ogg \n" +
            "De-Harmonie.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Harmonie.ogg \n" +
            "De-Sinfonie.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Sinfonie.ogg \n" +
            "De-Direktion.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Direktion.ogg \n" +
            "De-Chirurgie.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Chirurgie.ogg \n" +
            "De-Emotion.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Emotion.ogg \n" +
            "De-Fantasie.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Fantasie.ogg \n" +
            "De-Eitelkeit.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Eitelkeit.ogg \n" +
            "De-Achterbahn.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Achterbahn.ogg \n" +
            "De-angespannt.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-angespannt.ogg \n" +
            "De-Finsternis.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Finsternis.ogg \n" +
            "De-Stundenplan.ogg von Jeuwre, https://de.wiktionary.org/wiki/Datei:De-Stundenplan.ogg \n\n" +
            "De-Autobahn.ogg von Starvinmarvin, https://de.wiktionary.org/wiki/Datei:De-Autobahn.ogg, ist lizenziert als gemeinfrei"
        sourcesLabel.position = CGPoint(x: frame.midX , y: frame.midY-340)
        sourcesLabel.fontSize = 19
        sourcesLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        sourcesLabel.numberOfLines = 0
        sourcesLabel.preferredMaxLayoutWidth = 650
        sourcesLabel.zPosition = 2
        addChild(sourcesLabel)
        
        let closeButtonFrame = SKSpriteNode(color: .orange, size: CGSize(width: 150, height: 55))
        closeButtonFrame.name = "closeButtonFrame"
        closeButtonFrame.position = CGPoint(x: frame.midX+250, y: frame.midY-400)
        closeButtonFrame.zPosition = 4
        addChild(closeButtonFrame)
        let closeButton = SKLabelNode(text: "Zurück")
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
                
        if (touchedNode.name == "closeButton") || (touchedNode.name == "closeButtonFrame"){
            close()
        }
    }
    
    func close() {
        self.delegate?.closeSources()
    }
}
