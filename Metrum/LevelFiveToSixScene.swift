//
//  LevelFiveToSix.swift
//  Metrum
//
// Class that represents a scene for level five to six of Metrum App.
// After initializing the provideHelp and userDefaultsKey properties need to be specified.
//
//  Created by Jonas Jonas on 19.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//
import SpriteKit

class LevelFiveToSixScene: SKScene {
    // UI variables
    private var exitLabel = ExitLabel()
    private let loadingBar = LoadingBar(color: .green, size: CGSize(width: 600, height: 26))
    private var measureInfo = MeasureInfo(size: CGSize(width: 650, height: 800))
    private var infoButton = InfoButton(size: CGSize(width: 50, height: 50), position: CGPoint(x: 180 , y: 60))
    private var checkButton = CheckButton(size: CGSize(width: 150, height: 55))
    private let selectedMeasureLabel = SKLabelNode()
    private var accentBins = [SKSpriteNode]()
    private var stressMarks = [SKSpriteNode]()
    private let stressedStressMarkParentBin = SKSpriteNode()
    private let stressed = SKLabelNode()
    private let unstressedStressMarkParentBin = SKSpriteNode()
    private let unstressed = SKLabelNode()
    
    // overlay nodes
    private var backgroundBlocker = SKSpriteNode()
    private var congratulations = Congratulations(size: CGSize(width: 650, height: 800))
    private var replyIsCorrect = ReplyIsCorrect(size: CGSize(width: 766, height: 350))
    private var replyIsFalse = ReplyIsFalse(size: CGSize(width: 766, height: 350))
    private var warning = Warning(size: CGSize(width: 650, height: 450))
    
    // variables for level passing management
    private lazy var correctlyBuildMeasures = Set<Measure>()
    private var amountOfCorrectRepliesToPassLevel = 4
    private var correctReplies = 0
    
    // variables for input data
    private lazy var measures: Set<Measure> = [Measure.jambus, Measure.trochaeus, Measure.anapaest, Measure.daktylus]
    // TODO check whether forced unwrapping is appropriate here
    private var selectedMeasure: Measure!
    
    // TODO check if handing over properties via init / constructor is better
    public var provideHelp = false
    public var userDefaultsKey = ""
    
