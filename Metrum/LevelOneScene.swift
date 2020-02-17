//
//  LevelOneScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 06.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

class LevelOneScene: SKScene {
    // examples of input data
    // https://stackoverflow.com/questions/45423321/cannot-use-instance-member-within-property-initializer#comment101019582_45423454
    lazy var freu = Syllable(syllableString: "Freu", accentuation: Accentuation.stressed)
    lazy var de = Syllable(syllableString: "de", accentuation: Accentuation.unstressed)
    lazy var freude = Word(syllables: [freu, de])
    lazy var schoe = Syllable(syllableString: "schö", accentuation: Accentuation.stressed)
    lazy var ner = Syllable(syllableString: "ner", accentuation: Accentuation.unstressed)
    lazy var schoener = Word(syllables: [schoe, ner])
    lazy var goe = Syllable(syllableString: "Gö", accentuation: Accentuation.stressed)
    lazy var tter = Syllable(syllableString: "tter", accentuation: Accentuation.unstressed)
    lazy var fun = Syllable(syllableString: "fun", accentuation: Accentuation.stressed)
    lazy var ken = Syllable(syllableString: "ken", accentuation: Accentuation.unstressed)
    lazy var goetterfunken = Word(syllables: [goe, tter, fun, ken])
    lazy var lineOne = Line(words: [freude, schoener, goetterfunken], measure: Measure.trochaeus, audioFile: "lineOne.mp3")
    
    lazy var so = Syllable(syllableString: "So", accentuation: Accentuation.stressed)
    lazy var nne = Syllable(syllableString: "nne", accentuation: Accentuation.unstressed)
    lazy var sonne = Word(syllables: [so, nne])
    lazy var lineTwo = Line(words: [sonne], measure: Measure.trochaeus, audioFile: "Sonne.mp3")
    
    lazy var ge = Syllable(syllableString: "Ge", accentuation: Accentuation.unstressed)
    lazy var spenst = Syllable(syllableString: "spenst", accentuation: Accentuation.stressed)
    lazy var gespenst = Word(syllables: [ge, spenst])
    lazy var lineThree = Line(words: [gespenst], measure: Measure.jambus, audioFile: "Gespenst.mp3")
    
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
    
    // variables
    private var exitLabel = SKLabelNode()
    private var loadingBar = SKSpriteNode()
    
    private let taskLabel = SKLabelNode()
    
    private var accentBins = [SKSpriteNode]()
    
    private var wordToBeRated = SKLabelNode()
    private var wordToBeRatedBold = SKLabelNode()
    
    private var stressMarks = [SKSpriteNode]()
    private let stressedParent = SKSpriteNode()
    private let stressed = SKLabelNode()
    private let unstressedParent = SKSpriteNode()
    private let unstressed = SKLabelNode()
    
    private var accentuationInfoButton = SKSpriteNode()
    private var accentuationInfo: AccentuationInfo!
    private var backgroundBlockerAccentuationInfo: SKSpriteNode!
    private var firstEntryOfLevelOne = true
    
    private var replyIsCorrect: ReplyIsCorrect!
    private var backgroundBlockerReplyIsCorrect: SKSpriteNode!
    
    private var replyIsFalse: ReplyIsFalse!
    private var backgroundBlockerReplyIsFalse: SKSpriteNode!
    
    private var congratulations: Congratulations!
    private var backgroundBlockerCongratulations: SKSpriteNode!
    
    private var soundBoxButton = SKSpriteNode()
    private let audioNode = SKNode()
    
    private var checkButton = SKSpriteNode()

    // new data model
    // lazy var selection = [lineOne, lineTwo, lineThree, lineSeven, lineEight]
    // lazy var selection = [lineOne]
    lazy var selection = [lineTwo, lineThree, lineSeven, lineEight]

    lazy var selected = lineOne
    
    // TODO NSUserDataVariable
    

    private var correctRepliesLevelOne = 0
    // TODO nsUserDataVariable
    // private var levelOneIsPassed = false
    private var amountOfCorrectRepliesToPassLevel = 4
    
