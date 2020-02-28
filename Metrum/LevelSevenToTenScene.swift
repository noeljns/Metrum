//
//  LevelSevenToTenScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 20.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

class LevelSevenToTenScene: SKScene {
    // UI variables
    private var exitLabel = ExitLabel()
    private let loadingBar = LoadingBar(color: .green, size: CGSize(width: 600, height: 26))
    
    private let taskLabel = SKLabelNode()
    private var jambus = SKLabelNode()
    private var jambusBin = SKSpriteNode()
    private var trochaeus = SKLabelNode()
    private var trochaeusBin = SKSpriteNode()
    private var daktylus = SKLabelNode()
    private var daktylusBin = SKSpriteNode()
    private var anapaest = SKLabelNode()
    private var anapaestBin = SKSpriteNode()
    private var selectedLineLabel = SKLabelNode()
    private var selectedLineBoldLabel = SKLabelNode()
    private var measureInfoButton = SKSpriteNode()
    private var measureInfo: MeasureInfo!
    private var soundBoxButton = SKSpriteNode()

    // overlay nodes
    // TODO check whether forced unwrapping is appropriate here
    private var backgroundBlocker: SKSpriteNode!
    private var overlay: SKSpriteNode!
    private var congratulations: Congratulations!
    private var warning: Warning!
    
    // variables for level passing management
    // lazy: https://stackoverflow.com/questions/45423321/cannot-use-instance-member-within-property-initializer#comment101019582_45423454
    lazy private var correctlyDraggedLines = Set<Line>()
    private var amountOfCorrectRepliesToPassLevel = 2
    private var correctReplies = 0
    
    // variables for input data
    lazy var loadedLines = Set<Line>()
    // TODO check whether forced unwrapping is appropriate here
    // TODO: or is it only handed via functions parameters anyways? is a global variable necessary?
    private var selectedLine: Line!
    
    // TODO check if handing over properties via init / constructor is better
    public var provideHelp = false
    public var inputFile = ""
    public var userDefaultsKey = ""
    
