//
//  LevelOneToFourScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 06.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

class LevelOneToFourScene: SKScene {
    // UI variables
    private var exitLabel = SKLabelNode()
    private var loadingBar = SKSpriteNode()
    private let taskLabel = SKLabelNode()
    private var accentBins = [SKSpriteNode]()
    private var selectedLineLabel = SKLabelNode()
    private var selectedLineBoldLabel = SKLabelNode()
    private var stressMarks = [SKSpriteNode]()
    private let stressedStressMarkParentBin = SKSpriteNode()
    private let stressed = SKLabelNode()
    private let unstressed = SKLabelNode()
    private let unstressedStressMarkParentBin = SKSpriteNode()
    private var accentuationInfoButton = SKSpriteNode()
    private var accentuationInfo: AccentuationInfo!
    private var soundBoxButton = SKSpriteNode()
    private var checkButtonFrame = SKSpriteNode()
    private var checkButton = SKLabelNode()
    // overlay nodes
    // TODO check whether forced unwrapping is appropriate here
    private var backgroundBlocker: SKSpriteNode!
    private var overlay: SKSpriteNode!
    private var congratulations: Congratulations!
    private var replyIsCorrect: ReplyIsCorrect!
    private var replyIsFalse: ReplyIsFalse!
    private var warning: Warning!
    
    // variables for level passing management
    // lazy: https://stackoverflow.com/questions/45423321/cannot-use-instance-member-within-property-initializer#comment101019582_45423454
    lazy private var correctlyMarkedLines = Set<Line>()
    private var amountOfCorrectRepliesToPassLevel = 4
    private var correctRepliesLevelOne = 0
    
    // variables for input data
    lazy var loadedLines = Set<Line>()
    // TODO check whether forced unwrapping is appropriate here
    private var selectedLine: Line!
    
    // TODO check if handing over properties via init / constructor is better
    public var provideHelp = false
    public var inputFile = ""
    public var userDefaultsKey = ""
    
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
        taskLabel.text = "Markiere die betonten (x́) und unbetonten (x) Silben.\n"
                         + "Zu jeder Silbe gehört ein graues Kästchen, das über ihr platziert ist. " +
                        "Ziehe die Betonungszeichen in das jeweilige Kästchen über der Silbe.\n"
        taskLabel.position = CGPoint(x: frame.midX , y: frame.midY+150)
        // break line: https://forums.developer.apple.com/thread/82994
        taskLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        taskLabel.numberOfLines = 0
        taskLabel.preferredMaxLayoutWidth = 480
        taskLabel.zPosition = 4
        addChild(taskLabel)
        
        if provideHelp {
            // accentuationInfoButton = SKSpriteNode(imageNamed: "info")
            accentuationInfoButton = SKSpriteNode(imageNamed: "icons8-info-50")
            accentuationInfoButton.name = "accentuationInfoBtn"
            accentuationInfoButton.position = CGPoint(x: frame.midX+225 , y: frame.midY+90)
            accentuationInfoButton.size = CGSize(width: 50, height: 50)
            accentuationInfoButton.zPosition = 2
            addChild(accentuationInfoButton)
            
            // soundBoxButton = SKSpriteNode(imageNamed: "sound")
            soundBoxButton = SKSpriteNode(imageNamed: "QuickActions_Audio")
            soundBoxButton.name = "soundBoxBtn"
            soundBoxButton.position = CGPoint(x: frame.midX+150 , y: frame.midY+90)
            soundBoxButton.size = CGSize(width: 40, height: 40)
            soundBoxButton.zPosition = 2
            addChild(soundBoxButton)
        }
        
        checkButtonFrame.color = .lightGray
        checkButtonFrame.size = CGSize(width: 150, height: 55)
        checkButtonFrame.position = CGPoint(x: frame.midX+200, y: frame.midY-350)
        addChild(checkButtonFrame)
        
