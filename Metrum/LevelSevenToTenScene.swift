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
    private let taskLabel: TaskLabel = {
        let taskLabelText = "Ziehe das Wort bzw. den Vers in den Kasten des zugehörigen Versmaßes."
        let taskLabelPosition = CGPoint(x: 0 , y: 300)
        let taskLabel = TaskLabel(text: taskLabelText, position: taskLabelPosition)
        return taskLabel
    }()
    private var measureInfo = MeasureInfo(size: CGSize(width: 650, height: 800))
    private var infoButton = InfoButton(size: CGSize(width: 40, height: 40), position: CGPoint(x: 0 , y: 0))
    private var soundButton = SoundButton(size: CGSize(width: 30, height: 30), position: CGPoint(x: 0 , y: 0))
    private var selectedLineLabel = SKLabelNode()
    private var selectedLineBoldLabel = SKLabelNode()
    private let jambusBin = MeasureContainer(position: CGPoint(x: -200, y: 100))
    private let trochaeusBin = MeasureContainer(position: CGPoint(x: 200, y: 100))
    private let anapaestBin = MeasureContainer(position: CGPoint(x: -200, y: -300))
    private let daktylusBin = MeasureContainer(position: CGPoint(x: 200, y: -300))

    // overlay nodes
    private var backgroundBlocker = SKSpriteNode()
    private var congratulations = Congratulations(size: CGSize(width: 650, height: 800))
    private var warning = Warning(size: CGSize(width: 650, height: 450))
    
    // variables for level passing management
    // lazy: https://stackoverflow.com/questions/45423321/cannot-use-instance-member-within-property-initializer#comment101019582_45423454
    private lazy var correctlyDraggedLines = Set<Line>()
    private var amountOfCorrectRepliesToPassLevel = 4
    private var correctReplies = 0
    
    // variables for input data
    private lazy var loadedLines = Set<Line>()
    // TODO check whether forced unwrapping is appropriate here
    private var selectedLine: Line!
    
    // TODO check if handing over properties via init / constructor is better
    public var provideHelp = false
    public var inputFile = ""
    public var userDefaultsKey = ""
    
    // SK Actions
    private let colorizeGreen = SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0.1)
    private let colorizeRed = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0.1)
    private let colorizeWhite = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0.2)
    
    /// Sets up the ui elements that don't get removed from and re-added to scene during level
    func setUpScene() {
        addChild(exitLabel)
        manageLoadingBar()
        addChild(loadingBar)
        addChild(taskLabel)
        
        let jambusLabelText = makeAttributedString(stringToBeMutated: "Jambus: Ge·", shallBecomeBold: false, size: 25)
         jambusLabelText.append(makeAttributedString(stringToBeMutated: "spenst 👻", shallBecomeBold: true, size: 25))
        if let jambusLabel = jambusBin.childNode(withName: "measureLabel") as? SKLabelNode {
            print("one")
            jambusLabel.attributedText = jambusLabelText
        }
        addChild(jambusBin)
    
        let trochaeusLabelText = makeAttributedString(stringToBeMutated: "Trochäus: ", shallBecomeBold: false, size: 25)
        trochaeusLabelText.append(makeAttributedString(stringToBeMutated: "So", shallBecomeBold: true, size: 25))
        trochaeusLabelText.append(makeAttributedString(stringToBeMutated: "·nne ☀️", shallBecomeBold: false, size: 25))
        if let trochaeusLabel = trochaeusBin.childNode(withName: "measureLabel") as? SKLabelNode {
            print("two")
            print(trochaeusLabelText)
            trochaeusLabel.attributedText = trochaeusLabelText
        }
        addChild(trochaeusBin)
        
        
        let anapaestLabelText = makeAttributedString(stringToBeMutated: "Anapäst: E·le·", shallBecomeBold: false, size: 25)
        anapaestLabelText.append(makeAttributedString(stringToBeMutated: "fant 🐘", shallBecomeBold: true, size: 25))
        if let anapaestLabel = anapaestBin.childNode(withName: "measureLabel") as? SKLabelNode {
            anapaestLabel.attributedText = anapaestLabelText
        }
        addChild(anapaestBin)
        
        
        let daktylusLabelText = makeAttributedString(stringToBeMutated: "Daktylus: ", shallBecomeBold: false, size: 25)
        daktylusLabelText.append(makeAttributedString(stringToBeMutated: "Bro", shallBecomeBold: true, size: 25))
        daktylusLabelText.append(makeAttributedString(stringToBeMutated: "·kko·li 🥦", shallBecomeBold: false, size: 25))
        if let daktylusLabel = daktylusBin.childNode(withName: "measureLabel") as? SKLabelNode {
            daktylusLabel.attributedText = daktylusLabelText
        }
        addChild(daktylusBin)
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
        
        if provideHelp {
            infoButton.position = CGPoint(x: selectedLineLabel.frame.maxX+70 , y: frame.midY+40)
            selectedLineLabel.addChild(infoButton)
            // did not work anymore: selectedLineBoldLabel.addChild(infoButton.copy() as! SKNode)
            selectedLineBoldLabel.addChild(createInfoButton(position: infoButton.position))
            soundButton.position = CGPoint(x: selectedLineLabel.frame.maxX+20 , y: frame.midY+40)
            selectedLineLabel.addChild(soundButton)
            // did not work anymore: selectedLineBoldLabel.addChild(soundBoxButton.copy() as! SKNode)
            selectedLineBoldLabel.addChild(createSoundButton(position: soundButton.position))
        }
        addChild(selectedLineLabel)
    }
    
    /// Creates an info button on specified position
    /// Because copy() function did not work anymore
    /// - Parameters:
    ///   - position: position of generated info button
    /// - Returns: generated info button
    func createInfoButton(position: CGPoint) -> SKSpriteNode {
        let infoButton = InfoButton(size: CGSize(width: 40, height: 40), position: position)
        return infoButton
    }
    
    /// Creates an sound button on specified position
    /// Because copy() function did not work anymore
    /// - Parameters:
    ///   - position: position of generated sound button
    /// - Returns: generated sound button
    func createSoundButton(position: CGPoint) -> SKSpriteNode {
        let soundButton = SoundButton(size: CGSize(width: 30, height: 30), position: position)
        return soundButton
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
        
        guard var newlySelected = notYetCorrectlyMarkedLines.randomElement() else {
            fatalError("error with loadedLines")
        }
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
    
    /// Adds MeasureInfo as overlay node to scene.
    func displayMeasureInfo() {
        backgroundBlocker = getBackgroundBlocker(shallBeTransparent: false, size: self.size)
        addChild(backgroundBlocker)
        measureInfo.delegate = self
        addChild(measureInfo)
    }
    
    /// Adds Congratualtions as overlay node to scene.
    func displayCongratulations() {
        backgroundBlocker = getBackgroundBlocker(shallBeTransparent: false, size: self.size)
        addChild(backgroundBlocker)
        congratulations.delegate = self
        addChild(congratulations)
    }
    
    /// Adds Warning as overlay node to scene.
    func displayWarning() {
        backgroundBlocker = getBackgroundBlocker(shallBeTransparent: true, size: self.size)
        addChild(backgroundBlocker)
        warning.delegate = self
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
    
    /// Removes unfix nodes, their children and sets up scene again for new line to be solved.
    func cleanAndSetupSceneForNewLine() {
        selectedLineLabel.removeAllChildren()
        selectedLineLabel.removeFromParent()
        selectedLineBoldLabel.removeAllChildren()
        
        setUpUnfixedParts()
    }
    
    override func didMove(to view: SKView) {
        // loadInputFile()
        loadedLines = loadInputFile(inputFile: inputFile)
        selectedLine = loadedLines.first
        
        setUpScene()
        setUpUnfixedParts()
        
        // only show MeasureInfo, if level5 has not been passed yet
        if !(UserDefaults.standard.bool(forKey: "level5")) {
            displayMeasureInfo()
        }
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
        
        if(provideHelp && touchedNode.isEqual(to: infoButton)) {
            displayMeasureInfo()
        }
        
        if(provideHelp && touchedNode.isEqual(to: soundButton)) {
            // https://www.reddit.com/r/swift/comments/2wpspa/running_parallel_skactions_with_different_nodes/
            // https://stackoverflow.com/questions/28823386/skaction-playsoundfilenamed-fails-to-load-sound
            // worked as well
            // audioNode.run(SKAction.playSoundFileNamed("Sonne.WAV", waitForCompletion: false))
            // audioNode.run(SKAction.playSoundFileNamed("test.WAV", waitForCompletion: false))
 
            // sound and line nodes no longer receives touch events
            self.soundButton.isUserInteractionEnabled = true
            self.selectedLineBoldLabel.isUserInteractionEnabled = true
            
            let playSound = SKAction.playSoundFileNamed(selectedLine.audioFile, waitForCompletion: false)
            let action =  SKAction.group([playSound,
                                          SKAction.run{self.addAndRemoveNode(node: self.selectedLineBoldLabel)},
                                          SKAction.run{self.hideAndUnhideNode(node: self.selectedLineLabel)}])
            self.run(action)
            
            // sound and line nodes wait 1.5 for lower levels, 4.0 for higher levels, afterwards they reveice touch events again
            // otherwise app would crash since addAndRemoveNode would be operated although nodes are still in scene
            self.run(SKAction.wait(forDuration: longerDurationIfHigherLevels()), completion: {() -> Void in
                self.soundButton.isUserInteractionEnabled = false
                self.selectedLineBoldLabel.isUserInteractionEnabled = false
                print(self.soundButton.isUserInteractionEnabled.description)})
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
        guard let touch = touches.first else {
            return
        }
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
        measureInfo.removeFromParent()
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
        warning.removeFromParent()
    }
}