    func setUpScene() {
        exitLabel.name = "exit"
        exitLabel.fontColor = SKColor.black
        exitLabel.text = "x"
        exitLabel.fontSize = 60
        exitLabel.position = CGPoint(x: frame.midX-330, y: frame.midY+435)
        exitLabel.zPosition = 2
        addChild(exitLabel)
        
        loadingBar = SKSpriteNode(imageNamed: "loadingBar0")
        loadingBar.position = CGPoint(x: frame.midX , y: frame.midY+450)
        loadingBar.size = CGSize(width: 600, height: 35)
        loadingBar.zPosition = 3
        
        manageLoadingBar()
        addChild(loadingBar)
        
        taskLabel.fontColor = SKColor.black
        taskLabel.text = "Markiere die betonten (x́) und unbetonten (x) Silben des Wortes.\n" +
        "Ziehe dafür die Betonungszeichen in das jeweilige Kästchen über der Silbe."
        taskLabel.position = CGPoint(x: frame.midX , y: frame.midY+150)
        // break line: https://forums.developer.apple.com/thread/82994
        taskLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        taskLabel.numberOfLines = 0
        taskLabel.preferredMaxLayoutWidth = 480
        taskLabel.zPosition = 4
        addChild(taskLabel)
        
        accentuationInfoButton = SKSpriteNode(imageNamed: "info")
        accentuationInfoButton.name = "accentuationInfoBtn"
        accentuationInfoButton.position = CGPoint(x: frame.midX+225 , y: frame.midY+120)
        accentuationInfoButton.size = CGSize(width: 50, height: 50)
        accentuationInfoButton.zPosition = 2
        addChild(accentuationInfoButton)
        
        soundBoxButton = SKSpriteNode(imageNamed: "sound")
        soundBoxButton.name = "soundBoxBtn"
        soundBoxButton.position = CGPoint(x: frame.midX+150 , y: frame.midY+120)
        soundBoxButton.size = CGSize(width: 50, height: 50)
        soundBoxButton.zPosition = 2
        addChild(soundBoxButton)
        
        checkButton = SKSpriteNode(imageNamed: "check")
        checkButton.name = "check"
        checkButton.position = CGPoint(x: frame.midX+200, y: frame.midY-300)
        checkButton.size = CGSize(width: 175, height: 50)
        checkButton.zPosition = 2
        // not working
        checkButton.drawBorder(color: .yellow, width: 5)
        addChild(checkButton)
    }
    
    // make three stress marks, one stressed and two unstressed
    func generateStressMarks() {
        // TODO BUG: when two stressMarks collide, one stressMark gets removed
        let stressMarkParentOne = generateAStressMark(stressed: true, x: frame.midX-80, y: frame.midY-150)
        stressMarks.append(stressMarkParentOne)
        let stressMarkParentTwo = generateAStressMark(stressed: false, x: frame.midX, y: frame.midY-150)
        stressMarks.append(stressMarkParentTwo)
        let stressMarkParentThree = generateAStressMark(stressed: false, x: frame.midX+80, y: frame.midY-150)
        stressMarks.append(stressMarkParentThree)
    }
    
    // generate stress marks that are to be placed to syllables
    func generateAStressMark(stressed: Bool, x: CGFloat, y: CGFloat) -> SKSpriteNode {
        let stressMarkParent = SKSpriteNode()
        stressMarkParent.color = .white
        // stressMarkParent.color = .green
        stressMarkParent.size = CGSize(width: 40, height: 50)
        stressMarkParent.position = CGPoint(x: x, y: y)
        stressMarkParent.zPosition = 1
        
        let stressMark = SKLabelNode()
        stressMark.fontColor = SKColor.black
        stressMark.fontSize = 40
        stressMark.zPosition = 2
        stressMark.position = CGPoint(x: -stressMarkParent.frame.width/4+10, y: -stressMarkParent.frame.height/4)
        // TODO higher function
        if stressed {
            stressMark.text = "x́"
            stressMarkParent.name = "stressed"
        }
        else {
            stressMark.text = "x"
            stressMarkParent.name = "unstressed"
        }
        stressMarkParent.addChild(stressMark)
        addChild(stressMarkParent)
        return stressMarkParent
    }
    
    
    // make a gray bin per syllable dynamically positioned right over corresponding syllable
    func generateAccentuationBins(line: Line, wordToBeRated: SKLabelNode) {
        // unit per char: dynamically calculated by frame.width divided by amount of chars
        let amountOfCharsInLine = line.line.count
        let unit = CGFloat(wordToBeRated.frame.width / CGFloat(amountOfCharsInLine))
        var counter = CGFloat(10.0)
        
        for word in line.words {
            for syllable in word.syllables {
                let accentBin = SKSpriteNode()
                accentBin.color = SKColor.lightGray
                accentBin.size = CGSize(width: 40, height: 45)
                
                // half of amount of chars of syllable multiplied by unit plus counter
                let positionOfBin = CGFloat(Double(syllable.syllableString.count)/2.0)*unit + counter
                accentBin.position = CGPoint(x: wordToBeRated.frame.minX+positionOfBin, y: frame.midY+70)
                accentBin.zPosition = 2
                // append to global variable
                accentBins.append(accentBin)

                // counter shifts to the next syllable
                counter += CGFloat(syllable.syllableString.count) * unit
                addChild(accentBin)
            }
            // counter shifts to the next word
            counter += 25
        }
    }
    
