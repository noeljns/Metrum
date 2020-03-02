//
//  LevelOneToFourScene.swift
//  Metrum
//
// Class that represents a scene for level one to four of Metrum App.
// After initializing the provideHelp, inputFile and userDefaultsKey properties need to be specified.
//
//  Created by Jonas Jonas on 06.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//
import SpriteKit

class LevelOneToFourScene: SKScene {
    // UI variables
    private var exitLabel = ExitLabel()
    private let loadingBar = LoadingBar(color: .green, size: CGSize(width: 600, height: 26))
    private let taskLabel: TaskLabel = {
        let taskLabelText = "Markiere alle Silben mit einem Betonungszei- chen als betont (x́) oder unbetont (x).\n"
                            + "Ziehe dafür das Zeichen in das graue Kästchen, das über ihr platziert ist."
        let taskLabelPosition = CGPoint(x: 0 , y: 200)
        let taskLabel = TaskLabel(text: taskLabelText, position: taskLabelPosition)
        return taskLabel
    }()
    private var accentuationInfo = AccentuationInfo(size: CGSize(width: 650, height: 800))
    private var infoButton = InfoButton(size: CGSize(width: 50, height: 50), position: CGPoint(x: 225 , y: 90))
    private var soundButton = SoundButton(size: CGSize(width: 40, height: 40), position: CGPoint(x: 150 , y: 90))
    private var checkButton = CheckButton(size: CGSize(width: 150, height: 55))
    private var accentBins = [SKSpriteNode]()
    private var selectedLineLabel = SKLabelNode()
    private var selectedLineBoldLabel = SKLabelNode()
    private var stressMarks = [SKSpriteNode]()
    private let stressedStressMarkParentBin = SKSpriteNode()
    private let stressed = SKLabelNode()
    private let unstressed = SKLabelNode()
    private let unstressedStressMarkParentBin = SKSpriteNode()
    
    // overlay nodes
    private var backgroundBlocker = SKSpriteNode()
    private var congratulations = Congratulations(size: CGSize(width: 650, height: 800))
    private var replyIsCorrect = ReplyIsCorrect(size: CGSize(width: 766, height: 350))
    private var replyIsFalse = ReplyIsFalse(size: CGSize(width: 766, height: 350))
    private var warning = Warning(size: CGSize(width: 650, height: 450))
    
    // variables for level passing management
    private lazy var correctlyMarkedLines = Set<Line>()
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
    
    // variable for the animation to help user understand to drag and drop to solve the task
    private var arrow = SKSpriteNode()
    
