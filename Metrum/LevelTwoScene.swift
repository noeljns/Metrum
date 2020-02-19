//
//  LevelTwoScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 10.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import UIKit
import SpriteKit

class LevelTwoScene: SKScene {
    // examples of input data
    // https://stackoverflow.com/questions/45423321/cannot-use-instance-member-within-property-initializer#comment101019582_45423454
    lazy var freu = Syllable(syllableString: "Freu", accentuation: Accentuation.stressed)
    lazy var de = Syllable(syllableString: "de", accentuation: Accentuation.unstressed)
    lazy var freude = Word(syllables: [freu, de])
    lazy var schoe = Syllable(syllableString: "schoe", accentuation: Accentuation.stressed)
    lazy var ner = Syllable(syllableString: "ner", accentuation: Accentuation.unstressed)
    lazy var schoener = Word(syllables: [schoe, ner])
    lazy var goe = Syllable(syllableString: "Goe", accentuation: Accentuation.stressed)
    lazy var tter = Syllable(syllableString: "tter", accentuation: Accentuation.unstressed)
    lazy var fun = Syllable(syllableString: "fun", accentuation: Accentuation.stressed)
    lazy var ken = Syllable(syllableString: "tter", accentuation: Accentuation.unstressed)
    lazy var goetterfunken = Word(syllables: [goe, tter, fun, ken])
    lazy var lineOne = Line(words: [freude, schoener, goetterfunken], measure: Measure.trochaeus, audioFile: "lineOne.mp3")
    
    lazy var er = Syllable(syllableString: "Er", accentuation: Accentuation.unstressed)
    lazy var satz = Syllable(syllableString: "satz", accentuation: Accentuation.stressed)
    lazy var ersatz = Word(syllables: [er, satz])
    lazy var lineTwo = Line(words: [ersatz], measure: Measure.jambus, audioFile: "Ersatz.mp3")
    
    lazy var ver = Syllable(syllableString: "Ver", accentuation: Accentuation.unstressed)
    lazy var stand = Syllable(syllableString: "stand", accentuation: Accentuation.stressed)
    lazy var verstand = Word(syllables: [ver, stand])
    lazy var lineThree = Line(words: [verstand], measure: Measure.jambus, audioFile: "Verstand.mp3")
    
    lazy var le = Syllable(syllableString: "Le", accentuation: Accentuation.stressed)
    lazy var sung = Syllable(syllableString: "sung", accentuation: Accentuation.unstressed)
    lazy var lesung = Word(syllables: [le, sung])
    lazy var lineFour = Line(words: [lesung], measure: Measure.trochaeus, audioFile: "Lesung.mp3")
    
    lazy var fla = Syllable(syllableString: "Fla", accentuation: Accentuation.stressed)
    lazy var sche = Syllable(syllableString: "sche", accentuation: Accentuation.unstressed)
    lazy var flasche = Word(syllables: [fla, sche])
    lazy var lineFive = Line(words: [flasche], measure: Measure.trochaeus, audioFile: "Flasche.mp3")
    
    lazy var zau = Syllable(syllableString: "Zau", accentuation: Accentuation.unstressed)
    lazy var be = Syllable(syllableString: "be", accentuation: Accentuation.unstressed)
    lazy var rei = Syllable(syllableString: "rei", accentuation: Accentuation.stressed)
    lazy var zauberei = Word(syllables: [zau, be, rei])
    lazy var lineSix = Line(words: [zauberei], measure: Measure.anapaest, audioFile: "Zauberei.mp3")
    
    lazy var har = Syllable(syllableString: "Har", accentuation: Accentuation.unstressed)
    lazy var mo = Syllable(syllableString: "mo", accentuation: Accentuation.unstressed)
    lazy var nie = Syllable(syllableString: "nie", accentuation: Accentuation.stressed)
    lazy var harmonie = Word(syllables: [har, mo, nie])
    lazy var lineSeven = Line(words: [harmonie], measure: Measure.anapaest, audioFile: "Harmonie.mp3")
    
    lazy var ei = Syllable(syllableString: "Ei", accentuation: Accentuation.stressed)
    lazy var tel = Syllable(syllableString: "tel", accentuation: Accentuation.unstressed)
    lazy var keit = Syllable(syllableString: "keit", accentuation: Accentuation.unstressed)
    lazy var eitelkeit = Word(syllables: [ei, tel, keit])
    lazy var lineEight = Line(words: [eitelkeit], measure: Measure.daktylus, audioFile: "Eitelkeit.mp3")
    