    func setUpUnfixedParts() {
        selected = selection.randomElement()!
        
        wordToBeRated.fontColor = SKColor.black
        wordToBeRated.attributedText = makeAttributedString(stringToBeMutated: (selected.line), shallBecomeBold: false)
        wordToBeRated.position = CGPoint(x: frame.midX, y: frame.midY)
        wordToBeRated.zPosition = 2
        addChild(wordToBeRated)

        generateAccentuationBins(line: selected, wordToBeRated: wordToBeRated)

        wordToBeRatedBold.fontColor = SKColor.black
        wordToBeRatedBold.attributedText = getWordToBeRatedBold(line: selected)
        wordToBeRatedBold.position = CGPoint(x: frame.midX, y: frame.midY)
        wordToBeRatedBold.zPosition = 2
        // addChild(wordToBeRatedBold)
        
        addChild(audioNode)
        
        // https://stackoverflow.com/questions/42026839/make-touch-area-for-sklabelnode-bigger-for-small-characters#comment71238691_42026839
        // TODO: dynamically via method
        generateStressMarks()
    }
    

    func getWordToBeRatedBold(line: Line) -> NSMutableAttributedString? {
        let wordToBeRatedBold = NSMutableAttributedString()
        
        // TODO Higher Function instead of two for loops
        for word in line.words {
            for syllable in word.syllables {
                if syllable.accentuation.rawValue == "unstressed" {
                    let syllableNotBold = makeAttributedString(stringToBeMutated: syllable.syllableString, shallBecomeBold: false)
                    wordToBeRatedBold.append(syllableNotBold)
                }
                else if syllable.accentuation.rawValue == "stressed" {
                    let syllableBold = makeAttributedString(stringToBeMutated: syllable.syllableString, shallBecomeBold: true)
                    wordToBeRatedBold.append(syllableBold)
                }
            }
            // space character between words
            wordToBeRatedBold.append(NSMutableAttributedString(string:"  "))
        }
        
        return wordToBeRatedBold
    }
    
