//
//  LevelOneToFourScene.swift
//  Metrum
//
//  Created by Jonas Jonas on 06.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

class LevelOneToFourScene: SKScene {
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
    private let stressedStressMarkParentBin = SKSpriteNode()
    private let stressed = SKLabelNode()
    private let unstressed = SKLabelNode()
    private let unstressedStressMarkParentBin = SKSpriteNode()

    // overlay windows
    private var backgroundBlocker: SKSpriteNode!
    private var accentuationInfoButton = SKSpriteNode()
    private var accentuationInfo: AccentuationInfo!
    private var congratulations: Congratulations!
    private var replyIsCorrect: ReplyIsCorrect!
    private var replyIsFalse: ReplyIsFalse!
    private var warning: Warning!
    
    private var soundBoxButton = SKSpriteNode()
    private let audioNode = SKNode()
    
    private var checkButtonFrame = SKSpriteNode()
    private var checkButton = SKLabelNode()

    // lazy var selection: Set<Line> = [lineOne]
    // lazy var selection: Set<Line> = [lineTwo, lineThree, lineSeven, lineEight]
    // lazy var selection: Set<Line> = [lineOne, lineTwo, lineThree, lineSeven, lineEight]
    // lazy var selected = lineOne
    
    lazy var correctlyMarkedLines = Set<Line>()
    private var correctRepliesLevelOne = 0
    private var amountOfCorrectRepliesToPassLevel = 4
    
    // TODO init properties by constructor
    public var provideHelp = false
    public var inputFile = ""
    public var userDefaultsKey = ""
    
    // test
//    lazy var jsonString = """
//    {
//      "words": [
//        {
//          "syllables": [
//            {
//              "syllableString": "Die",
//              "accentuation": "unstressed"
//            }
//          ]
//        },
//        {
//          "syllables": [
//            {
//              "syllableString": "lin",
//              "accentuation": "stressed"
//            },
//            {
//              "syllableString": "den",
//              "accentuation": "unstressed"
//            }
//          ]
//        },
//        {
//          "syllables": [
//            {
//              "syllableString": "Lüf",
//              "accentuation": "stressed"
//            },
//            {
//              "syllableString": "te",
//              "accentuation": "unstressed"
//            }
//          ]
//        },
//        {
//          "syllables": [
//            {
//              "syllableString": "sind",
//              "accentuation": "stressed"
//            }
//          ]
//        },
//        {
//          "syllables": [
//            {
//              "syllableString": "er",
//              "accentuation": "unstressed"
//            },
//            {
//              "syllableString": "wacht",
//              "accentuation": "stressed"
//            }
//          ]
//        }
//      ],
//      "measure": "jambus",
//      "audioFile": "lineTwo.mp3"
//    }
//    """
    
    lazy var jsonString = """
    [
      {
        "words": [
          {
            "syllables": [
              {
                "syllableString": "Freu",
                "accentuation": "stressed"
              },
              {
                "syllableString": "de",
                "accentuation": "unstressed"
              }
            ]
          },
          {
            "syllables": [
              {
                "syllableString": "schö",
                "accentuation": "stressed"
              },
              {
                "syllableString": "ner",
                "accentuation": "unstressed"
              }
            ]
          },
          {
            "syllables": [
              {
                "syllableString": "Gö",
                "accentuation": "stressed"
              },
              {
                "syllableString": "tter",
                "accentuation": "unstressed"
              }
            ]
          },
          {
            "syllables": [
              {
                "syllableString": "fun",
                "accentuation": "stressed"
              },
              {
                "syllableString": "ken",
                "accentuation": "unstressed"
              }
            ]
          }
        ],
        "measure": "trochaeus",
        "audioFile": "lineOne.mp3"
      },
      {
        "words": [
          {
            "syllables": [
              {
                "syllableString": "Die",
                "accentuation": "unstressed"
              }
            ]
          },
          {
            "syllables": [
              {
                "syllableString": "lin",
                "accentuation": "stressed"
              },
              {
                "syllableString": "den",
                "accentuation": "unstressed"
              }
            ]
          },
          {
            "syllables": [
              {
                "syllableString": "Lüf",
                "accentuation": "stressed"
              },
              {
                "syllableString": "te",
                "accentuation": "unstressed"
              }
            ]
          },
          {
            "syllables": [
              {
                "syllableString": "sind",
                "accentuation": "stressed"
              }
            ]
          },
          {
            "syllables": [
              {
                "syllableString": "er",
                "accentuation": "unstressed"
              },
              {
                "syllableString": "wacht  ",
                "accentuation": "stressed"
              }
            ]
          }
        ],
        "measure": "jambus",
        "audioFile": "lineTwo.mp3"
      }
    ]
    """
   // catch exceptions https://learnappmaking.com/codable-json-swift-how-to/
    lazy var jsonData = jsonString.data(using: .utf8)!
    // lazy var lines = try! JSONDecoder().decode([Line].self, from: jsonData)
    // lazy var line = try! JSONDecoder().decode(Line.self, from: jsonData)
    