    lazy var ach = Syllable(syllableString: "Ach", accentuation: Accentuation.stressed)
    lazy var ter = Syllable(syllableString: "ter", accentuation: Accentuation.unstressed)
    lazy var bahn = Syllable(syllableString: "bahn", accentuation: Accentuation.unstressed)
    lazy var achterbahn = Word(syllables: [ach, ter, bahn])
    lazy var lineNine = Line(words: [achterbahn], measure: Measure.daktylus, audioFile: "Achterbahn.mp3")
    
    private var exitLabel = SKLabelNode()
    private var loadingBar = SKSpriteNode()
    
    // https://tutorials.tinyappco.com/SwiftGames/DragDrop
    let wordToBeRated = SKLabelNode()
    
    let jambus = SKLabelNode()
    let jambusBin = SKSpriteNode()
    let trochaeus = SKLabelNode()
    let trochaeusBin = SKSpriteNode()
    let daktylus = SKLabelNode()
    let daktylusBin = SKSpriteNode()
    let anapaest = SKLabelNode()
    let anapaestBin = SKSpriteNode()
    
    var counter = 0
    
    let score = SKLabelNode()
    
    // old data model
//     let selection = [("jambus", "Ersatz"), ("jambus", "Verstand"),
//                     ("trochaeus", "Lesung"), ("trochaeus", "Funken"),
//                     ("anapaest", "Zauberei"), ("anapaest", "Harmonie"),
//                     ("daktylus", "Eitelkeit"), ("daktylus", "Achterbahn")]
    // new data model
    lazy var selection = [lineTwo, lineThree, lineFour, lineFive, lineSix, lineSeven, lineEight, lineNine]
    
    
    let colorizeGreen = SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0.1)
    let colorizeRed = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0.1)
    let colorizeLightGray = SKAction.colorize(with: UIColor.lightGray, colorBlendFactor: 1, duration: 0.2)
    
    func setupDragLabel() {
        // set the font and position of the label
        wordToBeRated.fontColor = SKColor.black
        wordToBeRated.fontSize = 30
        wordToBeRated.position = CGPoint(x: frame.midX, y: frame.midY)
        
        // get random element of selection
        let picked = selection.randomElement()
        wordToBeRated.text = picked!.line
        wordToBeRated.name = picked!.measure.rawValue
        
        // add the label to the scene
        wordToBeRated.zPosition = 3
        addChild(wordToBeRated)
    }
    
    // create the target drop zones / bins
    func setupTargets() {
        exitLabel.name = "exit"
        exitLabel.fontColor = SKColor.black
        exitLabel.text = "x"
        exitLabel.fontSize = 60
        exitLabel.position = CGPoint(x: frame.midX-330, y: frame.midY+435)
        exitLabel.zPosition = 2
        addChild(exitLabel)
        
        loadingBar = SKSpriteNode(imageNamed: "loadingBarOne")
        loadingBar.position = CGPoint(x: frame.midX , y: frame.midY+450)
        loadingBar.size = CGSize(width: 600, height: 35)
        loadingBar.zPosition = 3
        addChild(loadingBar)
        
        // setup the yellow bin with colour, dimensions and add to scene
        jambus.text = "Jambus: Ge·spenst 👻"
        jambus.fontName = "HelveticaBold"
        jambus.fontColor = SKColor.black
        jambus.fontSize = 25
        jambus.position = CGPoint(x: -200, y: 280)
        jambus.zPosition = 2
        addChild(jambus)
        jambusBin.color = SKColor.lightGray
        jambusBin.size = CGSize(width: 250, height: 250)
        jambusBin.position = CGPoint(x: -200, y: 200)
        jambusBin.zPosition = 1
        addChild(jambusBin)
        
        trochaeus.text = "Trochäus: So·nne ☀️"
        trochaeus.fontName = "HelveticaBold"
        trochaeus.fontColor = SKColor.black
        trochaeus.fontSize = 25
        trochaeus.position = CGPoint(x: 200, y: 280)
        trochaeus.zPosition = 2
        addChild(trochaeus)
        trochaeusBin.color = SKColor.lightGray
        trochaeusBin.drawBorder(color: .yellow, width: 5)
        trochaeusBin.size = CGSize(width: 250, height: 250)
        trochaeusBin.position = CGPoint(x: 200, y: 200)
        trochaeusBin.zPosition = 1
        addChild(trochaeusBin)
        
        anapaest.text = "Anapäst: E·le·fant 🐘"
        anapaest.fontName = "HelveticaBold"
        anapaest.fontColor = SKColor.black
        anapaest.fontSize = 25
        anapaest.position = CGPoint(x: -200, y: -120)
        anapaest.zPosition = 2
        addChild(anapaest)
        anapaestBin.color = SKColor.lightGray
        anapaestBin.drawBorder(color: .yellow, width: 5)
        anapaestBin.size = CGSize(width: 250, height: 250)
        anapaestBin.position = CGPoint(x: -200, y: -200)
        anapaestBin.zPosition = 1
        addChild(anapaestBin)
        
        daktylus.text = "Daktylus: Bro·kko·li 🥦"
        daktylus.fontName = "HelveticaBold"
        daktylus.fontColor = SKColor.black
        daktylus.fontSize = 25
        daktylus.position = CGPoint(x: 200, y: -120)
        daktylus.zPosition = 2
        addChild(daktylus)
        daktylusBin.color = SKColor.lightGray
        daktylusBin.drawBorder(color: .yellow, width: 5)
        daktylusBin.size = CGSize(width: 250, height: 250)
        daktylusBin.position = CGPoint(x: 200, y: -200)
        daktylusBin.zPosition = 1
        addChild(daktylusBin)
    }
    
    override func didMove(to view: SKView) {
        setupDragLabel()
        setupTargets()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get a touch
        let touch = touches.first!
        
        // if it started in the label, move it to the new location
        if wordToBeRated.frame.contains(touch.previousLocation(in: self)) {
            wordToBeRated.position = touch.location(in: self)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // https://code.tutsplus.com/tutorials/spritekit-basics-nodes--cms-28785
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if (touchedNode.name == "exit") {
            // https://stackoverflow.com/questions/46954696/save-state-of-gamescene-through-transitions
            let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
            self.view?.presentScene(mainMenu)
        }
    }
    

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if jambusBin.frame.contains(wordToBeRated.position) {
            // https://www.hackingwithswift.com/example-code/games/how-to-color-an-skspritenode-using-colorblendfactor
            // https://stackoverflow.com/questions/36136665/how-to-animate-a-matrix-changing-the-sprites-one-by-one
            if wordToBeRated.name == Measure.jambus.rawValue {
                counter += 1
                jambusBin.run(SKAction.sequence([colorizeGreen, colorizeLightGray]))
                
                // remove it and create a new label
                wordToBeRated.removeFromParent()
                setupDragLabel()
            }
                // else if wordToBeRated.name == "trochaeus" or "daktylus" or "anapaest"
            else {
                jambusBin.run(SKAction.sequence([colorizeRed, colorizeLightGray]))
                wordToBeRated.position = CGPoint(x: frame.midX, y: frame.midY)
            }
        }
        
        if trochaeusBin.frame.contains(wordToBeRated.position) {
            if wordToBeRated.name == Measure.trochaeus.rawValue {
                counter += 1
                trochaeusBin.run(SKAction.sequence([colorizeGreen, colorizeLightGray]))
                
                // remove it and create a new label
                wordToBeRated.removeFromParent()
                setupDragLabel()
            } else {
                trochaeusBin.run(SKAction.sequence([colorizeRed, colorizeLightGray]))
                wordToBeRated.position = CGPoint(x: frame.midX, y: frame.midY)
            }
        }
        
        if daktylusBin.frame.contains(wordToBeRated.position) {
            if wordToBeRated.name == Measure.daktylus.rawValue {
                counter += 1
                daktylusBin.run(SKAction.sequence([colorizeGreen, colorizeLightGray]))
                
                // remove it and create a new label
                wordToBeRated.removeFromParent()
                setupDragLabel()
            } else {
                daktylusBin.run(SKAction.sequence([colorizeRed, colorizeLightGray]))
                wordToBeRated.position = CGPoint(x: frame.midX, y: frame.midY)
            }
        }
        
        if anapaestBin.frame.contains(wordToBeRated.position) {
            if wordToBeRated.name == Measure.anapaest.rawValue {
                counter += 1
                anapaestBin.run(SKAction.sequence([colorizeGreen, colorizeLightGray]))
                
                // remove it and create a new label
                wordToBeRated.removeFromParent()
                setupDragLabel()
            } else {
                anapaestBin.run(SKAction.sequence([colorizeRed, colorizeLightGray]))
                wordToBeRated.position = CGPoint(x: frame.midX, y: frame.midY)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