    /// Generates the animation to help user understand to drag and drop stressmarks to solve the task
    /// Animations stops as soon as all accent bins are filled with stressmarks for the first time in level 1
    func displayDragAndDropAnimation() {
        arrow = SKSpriteNode(texture: SKTexture(imageNamed: "arrow2"), color: .clear, size: CGSize(width: 100, height: 200))
        arrow.name = "arrow"
        arrow.position = CGPoint(x: -160, y: -80)
        arrow.zPosition = 1
        // arrow.zRotation = 50
        addChild(arrow)
        
        // start animation
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        arrow.run(SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn])))
    }
    
    /// Sets up the ui elements that don't get removed from and re-added to scene during level
    func setUpScene() {
        addChild(exitLabel)
        addChild(loadingBar)
        manageLoadingBar()
        addChild(taskLabel)
        if provideHelp {
            addChild(infoButton)
            addChild(soundButton)
        }
        addChild(checkButton)
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
        selectedLineLabel.attributedText = makeAttributedString(stringToBeMutated: selectedLine.line, shallBecomeBold: false, size: 50)
        selectedLineLabel.position = CGPoint(x: frame.midX, y: frame.midY-50)
        selectedLineLabel.zPosition = 2
        addChild(selectedLineLabel)

        selectedLineBoldLabel.name = "selectedLineBoldLabel"
        selectedLineBoldLabel.fontColor = SKColor.black
        selectedLineBoldLabel.attributedText = getLineToBeRatedBold(line: selectedLine)
        selectedLineBoldLabel.position = CGPoint(x: frame.midX, y: frame.midY-50)
        selectedLineBoldLabel.zPosition = 2
        
        generateAccentuationBins(line: selectedLine, lineToBeRated: selectedLineLabel)
        generateStressMarks()
        
        // reset colors of check button to gray
        checkButton.deactivate()
    }
    
    /// Returns the next Line for which the user has to solve the task.
    /// Does not select the previous Line, only if it is the last not correctly solved Line.
    ///
    /// - Returns: The newly selected Line.
    func selectNextLine() -> Line {
        let previousSelected = selectedLine
        
        // notYetCorrectlyMarkedLines gets all loadedLines if correctlyMarkedLines is empty in the beginning
        var notYetCorrectlyMarkedLines = loadedLines.subtracting(correctlyMarkedLines)
     
        // loops over all loadedLines if all lines have already been solved correctly
        if (notYetCorrectlyMarkedLines.isEmpty) {
            correctlyMarkedLines.removeAll()
            notYetCorrectlyMarkedLines = loadedLines
        }
    
        guard var newlySelected = notYetCorrectlyMarkedLines.randomElement() else {
            fatalError("error with loadedLines, so that notYetCorrectlyMarkedLines is nil")
        }
        // only one remaining line to be solved
        if (notYetCorrectlyMarkedLines.count==1) {
            // newlySelected contains that one line
            return newlySelected
        }
        
        while(previousSelected == newlySelected ) {
            // forced unwrapping is fine because notYetCorrectlyMarkedLines can't be nil
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
                    // let syllableNotBold = makeAttributedString(stringToBeMutated: syllable.syllableString + "·", shallBecomeBold: false)
                    let syllableNotBold = makeAttributedString(stringToBeMutated: syllable.syllableString + "·", shallBecomeBold: false, size: 50)

                    lineToBeRatedBold.append(syllableNotBold)
                }
                else if syllable.accentuation.rawValue == "stressed" {
                    let syllableBold = makeAttributedString(stringToBeMutated: syllable.syllableString + "·", shallBecomeBold: true, size: 50)
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
    
    /// Generates target bins per each syllable in which the stressMarks shall be dragged and dropped.
    /// Positions each target bin right over corresponding syllable.
    ///
    /// - Parameters:
    ///   - line: The Line for which the target bins shall be generated.
    ///   - linetoBeRated: The node of the Line to which the targets shall be added.
    func generateAccentuationBins(line: Line, lineToBeRated: SKLabelNode) {
        let amountOfCharsInLine = line.line.count
        // unit per char: dynamically calculated by frame.width divided by amount of chars
        let unit = CGFloat(lineToBeRated.frame.width / CGFloat(amountOfCharsInLine))
        
        var counter = CGFloat(0.0)
        for word in line.words {
            for syllable in word.syllables {
                let accentBin = SKSpriteNode()
                accentBin.color = SKColor.lightGray
                accentBin.size = CGSize(width: 40, height: 50)
                
                // half of amount of chars of syllable multiplied by unit plus counter
                // unit/2 is added since middle of four chars is index 2.5 with a unit of 1
                // 0.3 is subtracted since middlepoint has a very small width compared to regular chars
                let positionOfBin = CGFloat((Double(syllable.syllableString.count)-0.3)/2.0)*unit + unit/2 + counter
                accentBin.position = CGPoint(x: lineToBeRated.frame.minX+positionOfBin, y: frame.midY+25)
                accentBin.zPosition = 2
                accentBin.drawBorder(color: .orange, width: 4)
                // append to class variable
                accentBins.append(accentBin)
                
                // counter shifts to the next syllable
                counter += CGFloat(syllable.syllableString.count) * unit + unit/2
                addChild(accentBin)
            }
            // counter shifts to the next word
            // alternative values for counter: counter += 25, 15
            counter += 17
        }
    }
    
    /// Generates a stressed and an unstressed stressMarks that the user shall drag and drop into the accentBins.
    /// If the bin of a stress mark is empty a new stress mark spawns at the bin.
    func generateStressMarks() {
        generateStressedStressMark()
        generateUnstressedStressMark()
        
        // necessary to check whether spawn place of stress marks are filled with stress marks or empty
        stressedStressMarkParentBin.color = .clear
        stressedStressMarkParentBin.size = CGSize(width: 40, height: 50)
        stressedStressMarkParentBin.position = CGPoint(x: frame.midX-50, y: frame.midY-170)
        stressedStressMarkParentBin.zPosition = 2
        addChild(stressedStressMarkParentBin)
        unstressedStressMarkParentBin.color = .clear
        unstressedStressMarkParentBin.size = CGSize(width: 40, height: 50)
        unstressedStressMarkParentBin.position = CGPoint(x: frame.midX+50, y: frame.midY-170)
        unstressedStressMarkParentBin.zPosition = 2
        addChild(unstressedStressMarkParentBin)
    }
    
    /// Generates a stressed stress mark at specified stress mark spawning area.
    func generateStressedStressMark() {
        let stressedStressMarkParent = generateAStressMark(stressed: true, x: frame.midX-50, y: frame.midY-170)
        stressMarks.append(stressedStressMarkParent)
    }
    
    /// Generates an unstressed stress mark at specified stress mark spawning area.
    func generateUnstressedStressMark() {
        let unstressedStressMarkParent = generateAStressMark(stressed: false, x: frame.midX+50, y: frame.midY-170)
        stressMarks.append(unstressedStressMarkParent)
    }
    
    /// Returns parent node of a stress mark with a specified position.
    ///
    /// - Parameters:
    ///   - stressed: Indicates whether the stress mark should be stressed or unstressed.
    ///   - x: X position where the stress mark shall be positioned.
    ///   - y: Y position where the stress mark shall be positioned.
    /// - Returns: Parent node with stress mark with a specified position as a child.
    func generateAStressMark(stressed: Bool, x: CGFloat, y: CGFloat) -> SKSpriteNode {
        let stressMarkParent = SKSpriteNode()
        stressMarkParent.color = .white
        stressMarkParent.size = CGSize(width: 40, height: 50)
        stressMarkParent.position = CGPoint(x: x, y: y)
        stressMarkParent.drawBorder(color: .orange, width: 4)
        stressMarkParent.zPosition = 1
        
        let stressMark = SKLabelNode()
        stressMark.fontColor = SKColor.black
        stressMark.fontSize = 40
        stressMark.zPosition = 2
        stressMark.position = CGPoint(x: -stressMarkParent.frame.width/4+10, y: -stressMarkParent.frame.height/4)
        stressMark.addStroke(color: .black, width: 6)
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
    
    /// Adds AccentiationInfo as overlay node to scene.
    func displayAccentuationInfo() {
        backgroundBlocker = getBackgroundBlocker(shallBeTransparent: false, size: self.size)
        addChild(backgroundBlocker)
        accentuationInfo.delegate = self
        addChild(accentuationInfo)
    }

    /// Adds Congratualtions as overlay node to scene.
    func displayCongratulations() {
        backgroundBlocker = getBackgroundBlocker(shallBeTransparent: false, size: self.size)
        addChild(backgroundBlocker)
        congratulations.delegate = self
        addChild(congratulations)
    }
    
    /// Adds ReplyIsCorrect as overlay node to scene.
    func displayReplyIsCorrect() {
        backgroundBlocker = getBackgroundBlocker(shallBeTransparent: true, size: self.size)
        addChild(backgroundBlocker)
        replyIsCorrect.delegate = self
        addChild(replyIsCorrect)
    }
    
    /// Adds ReplyIsFalse as overlay node to scene.
    func displayReplyIsFalse(solution: String) {
        backgroundBlocker = getBackgroundBlocker(shallBeTransparent: true, size: self.size)
        addChild(backgroundBlocker)
        replyIsFalse.addSolutionToText(solution: solution)
        replyIsFalse.delegate = self
        addChild(replyIsFalse)
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
    /// Checks if all accent bins contain a stress mark
    ///
    /// - Returns: True if all accent bins contain a stress mark, false otherwise.
    func areAccentBinsFilledWithAStressmark() -> Bool {
        // TODO higher function
        // quick return since false is returned as soon as one accentBin is empty
        for accentBin in accentBins {
            if !(isAccentBinFilledWithAStressMark(accentBin: accentBin)) {
                return false
            }
        }
        return true
    }
    
    /// Relevant for check button.
    /// Checks whether an accent bin is filled with a stress mark.
    ///
    /// - Parameters:
    ///   - accentBin: Accent bin that is empty or filled with a stress mark.
    /// - Returns: True if the accent bin is filled with a stress mark, false otherwise.
    func isAccentBinFilledWithAStressMark(accentBin: SKSpriteNode) -> Bool {
        // TODO higher function
        for stressMark in stressMarks {
            if accentBin.position.equalTo(stressMark.position) {
                return true
            }
        }
        return false
    }
    
    /// Relevant for check button.
    /// Checks whether reply of user is correct or not.
    /// The reply is correct if the accentBins are filled with the correct stress marks.
    ///
    /// - Returns: The solution of the task and true if the reply is correct, false otherwise.
    func isReplyCorrect() -> (Bool, [String]) {
        var reply = [String]()
        var correctSolution = [String]()
        
        // get reply by getting the name of stressMarks sorted from left accentBin to the right
        // TODO higher function
        for accentBin in accentBins {
            for stressMark in stressMarks {
                if accentBin.position.equalTo(stressMark.position) {
                    // forced unwrapping is okay because stressmark gets a name in generateAStressMark()
                    reply.append(stressMark.name!)
                }
            }
        }
        
        // get correct accentuation of line
        // TODO higher order function
        for word in selectedLine.words {
            for syllable in word.syllables {
                correctSolution.append(syllable.accentuation.rawValue)
            }
        }
        
        if reply.elementsEqual(correctSolution) {
            return (true, correctSolution)
        }
        else {
            return (false, correctSolution)
        }
        
    }
    
    /// Relevant for check button.
    /// Sets user data of the level to true, if the level has been passed.
    func updateLevelStatus() {
        if (correctReplies >= amountOfCorrectRepliesToPassLevel) {
            UserDefaults.standard.set(true, forKey: userDefaultsKey)
        }
    }
    
    /// Relevant for check button.
    /// Returns solution with stress mark signs.
    /// Example: ["stressed", "unstressed"] is converted to "x́  x"
    ///
    /// - Parameters:
    ///   - solution: List of Strings that should be converted.
    /// - Returns: Converted String with stress mark signs.
    func solutionWithStressMarkSigns(solution: [String]) -> String{
        var result = ""
        for str in solution {
            if str == "stressed" {
                result.append("x́  ")
            }
            else {
                result.append("x  ")
            }
        }
        return result
    }
    
    /// Empties lists, removes unfix nodes and sets up scene again for new line to be solved.
    func cleanAndSetupSceneForNewLine() {
        // remove all accentBins and stressMarks from scene
        accentBins.forEach { $0.removeFromParent() }
        stressMarks.forEach { $0.removeFromParent() }
        // empty accentBins array and stressMarks array since new line is selected
        accentBins.removeAll()
        stressMarks.removeAll()
        
        selectedLineLabel.removeFromParent()
        stressedStressMarkParentBin.removeFromParent()
        unstressedStressMarkParentBin.removeFromParent()
        
        setUpUnfixedParts()
    }
    

    override func didMove(to view: SKView) {
        if(inputFile == "" || userDefaultsKey == "") {
            fatalError("hand over input file and userdefaultkeys")
        }
        
        // old version from main bundle: loadedLines = loadInputFileFromMainBundle(inputFile: inputFile)
        if let data = loadInputFileFromDocumentDirectory(fromDocumentsWithFileName: inputFile) {
            loadedLines = data
            selectedLine = loadedLines.first
        }
        else {
            fatalError("loading input file from document directory failed")
        }
        
        setUpScene()
        setUpUnfixedParts()
        
        // only show AccentuationInfo and helper animation, if level1 has not been passed yet
        if !(UserDefaults.standard.bool(forKey: "level1")) {
            displayAccentuationInfo()
            displayDragAndDropAnimation()
        }
        // current level has been passed, so we do not need to show congratulation window anymore
        // correctReplies as threshold has to be bigger than amountOfCorrectRepliesToPassLevel
        // because if threshold = amountOfCorrectRepliesToPassLevel, the congratulation is shown
        if (UserDefaults.standard.bool(forKey: userDefaultsKey)) {
            correctReplies = amountOfCorrectRepliesToPassLevel+1
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if(provideHelp && touchedNode.isEqual(to: infoButton)) {
            displayAccentuationInfo()
        }
        
        if(provideHelp && touchedNode.isEqual(to: soundButton)) {
            // node no longer receives touch events
            self.soundButton.isUserInteractionEnabled = true
            
            let playSound = SKAction.playSoundFileNamed(selectedLine.audioFile, waitForCompletion: false)
            let action =  SKAction.group([playSound,
                                          SKAction.run{self.addAndRemoveNode(node: self.selectedLineBoldLabel)},
                                          SKAction.run{self.hideAndUnhideNode(node: self.selectedLineLabel)}])
            self.run(action)
            
            // node waits 1.5 for lower levels, 4.0 for higher levels and reveices touch events again
            // otherwise app would crash since addAndRemoveNode would be operated although node is still in scene
            self.run(SKAction.wait(forDuration: longerDurationIfHigherLevels()), completion: {() -> Void in
                self.soundButton.isUserInteractionEnabled = false})
        }
        
        if (touchedNode.isEqual(to: checkButton)) || (touchedNode.parent == checkButton) {
            if areAccentBinsFilledWithAStressmark() {
                let (isReplyCorrect, realSolution) = self.isReplyCorrect()
                
                if (isReplyCorrect) {
                    correctlyMarkedLines.insert(selectedLine)
                    
                    correctReplies += 1
                    // check whether level is passed and save to boolean variable
                    updateLevelStatus()
                    // increase loadingbar but only if level has not been passed yet
                    manageLoadingBar()
                
                    displayReplyIsCorrect()
                }
                else {
                    let solution = solutionWithStressMarkSigns(solution: realSolution)
                    displayReplyIsFalse(solution: solution)
                }
            }
            else {
                // nothing happens since not every accentBin is filled with a stressMark
            }
            
        }
        
        if (touchedNode.isEqual(to: exitLabel)) {
            if(UserDefaults.standard.bool(forKey: userDefaultsKey)) {
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
        
        // dragging of stress marks to new location by touching
        // TODO higher function
        for (smIndex, stressMark) in stressMarks.enumerated() {
            if stressMark.frame.contains(touch.previousLocation(in: self)) {
                stressMark.position = touch.location(in: self)
            }
            // if stress marks collide, they do not stick together anymore
            for (sIndex, s) in stressMarks.enumerated() {
                if (stressMark.position.equalTo(s.position)) && (smIndex != sIndex) {
                    stressMark.position = CGPoint(x: stressMark.position.x, y: stressMark.position.y-100)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // stress marks clinch (einrasten) into accentBin
        // TODO higher function
        for accentBin in accentBins {
            for stressMark in stressMarks {
                if accentBin.frame.intersects(stressMark.frame) {
                    stressMark.position = accentBin.position
                }
            }
        }
        
        // if stress mark.position is not in frame anymore, position it back to the center of the scene
        // TODO higher function
        for stressMark in stressMarks {
            if !(frame.contains(stressMark.position)) {
                stressMark.position = CGPoint(x: frame.midX, y: frame.midY-150)
            }
        }
        
        // generate new stress mark if spawn is empty
        // TODO higher function
        var stressedStressMarkSpawnIsFilled = Set<Bool>()
        var unstressedStressMarkSpawnIsFilled = Set<Bool>()
        for stressMark in stressMarks {
            stressedStressMarkSpawnIsFilled.insert((stressedStressMarkParentBin.frame.contains(stressMark.position)))
            unstressedStressMarkSpawnIsFilled.insert((unstressedStressMarkParentBin.frame.contains(stressMark.position)))
        }
        // if spawn set only contains false, it is empty
        if !(stressedStressMarkSpawnIsFilled.contains(true)) {
            generateStressedStressMark()
        }
        if !(unstressedStressMarkSpawnIsFilled.contains(true)) {
            generateUnstressedStressMark()
        }
        stressedStressMarkSpawnIsFilled.removeAll()
        unstressedStressMarkSpawnIsFilled.removeAll()
        
        // signalize user that pushing the button would lead to an action now
        if (areAccentBinsFilledWithAStressmark()) {
            // remove helper animation when accent bins are filled for the first time
            if let arrow = self.childNode(withName: "arrow") {
                arrow.removeFromParent()
            }
            
            checkButton.activate()
        }
        else {
            checkButton.deactivate()
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}


extension LevelOneToFourScene: AccentuationInfoDelegate, ReplyIsCorrectDelegate, ReplyIsFalseDelegate, CongratulationsDelegate, WarningDelegate {
    func closeAccentuationInfo() {
        // self.backgroundBlockerTest.removeFromParent()
        //backgroundBlocker.removeFromParent()
        //self.childNode(withName: "backgroundBlocker")?.removeFromParent()
        backgroundBlocker.removeFromParent()
        accentuationInfo.removeFromParent()
    }
    
    func closeCongratulations() {
        let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
        self.view?.presentScene(mainMenu)
    }
    
    func closeReplyIsCorrect() {
        backgroundBlocker.removeFromParent()
        replyIsCorrect.removeFromParent()
        
        if correctReplies == amountOfCorrectRepliesToPassLevel {
            displayCongratulations()
        }
        else {
            cleanAndSetupSceneForNewLine()
        }
    }
    
    func closeReplyIsFalse() {
        backgroundBlocker.removeFromParent()
        replyIsFalse.removeFromParent()
        cleanAndSetupSceneForNewLine()
    }
    
    func exitWarning() {
        let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
        self.view?.presentScene(mainMenu)
    }
    
    func closeWarning() {
        backgroundBlocker.removeFromParent()
        warning.removeFromParent()
    }
    
    // both did not work
    // https://forums.raywenderlich.com/t/swift-tutorial-initialization-in-depth-part-2-2/13209/3
    // https://spritekitswift.wordpress.com/2015/10/21/spritekit-custom-skscene-class-from-abstract-skscene-class-with-swift/
    //    convenience init?(fileNamed: String, provideHelp: Bool, inputFile: String) {
    //        // super.init(size: size)
    //        self.init(fileNamed: "fileNamed")
    //        self.provideHelp = provideHelp
    //        self.inputFile = inputFile
    //    }
    
    // TODO modularize overlay nodes
    //    func displayOverlayNode(node: SKSpriteNode, size: CGSize, transparent: Bool) {
    //        getBackgroundBlockerTest(shallBeTransparent: false, size: self.size)
    //        backgroundBlocker = backgroundBlockerTest
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
}