    // lazy var selection: Set<Line> = Set<Line>(lines)
    lazy var selection = Set<Line>()
    // TODO BUG
    // var selected: Line?
    lazy var selected = lineThree
    
    // https://stackoverflow.com/a/58981897
    func loadInputFile() {
        // inputFile has "words.json" or lines.json
        let data: Data
        
        guard let file = Bundle.main.url(forResource: inputFile, withExtension: nil) else {
            print("error one while loading inputFile")
            fatalError("Error One: Could not find \(inputFile) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        }
        catch {
            print("error two while loading inputFile")
            fatalError("Error Two: Could not find \(inputFile) in main bundle.")
        }
        
        do {
            let lines = try! JSONDecoder().decode([Line].self, from: data)
            selection = Set<Line>(lines)
            selected = selection.first!
        }
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
    
    func setUpScene() {
        // print("test json: " + lines[0].getLine())
        // print("test json: " + line.getLine())

        
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
    
    

    // make two stress marks, one stressed and two unstressed
    func generateStressMarks() {
        generateStressedStressMark()
        generateUnstressedStressMark()
        
        // necessary to check whether spawn place of stressMarks are filled with stressMarks
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
    
    func generateStressedStressMark() {
        let stressedStressMarkParent = generateAStressMark(stressed: true, x: frame.midX-40, y: frame.midY-150)
        stressMarks.append(stressedStressMarkParent)
    }
    
    func generateUnstressedStressMark() {
        let unstressedStressMarkParent = generateAStressMark(stressed: false, x: frame.midX+40, y: frame.midY-150)
        stressMarks.append(unstressedStressMarkParent)
    }
    
    // generate stress marks that are to be placed to syllables
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
        
        // CHECK
        // let amountOfCharsInLine = line.line.count
        let amountOfCharsInLine = line.getLine().count
        let unit = CGFloat(wordToBeRated.frame.width / CGFloat(amountOfCharsInLine))

        // var counter = CGFloat(5.0)
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
                accentBin.position = CGPoint(x: wordToBeRated.frame.minX+positionOfBin, y: frame.midY+25)
                accentBin.zPosition = 2
                // append to global variable
                accentBins.append(accentBin)

                // counter shifts to the next syllable
                counter += CGFloat(syllable.syllableString.count) * unit + unit/2
                addChild(accentBin)
            }
            // counter shifts to the next word
            // counter += 25
            counter += 17
            // counter += 15
        }
    }
    
    // function to select next word to be solved
    // does not contain element that was previously shown
    func selectNextWord() -> Line {
        // TODO caution correctlyMarkedLines is nil / empty in the beginning
        let previousSelected = selected
        
        // loop over selection if all elements have been solved correctly
        var notYetCorrectlyMarkedLines = selection.subtracting(correctlyMarkedLines)
        if (notYetCorrectlyMarkedLines.isEmpty) {
            correctlyMarkedLines.removeAll()
            notYetCorrectlyMarkedLines = selection
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
    
    func setUpUnfixedParts() {
        // selected = selection.randomElement()!
        selected = selectNextWord()
        
        wordToBeRated.fontColor = SKColor.black
        // CHECK
        // wordToBeRated.attributedText = makeAttributedString(stringToBeMutated: (selected.line), shallBecomeBold: false)
        wordToBeRated.attributedText = makeAttributedString(stringToBeMutated: (selected.getLine()), shallBecomeBold: false)
        wordToBeRated.position = CGPoint(x: frame.midX, y: frame.midY-50)
        wordToBeRated.zPosition = 2
        addChild(wordToBeRated)

        generateAccentuationBins(line: selected, wordToBeRated: wordToBeRated)

        wordToBeRatedBold.fontColor = SKColor.black
        wordToBeRatedBold.attributedText = getWordToBeRatedBold(line: selected)
        wordToBeRatedBold.position = CGPoint(x: frame.midX, y: frame.midY-50)
        wordToBeRatedBold.zPosition = 2
        // addChild(wordToBeRatedBold)
        
        addChild(audioNode)
        
        // https://stackoverflow.com/questions/42026839/make-touch-area-for-sklabelnode-bigger-for-small-characters#comment71238691_42026839
        // TODO: dynamically via method
        generateStressMarks()
        
        // reset colors of check button
        checkButtonFrame.color = .lightGray
        checkButton.fontColor = .darkGray
        checkButton.addStroke(color: .darkGray, width: 6.0)
    }
    

    func getWordToBeRatedBold(line: Line) -> NSMutableAttributedString? {
        let wordToBeRatedBold = NSMutableAttributedString()

        // TODO Higher Function instead of two for loops
        for word in line.words {
            for syllable in word.syllables {
                if syllable.accentuation.rawValue == "unstressed" {
                    let syllableNotBold = makeAttributedString(stringToBeMutated: syllable.syllableString + "·", shallBecomeBold: false)
                    wordToBeRatedBold.append(syllableNotBold)
                }
                else if syllable.accentuation.rawValue == "stressed" {
                    let syllableBold = makeAttributedString(stringToBeMutated: syllable.syllableString + "·", shallBecomeBold: true)
                    wordToBeRatedBold.append(syllableBold)
                }
            }
            // cut last character, so that last middle point is removed from word
            wordToBeRatedBold.deleteCharacters(in: NSRange(location:(wordToBeRatedBold.length) - 1,length:1))
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
        backgroundBlocker = SKSpriteNode(color: SKColor.white, size: self.size)
        backgroundBlocker.zPosition = 4999
        addChild(backgroundBlocker)

        accentuationInfo = AccentuationInfo(size: CGSize(width: 650, height: 800))
        accentuationInfo.delegate = self
        accentuationInfo.zPosition = 5000
        addChild(accentuationInfo)
    }
    
    func displayCongratulations() {
        backgroundBlocker = SKSpriteNode(color: SKColor.white, size: self.size)
        backgroundBlocker.zPosition = 4999
        addChild(backgroundBlocker)
        
        congratulations = Congratulations(size: CGSize(width: 650, height: 800))
        congratulations.delegate = self
        congratulations.zPosition = 5000
        addChild(congratulations)
    }
    
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
    
    // func to check whether level is passed or not
    func updateLevelStatus() {
        if (correctRepliesLevelOne >= amountOfCorrectRepliesToPassLevel) {
            
            UserDefaults.standard.set(true, forKey: userDefaultsKey)
        }
    }


    // remove unnecessary nodes and set up scene for new word to be rated
    func cleanAndSetupSceneForNewWord() {
        // remove all accentBins and stressMarks from scene
        accentBins.forEach { $0.removeFromParent() }
        stressMarks.forEach { $0.removeFromParent() }

        // empty accentBins array and stressMarks array since new word is selected
        accentBins.removeAll()
        stressMarks.removeAll()
        
        wordToBeRated.removeFromParent()
        audioNode.removeFromParent()
        
        stressedStressMarkParentBin.removeFromParent()
        unstressedStressMarkParentBin.removeFromParent()
        
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
    
    // solution to make "x́  x" out of ["stressed", "unstressed"]
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
    

    override func didMove(to view: SKView) {
        print(inputFile)
        loadInputFile()
        
        setUpScene()
        setUpUnfixedParts()
        
        // only show, if level1 has not been passed yet
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
                    correctlyMarkedLines.insert(selected)
                    
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
        
        // dragging of stressMarks to new location by touching
        // TODO higher function
        for (smIndex, stressMark) in stressMarks.enumerated() {
            if stressMark.frame.contains(touch.previousLocation(in: self)) {
                stressMark.position = touch.location(in: self)
            }
            // if stressMarks collide, they do not stick together anymore
            for (sIndex, s) in stressMarks.enumerated() {
                if (stressMark.position.equalTo(s.position)) && (smIndex != sIndex) {
                    stressMark.position = CGPoint(x: stressMark.position.x-80, y: stressMark.position.y-40)
                }
            }
        }
    }
    

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // stressMarks clinch (einrasten) into accentBin
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
        
        // if stressMark.position not in frame anymore, position it back to the middle
        // TODO higher function
        for stressMark in stressMarks {
            if !(frame.contains(stressMark.position)) {
                print("lost a stressMark to the infinite nonentity")
                stressMark.position = CGPoint(x: frame.midX, y: frame.midY-150)
            }
        }
        
        // generate new stressMark if spawn is empty
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




