//
//  LevelFiveToSix.swift
//  Metrum
//
// Class that represents a scene for level five to six of Metrum App.
// After initializing the userDefaultsKey property needs to be specified.
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
    private var stressMarks = [StressMark]()
    private let stressedStressMarkSpawn = SKSpriteNode()
    private let stressedStressMarkSpawnLocation = CGPoint(x: -50, y: -170)
    private let unstressedStressMarkSpawn = SKSpriteNode()
    private let unstressedStressMarkSpawnLocation = CGPoint(x: 50, y: -170)
    
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
    public var provideHelp: Bool?
    public var userDefaultsKey = ""
    
    
    override func didMove(to view: SKView) {
        if(userDefaultsKey == "") {
            fatalError("hand over userdefaultkeys")
        }
        
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
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if(touchedNode.isEqual(to: infoButton)) {
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
        for (index, stressMark) in stressMarks.enumerated() {
            if stressMark.frame.contains(touch.previousLocation(in: self)) {
                stressMark.position = touch.location(in: self)
            }
            // if stress marks collide, they do not stick together anymore
            for (otherIndex, otherStressMark) in stressMarks.enumerated() {
                if (stressMark.position.equalTo(otherStressMark.position)) && (index != otherIndex) {
                    stressMark.position = CGPoint(x: stressMark.position.x, y: stressMark.position.y-100)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        spawnNewStressMarkIfNecessary()
        removeStressMarkIfRemovedFromAccentBin()
        
        // if stress mark.position is not in frame anymore, position it back to the center of the scene
        // TODO higher function
        for stressMark in stressMarks {
            if !(frame.contains(stressMark.position)) {
                print("lost a stressMark to the infinite nonentity")
                stressMark.position = CGPoint(x: frame.midX, y: frame.midY-150)
            }
        }
        
        // signalize user that pushing the button would lead to an action now
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
    
    
    /// Sets up the ui elements that don't get removed from and re-added to scene during level
    func setUpScene() {
        addChild(exitLabel)
        addChild(loadingBar)
        manageLoadingBar()
        if provideHelp != nil && provideHelp == true {
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
        stressedStressMarkSpawn.color = .clear
        stressedStressMarkSpawn.size = CGSize(width: 40, height: 50)
        stressedStressMarkSpawn.position = stressedStressMarkSpawnLocation
        stressedStressMarkSpawn.zPosition = 2
        addChild(stressedStressMarkSpawn)
        unstressedStressMarkSpawn.color = .clear
        unstressedStressMarkSpawn.size = CGSize(width: 40, height: 50)
        unstressedStressMarkSpawn.position = unstressedStressMarkSpawnLocation
        unstressedStressMarkSpawn.zPosition = 2
        addChild(unstressedStressMarkSpawn)
    }
    
    /// Generates a stressed stress mark at specified stress mark spawning area.
    func generateStressedStressMark() {
        let stressMark = StressMark(isStressed: true, position: stressedStressMarkSpawnLocation)
        addChild(stressMark)
        stressMarks.append(stressMark)
    }
    
    /// Generates an unstressed stress mark at specified stress mark spawning area.
    func generateUnstressedStressMark() {
        let stressMark = StressMark(isStressed: false, position: unstressedStressMarkSpawnLocation)
        addChild(stressMark)
        stressMarks.append(stressMark)
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
                    if stressMark.name! == "stressed" {
                        reply.append("x́")
                    }
                    else {
                        reply.append("x")
                    }
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
            print("your answer: " + reply.description)
            return (true, correctSolution)
        }
        else {
            print("your answer: " + reply.description)
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
        stressedStressMarkSpawn.removeFromParent()
        unstressedStressMarkSpawn.removeFromParent()
        
        setUpUnfixedParts()
    }
    
    /// Checks if stressMark has been moved to accent bin for the first time
    /// Spawns new stress mark if spawn location is empty
    func spawnNewStressMarkIfNecessary() {
        // reset isClinchedToAccentBin flag
        for stressMark in stressMarks {
            stressMark.isClinchedToAccentBin = false
        }
        // flag the stress marks that are clinched to accent bin
        // spawn new stress mark if stress mark gets moved to accent bin for the first time
        for accentBin in accentBins {
            for stressMark in stressMarks {
                if accentBin.frame.intersects(stressMark.frame) {
                    if stressMark.wasNeverClinchedToAccentBin {
                        if stressMark.name == "stressed" {
                            generateStressedStressMark()
                        }
                        else if stressMark.name == "unstressed" {
                            generateUnstressedStressMark()
                        }
                    }
                    // clinch stressMark to accent bin
                    stressMark.position = accentBin.position
                    stressMark.isClinchedToAccentBin = true
                    stressMark.wasNeverClinchedToAccentBin = false
                }
            }
        }
    }
    
    /// Removes stress mark if it was dragged out of accent bin
    func removeStressMarkIfRemovedFromAccentBin() {
        // get the stress mark that got removed from accent bin
        var toBeRemoved = [StressMark]()
        for stressMark in stressMarks {
            if (stressMark.isClinchedToAccentBin==false && stressMark.wasNeverClinchedToAccentBin==false) && (stressMark.position != unstressedStressMarkSpawnLocation || stressMark.position != stressedStressMarkSpawnLocation) {
                toBeRemoved.append(stressMark)
            }
        }
        // delete the stress marks that got removed from accent bin
        for stressMark in toBeRemoved {
            stressMark.removeFromParent()
            stressMarks = stressMarks.filter { $0 != stressMark }
        }
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