    /// Sets up the ui elements that don't get removed from and re-added to scene during level
    func setUpScene() {
        addChild(exitLabel)
        addChild(loadingBar)
        manageLoadingBar()
        if provideHelp {
            addChild(infoButton)
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
    /// Displays new Measure for which user has to solve task for.
    func setUpUnfixedParts() {
        // TODO right position in code?
        selectedMeasure = selectNextMeasure()
        
        selectedMeasureLabel.fontColor = SKColor.black
        selectedMeasureLabel.text = generateTaskLabelForSelectedMeasure(measure: selectedMeasure)
        selectedMeasureLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        selectedMeasureLabel.numberOfLines = 0
        selectedMeasureLabel.preferredMaxLayoutWidth = 580
        selectedMeasureLabel.position = CGPoint(x: frame.midX , y: frame.midY+180)
        selectedMeasureLabel.zPosition = 4
        addChild(selectedMeasureLabel)
        
        generateAccentuationBins(measure: selectedMeasure)
        generateStressMarks()
        
        // reset colors of check button
        checkButton.deactivate()
    }
    
    /// Returns the next Measure for which the user has to solve the task.
    /// Does not select the previous Measure.
    ///
    /// - Returns: The newly selected Measure.
    func selectNextMeasure() -> Measure {
        let previousSelected = selectedMeasure
        
        // notYetCorrectlyBuildMeasures gets all measures if correctlyBuildMeasures is empty in the beginning
        var notYetCorrectlyBuildMeasures = measures.subtracting(correctlyBuildMeasures)
        
        // loops over all measures if all measures have already been build correctly
        if (notYetCorrectlyBuildMeasures.isEmpty) {
            correctlyBuildMeasures.removeAll()
            notYetCorrectlyBuildMeasures = measures
        }
        
        guard var newlySelected = notYetCorrectlyBuildMeasures.randomElement() else {
            fatalError("error with measures")
        }
        // only one remaining measure to be build
        if (notYetCorrectlyBuildMeasures.count==1) {
            // newlySelected contains that one measure
            return newlySelected
        }
        
        while(previousSelected == newlySelected ) {
            // forced unwrapping is fine because notYetCorrectlyMarkedLines can't be nil
            newlySelected = notYetCorrectlyBuildMeasures.randomElement()!
        }
        return newlySelected
    }
    
    /// Generates the text for the task label.
    ///
    /// - Parameters:
    ///   - selectedMeasure: The Measure for which the task label should be generated.
    /// - Returns: The generated task label text corresponding to the selected Measure.
    func generateTaskLabelForSelectedMeasure(measure: Measure) -> String {
        var taskLabelText = ""
        switch measure {
        case .jambus:
            taskLabelText = "Welches Betonungsmuster wird Jambus 👻 genannt?\n"
                            + "Ziehe die Betonungszeichen in der richtigen Reihenfolge in die grauen Kästchen!"
        case .trochaeus:
            taskLabelText = "Welches Betonungsmuster wird als   Trochäus ☀️ bezeichnet?\n"
                            + "Ziehe die Betonungszeichen in der richtigen Reihenfolge in die grauen Kästchen!"
        case .anapaest:
            taskLabelText = "Welches Betonungsmuster wird Anapäst 🐘 genannt?\n"
                            + "Ziehe die Betonungszeichen in der richtigen Reihenfolge in die grauen Kästchen!"
        case .daktylus:
            taskLabelText = "Welches Betonungsmuster wird als   Daktylus 🥦 bezeichnet?\n"
                            + "Ziehe die Betonungszeichen in der richtigen Reihenfolge in die grauen Kästchen!"
        }
        return taskLabelText
    }

    /// Generates target bins per each syllable in which the stressMarks shall be dragged and dropped.
    ///
    /// - Parameters:
    ///   - measure: The Measure for which the target bins shall be generated.
    func generateAccentuationBins(measure: Measure) {
        switch measure {
        case .jambus:
            generateTwoAccentBins()
        case .trochaeus:
            generateTwoAccentBins()
        case .anapaest:
            generateThreeAccentBins()
        case .daktylus:
            generateThreeAccentBins()
        }
    }
    
    /// Generates two accent bins and add them to scene.
    func generateTwoAccentBins() {
        var counter = CGFloat(-60)
        for _ in 1...2 {
            let accentBin = SKSpriteNode()
            accentBin.color = SKColor.lightGray
            accentBin.size = CGSize(width: 40, height: 50)
            accentBin.position = CGPoint(x: frame.midX+counter, y: frame.midY)
            accentBin.drawBorder(color: .orange, width: 4)
            accentBin.zPosition = 2
            accentBins.append(accentBin)
            addChild(accentBin)

            counter += 120
        }
    }
    
    /// Generates three accent bins and add them to scene.
    func generateThreeAccentBins() {
        var counter = CGFloat(-80)
        for _ in 1...3 {
            let accentBin = SKSpriteNode()
            accentBin.color = SKColor.lightGray
            accentBin.size = CGSize(width: 40, height: 50)
            accentBin.position = CGPoint(x: frame.midX+counter, y: frame.midY)
            accentBin.drawBorder(color: .orange, width: 4)
            accentBin.zPosition = 2
            accentBins.append(accentBin)
            addChild(accentBin)

            counter += 80
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
            // stressMarkParent.name = "stressed"
            stressMarkParent.name = "x́"

        }
        else {
            stressMark.text = "x"
            // stressMarkParent.name = "unstressed"
            stressMarkParent.name = "x"
        }
        stressMarkParent.addChild(stressMark)
        addChild(stressMarkParent)
        return stressMarkParent
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
        
        // get correct stress marks of measure
        // TODO rethink forced unwrapping of selectedMeasure
        switch selectedMeasure! {
        case .jambus:
            correctSolution = ["x", "x́"]
        case .trochaeus:
            correctSolution = ["x́", "x"]
        case .anapaest:
            correctSolution = ["x", "x", "x́"]
        case .daktylus:
            correctSolution = ["x́", "x", "x"]
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
    
    /// Empties lists, removes unfix nodes and sets up scene again for new Measure to be solved.
    func cleanAndSetupSceneForNewMeasure() {
        // remove all accentBins and stressMarks from scene
        accentBins.forEach { $0.removeFromParent() }
        stressMarks.forEach { $0.removeFromParent() }
        // empty accentBins array and stressMarks array since new Measure is selected
        accentBins.removeAll()
        stressMarks.removeAll()
        
        selectedMeasureLabel.removeFromParent()
        stressedStressMarkParentBin.removeFromParent()
        unstressedStressMarkParentBin.removeFromParent()
        
        setUpUnfixedParts()
    }
    
    
    override func didMove(to view: SKView) {
        if(userDefaultsKey == "") {
            fatalError("hand over userdefaultkeys")
        }
        
        setUpScene()
        setUpUnfixedParts()
        
        // only show AccentuationInfo, if level5 has not been passed yet
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
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if(provideHelp && touchedNode.isEqual(to: infoButton)) {
            displayMeasureInfo()
        }
        
        if (touchedNode.isEqual(to: checkButton)) || (touchedNode.parent == checkButton) {
            if areAccentBinsFilledWithAStressmark() {
                let (isSolutionCorrect, realSolution) = self.isReplyCorrect()
                
                if (isSolutionCorrect) {
                    correctlyBuildMeasures.insert(selectedMeasure)

                    correctReplies += 1
                    // check whether level is passed and save to boolean variable
                    updateLevelStatus()
                    // increase loadingbar but only if level has not been passed yet
                    manageLoadingBar()
                    
                    // play sound to reward user for success
                    let playRewardSound = SKAction.playSoundFileNamed("ReplyIsCorrect.mp3", waitForCompletion: false)
                    self.run(playRewardSound)
                    
                    displayReplyIsCorrect()
                }
                else {
                    // convert ["x", "x", "x́"] to "x x x́"
                    let solution = realSolution.reduce("") { $0 + $1 + " "}
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


extension LevelFiveToSixScene: MeasureInfoDelegate, ReplyIsCorrectDelegate, ReplyIsFalseDelegate, CongratulationsDelegate, WarningDelegate {
    func closeMeasureInfo() {
        backgroundBlocker.removeFromParent()
        measureInfo.removeFromParent()
    }
    
    func exitCongratulations() {
        let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
        self.view?.presentScene(mainMenu)
    }
    
    func closeCongratulations() {
        backgroundBlocker.removeFromParent()
        congratulations.removeFromParent()
    }
    
    func closeReplyIsCorrect() {
        backgroundBlocker.removeFromParent()
        replyIsCorrect.removeFromParent()
        cleanAndSetupSceneForNewMeasure()

        if correctReplies == amountOfCorrectRepliesToPassLevel {
            displayCongratulations()
        }
    }
    
    func closeReplyIsFalse() {
        backgroundBlocker.removeFromParent()
        replyIsFalse.removeFromParent()
        cleanAndSetupSceneForNewMeasure()
    }
    
    func exitWarning() {
        let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
        self.view?.presentScene(mainMenu)
    }
    
    func closeWarning() {
        backgroundBlocker.removeFromParent()
        warning.removeFromParent()
    }
}