        checkButton.text = "Check"
        checkButton.name = "check"
        checkButton.position = CGPoint(x: frame.midX, y: frame.midY-15)
        checkButton.zPosition = 2
        checkButton.fontColor = SKColor.darkGray
        checkButton.addStroke(color: .darkGray, width: 6.0)
        checkButtonFrame.addChild(checkButton)
    }
    
    /// Manages loading Bar.
    /// Every time the user replies correctly, the loading bar gets increased.
    /// If the user has passed the level, the loading bar remains full.
    func manageLoadingBar() {
        // TODO check complexity / higher function
        let levelOneIsPassed = UserDefaults.standard.bool(forKey: userDefaultsKey)
        
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
    
    /// Sets up the ui elements that get removed from and re-added to scene during level.
    /// Displays new Line for which user has to solve task for.
    func setUpUnfixedParts() {
        // TODO right position in code?
        selectedLine = selectNextLine()
        
        selectedLineLabel.fontColor = SKColor.black
        // CHECK
        // selectedLineLabel = makeAttributedString(stringToBeMutated: (selected.line), shallBecomeBold: false)
        selectedLineLabel.attributedText = makeAttributedString(stringToBeMutated: (selectedLine.getLine()), shallBecomeBold: false)
        selectedLineLabel.position = CGPoint(x: frame.midX, y: frame.midY-50)
        selectedLineLabel.zPosition = 2
        addChild(selectedLineLabel)

        selectedLineBoldLabel.fontColor = SKColor.black
        selectedLineBoldLabel.attributedText = getLineToBeRatedBold(line: selectedLine)
        selectedLineBoldLabel.position = CGPoint(x: frame.midX, y: frame.midY-50)
        selectedLineBoldLabel.zPosition = 2
        // addChild(selectedLineBoldLabel)
        
        generateAccentuationBins(line: selectedLine, lineToBeRated: selectedLineLabel)
        generateStressMarks()
        
        // reset colors of check button
        checkButtonFrame.color = .lightGray
        checkButton.fontColor = .darkGray
        checkButton.addStroke(color: .darkGray, width: 6.0)
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
    
    /// Returns String as NSMutableAttributedString and when indicated in bold.
    ///
    /// - Parameters:
    ///   - stringToBeMutated: The String which should be returnded.
    ///   - shallBecomceBold: This Boolean says whether String shall be bold or not.
    /// - Returns: The String as NSMutableAttributedString.
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
                    let syllableNotBold = makeAttributedString(stringToBeMutated: syllable.syllableString + "·", shallBecomeBold: false)
                    lineToBeRatedBold.append(syllableNotBold)
                }
                else if syllable.accentuation.rawValue == "stressed" {
                    let syllableBold = makeAttributedString(stringToBeMutated: syllable.syllableString + "·", shallBecomeBold: true)
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
        // CHECK
        // let amountOfCharsInLine = line.line.count
        let amountOfCharsInLine = line.getLine().count
        // unit per char: dynamically calculated by frame.width divided by amount of chars
        let unit = CGFloat(lineToBeRated.frame.width / CGFloat(amountOfCharsInLine))
        
        var counter = CGFloat(0.0)
        for word in line.words {
            for syllable in word.syllables {
                let accentBin = SKSpriteNode()
                accentBin.color = SKColor.lightGray
                accentBin.size = CGSize(width: 40, height: 45)
                
                // half of amount of chars of syllable multiplied by unit plus counter
                // unit/2 is added since middle of four chars is index 2.5 with a unit of 1
                // 0.3 is subtracted since middlepoint has a very small width compared to regular chars
                let positionOfBin = CGFloat((Double(syllable.syllableString.count)-0.3)/2.0)*unit + unit/2 + counter
                accentBin.position = CGPoint(x: lineToBeRated.frame.minX+positionOfBin, y: frame.midY+25)
                accentBin.zPosition = 2
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
        // https://stackoverflow.com/questions/42026839/make-touch-area-for-sklabelnode-bigger-for-small-characters#comment71238691_42026839
        generateStressedStressMark()
        generateUnstressedStressMark()
        
        // necessary to check whether spawn place of stress marks are filled with stress marks or empty
        stressedStressMarkParentBin.color = .clear
        stressedStressMarkParentBin.size = CGSize(width: 40, height: 50)
        stressedStressMarkParentBin.position = CGPoint(x: frame.midX-40, y: frame.midY-150)
        stressedStressMarkParentBin.zPosition = 2
        addChild(stressedStressMarkParentBin)
        unstressedStressMarkParentBin.color = .clear
        unstressedStressMarkParentBin.size = CGSize(width: 40, height: 50)
        unstressedStressMarkParentBin.position = CGPoint(x: frame.midX+40, y: frame.midY-150)
        unstressedStressMarkParentBin.zPosition = 2
        addChild(unstressedStressMarkParentBin)
    }
    
    /// Generates a stressed stress mark at specified stress mark spawning area.
    func generateStressedStressMark() {
        let stressedStressMarkParent = generateAStressMark(stressed: true, x: frame.midX-40, y: frame.midY-150)
        stressMarks.append(stressedStressMarkParent)
    }
    
    /// Generates an unstressed stress mark at specified stress mark spawning area.
    func generateUnstressedStressMark() {
        let unstressedStressMarkParent = generateAStressMark(stressed: false, x: frame.midX+40, y: frame.midY-150)
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
    
    /// Adds AccentiationInfo as overlay node to scene.
    func displayAccentuationInfo() {
        backgroundBlocker = SKSpriteNode(color: SKColor.white, size: self.size)
        backgroundBlocker.zPosition = 4999
        addChild(backgroundBlocker)
        
        accentuationInfo = AccentuationInfo(size: CGSize(width: 650, height: 800))
        accentuationInfo.delegate = self
        accentuationInfo.zPosition = 5000
        addChild(accentuationInfo)
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
    
    /// Adds ReplyIsCorrect as overlay node to scene.
    func displayReplyIsCorrect() {
        backgroundBlocker = SKSpriteNode(color: SKColor.white, size: self.size)
        backgroundBlocker.zPosition = 4999
        backgroundBlocker.alpha = 0.5
        addChild(backgroundBlocker)
        
        replyIsCorrect = ReplyIsCorrect(size: CGSize(width: 747, height: 350))
        replyIsCorrect.delegate = self
        replyIsCorrect.zPosition = 5000
        addChild(replyIsCorrect)
    }
    
    /// Adds ReplyIsFalse as overlay node to scene.
    func displayReplyIsFalse(solution: String) {
        backgroundBlocker = SKSpriteNode(color: SKColor.white, size: self.size)
        backgroundBlocker.zPosition = 4999
        backgroundBlocker.alpha = 0.5
        addChild(backgroundBlocker)
        
        replyIsFalse = ReplyIsFalse(size: CGSize(width: 747, height: 350), solution: solution)
        replyIsFalse.delegate = self
        replyIsFalse.zPosition = 5000
        addChild(replyIsFalse)
    }
    
    // Adds Warning as overlay node to scene.
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
    /// - Returns: A duration of one second or three seconds if it is a higher level.
    func longerDurationIfHigherLevels() -> TimeInterval{
        var duration = TimeInterval(1.0)
        if (userDefaultsKey == "level3" || userDefaultsKey == "level4" || userDefaultsKey == "level9" || userDefaultsKey == "level10") {
            duration = TimeInterval(3.0)
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
                    reply.append(stressMark.name!)
                }
            }
        }
        
        // get correct accentuation of line
        // TODO modularize
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
        if (correctRepliesLevelOne >= amountOfCorrectRepliesToPassLevel) {
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
    func cleanAndSetupSceneForNewWord() {
        // remove all accentBins and stressMarks from scene
        accentBins.forEach { $0.removeFromParent() }
        stressMarks.forEach { $0.removeFromParent() }

        // empty accentBins array and stressMarks array since new word is selected
        accentBins.removeAll()
        stressMarks.removeAll()
        
        selectedLineLabel.removeFromParent()
        
        stressedStressMarkParentBin.removeFromParent()
        unstressedStressMarkParentBin.removeFromParent()
        
        setUpUnfixedParts()
    }
    

    override func didMove(to view: SKView) {
        loadInputFile()
        setUpScene()
        setUpUnfixedParts()
        
        // only show AccentuationInfo, if level1 has not been passed yet
        if !(UserDefaults.standard.bool(forKey: "level1")) {
            displayAccentuationInfo()
        }
        // current level has been passed, so we do not need to show congratulation window anymore
        // correctRepliesLevelOne as threshold has to be bigger than amountOfCorrectRepliesToPassLevel
        // because if threshold = amountOfCorrectRepliesToPassLevel, the congratulation is shown
        if (UserDefaults.standard.bool(forKey: userDefaultsKey)) {
            correctRepliesLevelOne = amountOfCorrectRepliesToPassLevel+1
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // https://code.tutsplus.com/tutorials/spritekit-basics-nodes--cms-28785
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if(provideHelp && touchedNode.name == "accentuationInfoBtn") {
            displayAccentuationInfo()
        }
        
        if(provideHelp && touchedNode.name == "soundBoxBtn") {
            // https://www.reddit.com/r/swift/comments/2wpspa/running_parallel_skactions_with_different_nodes/
            // https://stackoverflow.com/questions/28823386/skaction-playsoundfilenamed-fails-to-load-sound
            // worked as well
            // audioNode.run(SKAction.playSoundFileNamed("Sonne.WAV", waitForCompletion: false))
            // audioNode.run(SKAction.playSoundFileNamed("test.WAV", waitForCompletion: false))
            let playSound = SKAction.playSoundFileNamed(selectedLine.audioFile, waitForCompletion: false)
            let action =  SKAction.group([playSound,
                                          SKAction.run{self.addAndRemoveNode(node: self.selectedLineBoldLabel)},
                                          SKAction.run{self.hideAndUnhideNode(node: self.selectedLineLabel)}])
            self.run(action)
        }
        
        if (touchedNode.name == "check") {
            if areAccentBinsFilledWithAStressmark() {
                let (isSolutionCorrect, realSolution) = self.isReplyCorrect()
                
                if (isSolutionCorrect) {
                    correctlyMarkedLines.insert(selectedLine)
                    
                    correctRepliesLevelOne += 1
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
                print("do fill in every accentBin with a stressMark")
            }
            
        }
        
        if (touchedNode.name == "exit") {
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
        
        // dragging of stress marks to new location by touching
        // TODO higher function
        for (smIndex, stressMark) in stressMarks.enumerated() {
            if stressMark.frame.contains(touch.previousLocation(in: self)) {
                stressMark.position = touch.location(in: self)
            }
            // if stress marks collide, they do not stick together anymore
            for (sIndex, s) in stressMarks.enumerated() {
                if (stressMark.position.equalTo(s.position)) && (smIndex != sIndex) {
                    stressMark.position = CGPoint(x: stressMark.position.x-80, y: stressMark.position.y-40)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // stress marks clinch (einrasten) into accentBin
        // TODO higher function
        for accentBin in accentBins {
            // https://www.hackingwithswift.com/example-code/games/how-to-color-an-skspritenode-using-colorblendfactor
            // https://stackoverflow.com/questions/36136665/how-to-animate-a-matrix-changing-the-sprites-one-by-one
            for stressMark in stressMarks {
                if accentBin.frame.contains(stressMark.position) {
                    stressMark.position = accentBin.position
                }
            }
        }
        
        // if stress mark.position is not in frame anymore, position it back to the center of the scene
        // TODO higher function
        for stressMark in stressMarks {
            if !(frame.contains(stressMark.position)) {
                print("lost a stressMark to the infinite nonentity")
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
        
        // to signalize user that pushing the button would lead to an action now
        if (areAccentBinsFilledWithAStressmark()) {
            checkButtonFrame.color = .green
            checkButton.fontColor = .white
            checkButton.addStroke(color: .white, width: 6.0)
        }
        else {
            checkButtonFrame.color = .lightGray
            checkButton.fontColor = .darkGray
            checkButton.addStroke(color: .darkGray, width: 6.0)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}



extension LevelOneToFourScene: AccentuationInfoDelegate, ReplyIsCorrectDelegate, ReplyIsFalseDelegate, CongratulationsDelegate, WarningDelegate {
    func closeAccentuationInfo() {
        backgroundBlocker.removeFromParent()
        accentuationInfo?.removeFromParent()
    }
    
    func closeCongratulations() {
        // https://stackoverflow.com/questions/46954696/save-state-of-gamescene-through-transitions
        let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
        self.view?.presentScene(mainMenu)
    }
    
    func closeReplyIsCorrect() {
        backgroundBlocker.removeFromParent()
        replyIsCorrect?.removeFromParent()
        
        if correctRepliesLevelOne == amountOfCorrectRepliesToPassLevel {
            displayCongratulations()
        }
        else {
            cleanAndSetupSceneForNewWord()
        }
    }
    
    func closeReplyIsFalse() {
        backgroundBlocker.removeFromParent()
        replyIsFalse?.removeFromParent()
        cleanAndSetupSceneForNewWord()
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