    // SK Actions
    private let colorizeGreen = SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0.1)
    private let colorizeRed = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0.1)
    private let colorizeWhite = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0.2)
    
    // both did not work
    // https://forums.raywenderlich.com/t/swift-tutorial-initialization-in-depth-part-2-2/13209/3
    // https://spritekitswift.wordpress.com/2015/10/21/spritekit-custom-skscene-class-from-abstract-skscene-class-with-swift/
    //    convenience init?(fileNamed: String, provideHelp: Bool, inputFile: String) {
    //        // super.init(size: size)
    //        self.init(fileNamed: "fileNamed")
    //        self.provideHelp = provideHelp
    //        self.inputFile = inputFile
    //    }
    
    /// Gets data from json file and saves deserialized Line objects to selection variable.
    func loadInputFile() {
        // https://stackoverflow.com/a/58981897
        let data: Data
        
        // TODO get from Sandbox
        // name of json file is in inputFile
        guard let file = Bundle.main.url(forResource: inputFile, withExtension: nil) else {
            fatalError("Could not find \(inputFile) in main bundle.")
        }
        do {
            data = try Data(contentsOf: file)
        }
        catch {
            fatalError("Could not find \(inputFile) in main bundle.")
        }
        do {
            let lines = try! JSONDecoder().decode([Line].self, from: data)
            loadedLines = Set<Line>(lines)
            selectedLine = loadedLines.first!
        }
    }
    
    /// Sets up the ui elements that don't get removed from and re-added to scene during level
    func setUpScene() {
        addChild(exitLabel)
        manageLoadingBar()
        addChild(loadingBar)
        
        taskLabel.fontColor = SKColor.black
        taskLabel.text = "Ziehe das Wort bzw. den Vers in den Kasten des zugehörigen Versmaßes."
        taskLabel.position = CGPoint(x: frame.midX , y: frame.midY+300)
        // break line: https://forums.developer.apple.com/thread/82994
        taskLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        taskLabel.numberOfLines = 0
        taskLabel.preferredMaxLayoutWidth = 600
        taskLabel.zPosition = 4
        addChild(taskLabel)
        
        let jambusLabel = makeAttributedString(stringToBeMutated: "Jambus: Ge·", shallBecomeBold: false, size: 25)
        jambusLabel.append(makeAttributedString(stringToBeMutated: "spenst 👻", shallBecomeBold: true, size: 25))
        jambus.attributedText = jambusLabel
        jambus.fontColor = SKColor.black
        jambus.position = CGPoint(x: -200, y: 200)
        jambus.zPosition = 2
        addChild(jambus)
        jambusBin.color = SKColor.white
        jambusBin.size = CGSize(width: 300, height: 300)
        jambusBin.position = CGPoint(x: -200, y: 100)
        jambusBin.drawBorder(color: .lightGray, width: 5.0)
        jambusBin.zPosition = 1
        addChild(jambusBin)
        
        let trochaeusLabel = makeAttributedString(stringToBeMutated: "Trochäus: ", shallBecomeBold: false, size: 25)
        trochaeusLabel.append(makeAttributedString(stringToBeMutated: "So", shallBecomeBold: true, size: 25))
        trochaeusLabel.append(makeAttributedString(stringToBeMutated: "·nne ☀️", shallBecomeBold: false, size: 25))
        trochaeus.attributedText = trochaeusLabel
        trochaeus.fontColor = SKColor.black
        trochaeus.position = CGPoint(x: 200, y: 200)
        trochaeus.zPosition = 2
        addChild(trochaeus)
        trochaeusBin.color = SKColor.white
        trochaeusBin.size = CGSize(width: 300, height: 300)
        trochaeusBin.position = CGPoint(x: 200, y: 100)
        trochaeusBin.drawBorder(color: .lightGray, width: 5.0)
        trochaeusBin.zPosition = 1
        addChild(trochaeusBin)
        
        let anapaestLabel = makeAttributedString(stringToBeMutated: "Anapäst: E·le·", shallBecomeBold: false, size: 25)
        anapaestLabel.append(makeAttributedString(stringToBeMutated: "fant 🐘", shallBecomeBold: true, size: 25))
        anapaest.attributedText = anapaestLabel
        anapaest.fontColor = SKColor.black
        anapaest.position = CGPoint(x: -200, y: -200)
        anapaest.zPosition = 2
        addChild(anapaest)
        anapaestBin.color = SKColor.white
        anapaestBin.size = CGSize(width: 300, height: 300)
        anapaestBin.position = CGPoint(x: -200, y: -300)
        anapaestBin.drawBorder(color: .lightGray, width: 5.0)
        anapaestBin.zPosition = 1
        addChild(anapaestBin)
        
        let daktylusLabel = makeAttributedString(stringToBeMutated: "Daktylus: ", shallBecomeBold: false, size: 25)
        daktylusLabel.append(makeAttributedString(stringToBeMutated: "Bro", shallBecomeBold: true, size: 25))
        daktylusLabel.append(makeAttributedString(stringToBeMutated: "·kko·li 🥦", shallBecomeBold: false, size: 25))
        daktylus.attributedText = daktylusLabel
        daktylus.fontColor = SKColor.black
        daktylus.position = CGPoint(x: 200, y: -200)
        daktylus.zPosition = 2
        addChild(daktylus)
        daktylusBin.color = SKColor.white
        daktylusBin.size = CGSize(width: 300, height: 300)
        daktylusBin.position = CGPoint(x: 200, y: -300)
        daktylusBin.drawBorder(color: .lightGray, width: 5.0)
        daktylusBin.zPosition = 1
        addChild(daktylusBin)
        
//        if provideHelp {
//            // measureInfoButton = SKSpriteNode(imageNamed: "info")
//            measureInfoButton = SKSpriteNode(imageNamed: "icons8-info-50")
//            measureInfoButton.name = "measureInfoButton"
//            measureInfoButton.position = CGPoint(x: frame.midX+225 , y: frame.midY-75)
//            measureInfoButton.size = CGSize(width: 40, height: 40)
//            measureInfoButton.zPosition = 2
//            addChild(measureInfoButton)
//
//            // soundBoxButton = SKSpriteNode(imageNamed: "sound")
//            soundBoxButton = SKSpriteNode(imageNamed: "QuickActions_Audio")
//            soundBoxButton.name = "soundBoxBtn"
//            soundBoxButton.position = CGPoint(x: frame.midX+165 , y: frame.midY-75)
//            soundBoxButton.size = CGSize(width: 30, height: 30)
//            soundBoxButton.zPosition = 2
//            addChild(soundBoxButton)
//        }
    }
    
    /// Manages loading Bar.
    /// Every time the user replies correctly, the loading bar gets increased.
    /// If the user has passed the level, the loading bar remains full.
    func manageLoadingBar() {
        let levelIsPassed = UserDefaults.standard.bool(forKey: userDefaultsKey)
        
        if !(levelIsPassed) {
            loadingBar.progress = CGFloat(correctReplies)/CGFloat(amountOfCorrectRepliesToPassLevel)
        }
        else {
            loadingBar.progress = 1.0
        }
    }
    
    /// Sets up the ui elements that get removed from and re-added to scene during level.
    /// Displays new Line for which user has to solve task for.
    func setUpUnfixedParts() {
        // TODO right position in code?
        selectedLine = selectNextLine()
        
        selectedLineLabel.fontColor = SKColor.black
        selectedLineLabel.attributedText = makeAttributedString(stringToBeMutated: selectedLine.line, shallBecomeBold: false, size: 40)
        selectedLineLabel.position = CGPoint(x: frame.midX, y: frame.midY-125)
        selectedLineLabel.zPosition = 3
        selectedLineLabel.name = selectedLine.measure.rawValue
        
        selectedLineBoldLabel.fontColor = SKColor.black
        selectedLineBoldLabel.attributedText = getLineToBeRatedBold(line: selectedLine)
        selectedLineBoldLabel.position = CGPoint(x: frame.midX, y: frame.midY-125)
        selectedLineBoldLabel.zPosition = 3
        selectedLineBoldLabel.name = selectedLine.measure.rawValue
        // addChild(selectedLineBoldLabel)
        
        if provideHelp {
            // measureInfoButton = SKSpriteNode(imageNamed: "info")
            measureInfoButton = SKSpriteNode(imageNamed: "icons8-info-50")
            measureInfoButton.name = "measureInfoButton"
            measureInfoButton.position = CGPoint(x: selectedLineLabel.frame.maxX+70 , y: frame.midY+40)
            measureInfoButton.size = CGSize(width: 40, height: 40)
            measureInfoButton.zPosition = 2
            selectedLineLabel.addChild(measureInfoButton)
            selectedLineBoldLabel.addChild(measureInfoButton.copy() as! SKNode)
            // soundBoxButton = SKSpriteNode(imageNamed: "sound")
            soundBoxButton = SKSpriteNode(imageNamed: "QuickActions_Audio")
            soundBoxButton.name = "soundBoxBtn"
            soundBoxButton.position = CGPoint(x: selectedLineLabel.frame.maxX+20 , y: frame.midY+40)
            soundBoxButton.size = CGSize(width: 30, height: 30)
            soundBoxButton.zPosition = 2
            selectedLineLabel.addChild(soundBoxButton)
            selectedLineBoldLabel.addChild(soundBoxButton.copy() as! SKNode)
        }
        addChild(selectedLineLabel)
    }
    
    /// Returns the next Line for which the user has to solve the task.
    /// Does not select the previous Line, only if it is the last not correctly solved Line.
    ///
    /// - Returns: The newly selected Line.
    func selectNextLine() -> Line {
        let previousSelected = selectedLine
        
        // notYetCorrectlyMarkedLines gets all loadedLines if correctlyMarkedLines is empty in the beginning
        var notYetCorrectlyMarkedLines = loadedLines.subtracting(correctlyDraggedLines)
        // loops over all loadedLines if all lines have already been solved correctly
        if (notYetCorrectlyMarkedLines.isEmpty) {
            correctlyDraggedLines.removeAll()
            notYetCorrectlyMarkedLines = loadedLines
        }
        
        var newlySelected = notYetCorrectlyMarkedLines.randomElement()!
        // only one remaining line to be solved
        if (notYetCorrectlyMarkedLines.count==1) {
            // newlySelected contains that one line
            return newlySelected
        }
        
        while(previousSelected == newlySelected ) {
            newlySelected = notYetCorrectlyMarkedLines.randomElement()!
        }
        return newlySelected
    }
    
    /// Returns Line with stressed syllables in bold.
    ///
    /// - Parameters:
    ///   - line: The Line which should be returnded.
    /// - Returns: The Line with stressed syllables in bold.
    func getLineToBeRatedBold(line: Line) -> NSMutableAttributedString? {
        let lineToBeRatedBold = NSMutableAttributedString()
        
        // TODO Higher Function instead of two for loops
        for word in line.words {
            for syllable in word.syllables {
                if syllable.accentuation.rawValue == "unstressed" {
                    let syllableNotBold = makeAttributedString(stringToBeMutated: syllable.syllableString + "·", shallBecomeBold: false, size: 40)
                    lineToBeRatedBold.append(syllableNotBold)
                }
                else if syllable.accentuation.rawValue == "stressed" {
                    let syllableBold = makeAttributedString(stringToBeMutated: syllable.syllableString + "·", shallBecomeBold: true, size: 40)
                    lineToBeRatedBold.append(syllableBold)
                }
            }
            // cut last character, so that last middle point is removed from word
            lineToBeRatedBold.deleteCharacters(in: NSRange(location:(lineToBeRatedBold.length) - 1,length:1))
            // space character between words
            lineToBeRatedBold.append(NSMutableAttributedString(string:"  "))
        }
        return lineToBeRatedBold
    }
    
    // TODO modularize overlay nodes
    //    func displayOverlayNode(node: SKSpriteNode, size: CGSize, transparent: Bool) {
    //        backgroundBlocker = SKSpriteNode(color: SKColor.white, size: self.size)
    //        backgroundBlocker.zPosition = 4999
    //        if transparent {
    //            backgroundBlocker.alpha = 0.5
    //        }
    //        addChild(backgroundBlocker)
    //
    //        // how to hand over custom node classes?
    //        let node = typeTest(node.type(of: init)(size: CGSize(size: size)))
    //        node.delegate = self
    //        node.zPosition = 5000
    //        addChild(node)
    //    }
    
    /// Adds MeasureInfo as overlay node to scene.
    func displayMeasureInfo() {
        backgroundBlocker = SKSpriteNode(color: SKColor.white, size: self.size)
        backgroundBlocker.zPosition = 4999
        addChild(backgroundBlocker)
        
        measureInfo = MeasureInfo(size: CGSize(width: 650, height: 800))
        measureInfo.delegate = self
        measureInfo.zPosition = 5000
        addChild(measureInfo)
    }
    
    /// Adds Congratualtions as overlay node to scene.
    func displayCongratulations() {
        backgroundBlocker = SKSpriteNode(color: SKColor.white, size: self.size)
        backgroundBlocker.zPosition = 4999
        addChild(backgroundBlocker)
        
        congratulations = Congratulations(size: CGSize(width: 650, height: 800))
        congratulations.delegate = self
        congratulations.zPosition = 5000
        addChild(congratulations)
    }
    
    /// Adds Warning as overlay node to scene.
    func displayWarning() {
        backgroundBlocker = SKSpriteNode(color: SKColor.white, size: self.size)
        backgroundBlocker.zPosition = 4999
        backgroundBlocker.alpha = 0.5
        addChild(backgroundBlocker)
        
        warning = Warning(size: CGSize(width: 650, height: 450))
        warning.delegate = self
        warning.zPosition = 5000
        addChild(warning)
    }
    
    /// Relevant for sound button.
    /// Runs an action that adds a node to the scene and removes it after some seconds.
    /// Duration of action is longer in higher levels.
    ///
    /// - Parameters:
    ///   - node: Node that should be added to and removed from the scene.
    func addAndRemoveNode(node: SKLabelNode) {
        let duration = longerDurationIfHigherLevels()
        
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
        let duration = longerDurationIfHigherLevels()
        
        node.run(SKAction.sequence([
            SKAction.hide(),
            SKAction.wait(forDuration: duration),
            SKAction.unhide()
            ])
        )
    }
    
    /// Relevant for sound button.
    /// Returns a duration regarding the game status.
    ///
    /// - Returns: A duration of one second or four seconds if it is a higher level.
    func longerDurationIfHigherLevels() -> TimeInterval{
        var duration = TimeInterval(2.5)
        if (userDefaultsKey == "level3" || userDefaultsKey == "level4" || userDefaultsKey == "level9" || userDefaultsKey == "level10") {
            duration = TimeInterval(5.5)
        }
        return duration
    }
    
    /// Relevant for check button.
    /// Sets user data of the level to true, if the level has been passed.
    func updateLevelStatus() {
        if (correctReplies >= amountOfCorrectRepliesToPassLevel) {
            UserDefaults.standard.set(true, forKey: userDefaultsKey)
        }
    }
    
    /// Empties lists, removes unfix nodes and sets up scene again for new line to be solved.
    func cleanAndSetupSceneForNewLine() {
        selectedLineLabel.removeAllChildren()
        selectedLineLabel.removeFromParent()
        selectedLineBoldLabel.removeAllChildren()
        setUpUnfixedParts()
    }
    
    /// Manages level status and loading bar for correct replies
    func manageCorrectReply() {
        correctReplies += 1
        
        // check whether level is passed and save to boolean variable
        updateLevelStatus()
        // increase loadingbar but only if level has not been passed yet
        manageLoadingBar()
        
        if correctReplies == amountOfCorrectRepliesToPassLevel {
            displayCongratulations()
        }
        else {
            cleanAndSetupSceneForNewLine()
        }
    }

    override func didMove(to view: SKView) {
        loadInputFile()
        setUpScene()
        setUpUnfixedParts()
        
//        // only show MeasureInfo, if level7 has not been passed yet
//        if !(UserDefaults.standard.bool(forKey: "level7")) {
//            displayMeasureInfo()
//        }
        // current level has been passed, so we do not need to show congratulation window anymore
        // correctReplies as threshold has to be bigger than amountOfCorrectRepliesToPassLevel
        // because if threshold = amountOfCorrectRepliesToPassLevel, the congratulation is shown
        if (UserDefaults.standard.bool(forKey: userDefaultsKey)) {
            correctReplies = amountOfCorrectRepliesToPassLevel+1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // https://code.tutsplus.com/tutorials/spritekit-basics-nodes--cms-28785
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if(provideHelp && touchedNode.name == "measureInfoButton") {
            displayMeasureInfo()
        }
        
        if(provideHelp && touchedNode.name == "soundBoxBtn") {
            // https://www.reddit.com/r/swift/comments/2wpspa/running_parallel_skactions_with_different_nodes/
            // https://stackoverflow.com/questions/28823386/skaction-playsoundfilenamed-fails-to-load-sound
            // worked as well
            // audioNode.run(SKAction.playSoundFileNamed("Sonne.WAV", waitForCompletion: false))
            // audioNode.run(SKAction.playSoundFileNamed("test.WAV", waitForCompletion: false))
 
            // node no longer receives touch events
            self.soundBoxButton.isUserInteractionEnabled = true
            
            let playSound = SKAction.playSoundFileNamed(selectedLine.audioFile, waitForCompletion: false)
            let action =  SKAction.group([playSound,
                                          SKAction.run{self.addAndRemoveNode(node: self.selectedLineBoldLabel)},
                                          SKAction.run{self.hideAndUnhideNode(node: self.selectedLineLabel)}])
            self.run(action)
            
            // node waits 1.5 for lower levels, 4.0 for higher levels and reveices touch events again
            // otherwise app would crash since addAndRemoveNode would be operated although node is still in scene
            self.run(SKAction.wait(forDuration: longerDurationIfHigherLevels()), completion: {() -> Void in
                self.soundBoxButton.isUserInteractionEnabled = false
                print(self.soundBoxButton.isUserInteractionEnabled.description)})
        }
        
        if (touchedNode.isEqual(to: exitLabel)) {
            if(UserDefaults.standard.bool(forKey: userDefaultsKey)) {
                // https://stackoverflow.com/questions/46954696/save-state-of-gamescene-through-transitions
                let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
                self.view?.presentScene(mainMenu)
            }
            else {
                displayWarning()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        // if it started in the label, move it to the new location
        if selectedLineLabel.frame.contains(touch.previousLocation(in: self)) {
            selectedLineLabel.position = touch.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // bold label is dragged to new position too
        if (selectedLineBoldLabel.position != selectedLineLabel.position) {
            selectedLineBoldLabel.position = selectedLineLabel.position
        }
        
        if jambusBin.frame.contains(selectedLineLabel.position) {
            // https://www.hackingwithswift.com/example-code/games/how-to-color-an-skspritenode-using-colorblendfactor
            // https://stackoverflow.com/questions/36136665/how-to-animate-a-matrix-changing-the-sprites-one-by-one
            if selectedLineLabel.name == Measure.jambus.rawValue {
                jambusBin.run(SKAction.sequence([colorizeGreen, colorizeWhite]))
                manageCorrectReply()
            }
            // else if wordToBeRated.name == "trochaeus" or "daktylus" or "anapaest"
            else {
                jambusBin.run(SKAction.sequence([colorizeRed, colorizeWhite]))
                selectedLineLabel.position = CGPoint(x: frame.midX, y: frame.midY-120)
            }
        }
        
        if trochaeusBin.frame.contains(selectedLineLabel.position) {
            if selectedLineLabel.name == Measure.trochaeus.rawValue {
                trochaeusBin.run(SKAction.sequence([colorizeGreen, colorizeWhite]))
                manageCorrectReply()
            } else {
                trochaeusBin.run(SKAction.sequence([colorizeRed, colorizeWhite]))
                selectedLineLabel.position = CGPoint(x: frame.midX, y: frame.midY-120)
            }
        }
        
        if daktylusBin.frame.contains(selectedLineLabel.position) {
            if selectedLineLabel.name == Measure.daktylus.rawValue {
                daktylusBin.run(SKAction.sequence([colorizeGreen, colorizeWhite]))
                manageCorrectReply()
            } else {
                daktylusBin.run(SKAction.sequence([colorizeRed, colorizeWhite]))
                selectedLineLabel.position = CGPoint(x: frame.midX, y: frame.midY-120)
            }
        }
        
        if anapaestBin.frame.contains(selectedLineLabel.position) {
            if selectedLineLabel.name == Measure.anapaest.rawValue {
                anapaestBin.run(SKAction.sequence([colorizeGreen, colorizeWhite]))
                manageCorrectReply()
            } else {
                anapaestBin.run(SKAction.sequence([colorizeRed, colorizeWhite]))
                selectedLineLabel.position = CGPoint(x: frame.midX, y: frame.midY-120)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}



extension LevelSevenToTenScene: MeasureInfoDelegate, CongratulationsDelegate, WarningDelegate {
    func closeMeasureInfo() {
        backgroundBlocker.removeFromParent()
        measureInfo?.removeFromParent()
    }
    
    func closeCongratulations() {
        // https://stackoverflow.com/questions/46954696/save-state-of-gamescene-through-transitions
        let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
        self.view?.presentScene(mainMenu)
    }
    
    func exitWarning() {
        // https://stackoverflow.com/questions/46954696/save-state-of-gamescene-through-transitions
        let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
        self.view?.presentScene(mainMenu)
    }
    
    func closeWarning() {
        backgroundBlocker.removeFromParent()
        warning?.removeFromParent()
    }
}