    func makeAttributedString(stringToBeMutated: String, shallBecomeBold: Bool) -> NSMutableAttributedString {
        if(shallBecomeBold) {
            let bold = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 55)]
            let attributedString =  NSMutableAttributedString(string:stringToBeMutated, attributes:bold)
            return attributedString
        }
        else {
            let notBold = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 50)]
            let normalString = NSMutableAttributedString(string:stringToBeMutated, attributes: notBold)
            return normalString
        }
    }
    
    
    
    
    func displayAccentuationInfo() {
        backgroundBlockerAccentuationInfo = SKSpriteNode(color: SKColor.white, size: self.size)
        backgroundBlockerAccentuationInfo.zPosition = 4999
        addChild(backgroundBlockerAccentuationInfo)

        accentuationInfo = AccentuationInfo(size: CGSize(width: 650, height: 800))
        accentuationInfo.delegate = self
        accentuationInfo.zPosition = 5000
        addChild(accentuationInfo)
    }
    
    func displayCongratulations() {
        backgroundBlockerCongratulations = SKSpriteNode(color: SKColor.white, size: self.size)
        backgroundBlockerCongratulations.zPosition = 4999
        addChild(backgroundBlockerCongratulations)
        
        congratulations = Congratulations(size: CGSize(width: 650, height: 800))
        congratulations.delegate = self
        congratulations.zPosition = 5000
        addChild(congratulations)
    }
    
    func displayReplyIsCorrect() {
        backgroundBlockerReplyIsCorrect = SKSpriteNode(color: SKColor.white, size: self.size)
        backgroundBlockerReplyIsCorrect.alpha = 0.5
        backgroundBlockerReplyIsCorrect.zPosition = 4999
        addChild(backgroundBlockerReplyIsCorrect)
        
        replyIsCorrect = ReplyIsCorrect(size: CGSize(width: 747, height: 300))
        replyIsCorrect.delegate = self
        replyIsCorrect.zPosition = 5000
        addChild(replyIsCorrect)
    }
    
    func displayReplyIsFalse() {
        backgroundBlockerReplyIsFalse = SKSpriteNode(color: SKColor.white, size: self.size)
        backgroundBlockerReplyIsFalse.alpha = 0.5
        backgroundBlockerReplyIsFalse.zPosition = 4999
        addChild(backgroundBlockerReplyIsFalse)
        
        replyIsFalse = ReplyIsFalse(size: CGSize(width: 747, height: 300))
        replyIsFalse.delegate = self
        replyIsFalse.zPosition = 5000
        addChild(replyIsFalse)
    }
    
    // function for an action to add and remove a node from the scene
    func addAndRemoveNode(node: SKLabelNode) {
        addChild(node)
        node.run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.removeFromParent(),
            ])
        )
    }
    
    // function for an action to hide and unhide a node from the scene
    func hideAndUnhideNode(node: SKLabelNode) {
        node.run(SKAction.sequence([
            SKAction.hide(),
            SKAction.wait(forDuration: 3.0),
            SKAction.unhide()
            ])
        )
    }
    
    
    // function to update and manage status of level passing
    func manageLoadingBar() {
        // TODO check complexity / higher function
        // only increase loadingbar if level has not been passed yet
        
        let levelOneIsPassed = UserDefaults.standard.bool(forKey: "levelOne")

        if !(levelOneIsPassed) {
            let imageName = "loadingBar" + String(correctRepliesLevelOne)
            loadingBar.texture = SKTexture(imageNamed: imageName)
            print("correct replies: " + String(correctRepliesLevelOne))
        }
        else {
            loadingBar.texture = SKTexture(imageNamed: "loadingBarFull")
            print("correct replies: " + String(correctRepliesLevelOne))
        }
    }
    
    // func to check whether level is passed or not
    func updateLevelStatus() {
        if (correctRepliesLevelOne >= amountOfCorrectRepliesToPassLevel) {
            
            UserDefaults.standard.set(true, forKey: "levelOne")
            // levelOneIsPassed = true
        }
    }


    // remove unnecessary nodes and set up scene for new word to be rated
    func cleanAndSetupSceneForNewWord() {
        // remove all accentBins and stressMarks from scene
        accentBins.forEach { $0.removeFromParent() }
        stressMarks.forEach { $0.removeFromParent() }

        // empty accentBins array and stressMarks arraay since new word is selected
        accentBins.removeAll()
        stressMarks.removeAll()
        
        wordToBeRated.removeFromParent()
        audioNode.removeFromParent()
        stressed.removeFromParent()
        stressedParent.removeFromParent()
        unstressed.removeFromParent()
        unstressedParent.removeFromParent()
        
        setUpUnfixedParts()
    }
    
    // function to check if all accentBins are filled with a stressMark
    // TODO higher function
    func areAccentBinsFilledWithAStressmark() -> Bool {
        // return false as soon as one accentBin is empty
        for accentBin in accentBins {
            if !(isAccentBinFilledWithAStressMark(accentBin: accentBin)) {
                return false
            }
        }
        return true
    }
    
    // TODO higher function
    func isAccentBinFilledWithAStressMark(accentBin: SKSpriteNode) -> Bool {
        for stressMark in stressMarks {
            if accentBin.position.equalTo(stressMark.position) {
                return true
            }
        }
        return false
    }
    
    // function to check whether the accentBins are filled with the correct stressMarks
    // returns correctSolution and true if correct and false otherwise
    func isSolutionCorrect() -> (Bool, [String]) {
        var givenSolution = [String]()
        var realSolution = [String]()

        // TODO higher function
        // get name of stressMarks sorted from left accentBin to the right
        for accentBin in accentBins {
            for stressMark in stressMarks {
                if accentBin.position.equalTo(stressMark.position) {
                    givenSolution.append(stressMark.name!)
                }
            }
        }
        
        // TODO modularize
        // get correct accentuation of line
        for word in selected.words {
            for syllable in word.syllables {
                realSolution.append(syllable.accentuation.rawValue)
            }
        }
        
        if givenSolution.elementsEqual(realSolution) {
            return (true, realSolution)
        }
        else {
            return (false, realSolution)
        }

    }
    
    

    override func didMove(to view: SKView) {
        setUpScene()
        setUpUnfixedParts()
        
        // has to be stored as NSuserData
        if !(UserDefaults.standard.bool(forKey: "levelOne")) {
            displayAccentuationInfo()
            // firstEntryOfLevelOne = false
        }
        else {
            correctRepliesLevelOne = 4
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // https://code.tutsplus.com/tutorials/spritekit-basics-nodes--cms-28785
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if(touchedNode.name == "accentuationInfoBtn") {
            displayAccentuationInfo()
        }
        
        if(touchedNode.name == "soundBoxBtn") {
            // https://www.reddit.com/r/swift/comments/2wpspa/running_parallel_skactions_with_different_nodes/
            // https://stackoverflow.com/questions/28823386/skaction-playsoundfilenamed-fails-to-load-sound
            // worked as well
            // audioNode.run(SKAction.playSoundFileNamed("Sonne.WAV", waitForCompletion: false))
            // audioNode.run(SKAction.playSoundFileNamed("test.WAV", waitForCompletion: false))
            let playSound = SKAction.playSoundFileNamed(selected.audioFile, waitForCompletion: false)
            let action =  SKAction.group([playSound,
                                          SKAction.run{self.addAndRemoveNode(node: self.wordToBeRatedBold)},
                                          SKAction.run{self.hideAndUnhideNode(node: self.wordToBeRated)}])
            self.run(action)
        }
        
        if (touchedNode.name == "check") {
            if areAccentBinsFilledWithAStressmark() {
                let (isSolutionCorrect, realSolution) = self.isSolutionCorrect()

                if (isSolutionCorrect) {
                    correctRepliesLevelOne += 1
                    // check whether level is passed and save to boolean variable
                    updateLevelStatus()
                    // increase loadingbar but only if level has not been passed yet
                    manageLoadingBar()
                    
                    displayReplyIsCorrect()
                }
                else {
                    print("correct solution: " + realSolution.description)
                    displayReplyIsFalse()
                }
            }
            else {
                print("do fill in every accentBin with a stressMark")
                // show message overlay: do fill in every accentBin with a stressMark
                // click on ok, close message overlay window
            }
            
        }
        
        if (touchedNode.name == "exit") {
            // https://stackoverflow.com/questions/46954696/save-state-of-gamescene-through-transitions
            let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
            self.view?.presentScene(mainMenu)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get a touch
        let touch = touches.first!
        
        // TODO higher function
        // dragging of stressMarks to new location by touching
        for (smIndex, stressMark) in stressMarks.enumerated() {
            if stressMark.frame.contains(touch.previousLocation(in: self)) {
                stressMark.position = touch.location(in: self)
            }
            // debugged so that if stressMarks collide, they do not stick together anymore
            for (sIndex, s) in stressMarks.enumerated() {
                if (stressMark.position.equalTo(s.position)) && (smIndex != sIndex) {
                    stressMark.position = CGPoint(x: stressMark.position.x-80, y: stressMark.position.y-40)
                }
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO higher function
        // stressMarks clinch (einrasten) into accentBin
        for accentBin in accentBins {
            // https://www.hackingwithswift.com/example-code/games/how-to-color-an-skspritenode-using-colorblendfactor
            // https://stackoverflow.com/questions/36136665/how-to-animate-a-matrix-changing-the-sprites-one-by-one
            for stressMark in stressMarks {
                if accentBin.frame.contains(stressMark.position) {
                    stressMark.position = accentBin.position
                }
            }
        }
        
        // TODO higher function
        // if stressMark.position not in frame anymore, position it back to the middle
        for stressMark in stressMarks {
            if !(frame.contains(stressMark.position)) {
                print("lost a stressMark to the infinite nonentity")
                stressMark.position = CGPoint(x: frame.midX, y: frame.midY-150)
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}



extension LevelOneScene: AccentuationInfoDelegate, ReplyIsCorrectDelegate, ReplyIsFalseDelegate, CongratulationsDelegate {
    
    func closeCongratulations() {
        // https://stackoverflow.com/questions/46954696/save-state-of-gamescene-through-transitions
        
        let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
        self.view?.presentScene(mainMenu)
    }
    
    func closeAccentuationInfo() {
        //at this point you could update any GUI nesc. based on what happened in your dialog
        backgroundBlockerAccentuationInfo.removeFromParent()
        accentuationInfo?.removeFromParent()
    }
    
    func closeReplyIsCorrect() {
        backgroundBlockerReplyIsCorrect.removeFromParent()
        replyIsCorrect?.removeFromParent()
        
        if correctRepliesLevelOne == amountOfCorrectRepliesToPassLevel {
            print("you passed level one!")
            // open overlay to get to Hauptmenü
            displayCongratulations()
        }
        else {
            cleanAndSetupSceneForNewWord()
        }
    }
    
    func closeReplyIsFalse() {
        backgroundBlockerReplyIsFalse.removeFromParent()
        replyIsFalse?.removeFromParent()
        cleanAndSetupSceneForNewWord()
    }
}




