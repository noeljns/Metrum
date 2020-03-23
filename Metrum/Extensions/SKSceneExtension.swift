//
//  SKSceneExtension.swift
//  Metrum
//
//  Created by Jonas Zwink on 28.02.20.
//  Copyright © 2020 Jonas Zwink. All rights reserved.
//

import SpriteKit

extension SKScene {
    /// Returns a set of Line objects deserialized from a json file stored in user's document directory
    ///
    /// - Parameters:
    ///   - fileName: name of file to be loaded and deserialized
    /// - Returns: Set of loaded and deserialized Line objects
    func loadInputFileFromDocumentDirectory(fromDocumentsWithFileName fileName: String) -> Set<Line>? {
        let data: Data
        let url = self.getDocumentsDirectory().appendingPathComponent(fileName)
        // check if fileName exists
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                data = try Data(contentsOf: url)
                let lines = try! JSONDecoder().decode(Set<Line>.self, from: data)
                return lines
            }
            catch {
                print("Error reading \(fileName) file")
            }
        }
        else {
            print("\(fileName) is not available")
        }
        return nil
    }
    
    /// Gets user's document directory
    ///
    /// - Returns: url of user's document directory
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // returns the first one, which should be the only one
        return paths[0]
    }
    
    
    /// Gets data from json file stored in main bundle and returns deserialized set of Line objects
    ///
    /// - Parameters:
    ///   - inputFile: inputFile to be loaded
    /// - Returns: Set of loaded and deserialized Line objects
    func loadInputFileFromMainBundle(inputFile: String) -> Set<Line>{
        let data: Data
        
        // name of json file is in inputFile, for instance lines.json
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
            return Set<Line>(lines)
        }
    }
    
    /// Returns white background blocker sprite node with z position of 4999
    ///
    /// - Parameters:
    ///   - shallBeTransparent: Bool that determines whether background blocker shall be transparent or not
    ///   - size: size of background blocker
    /// - Returns: background blocker sprite node
    func getBackgroundBlocker(shallBeTransparent: Bool, size: CGSize) -> SKSpriteNode {
        let backgroundBlocker = SKSpriteNode(color: SKColor.white, size: size)
        backgroundBlocker.name = "backgroundBlocker"
        backgroundBlocker.zPosition = 4999
        if shallBeTransparent {
            backgroundBlocker.alpha = 0.5
        }
        return backgroundBlocker
    }
    
    /// Returns String as NSMutableAttributedString and when indicated in bold.
    ///
    /// - Parameters:
    ///   - stringToBeMutated: The String which should be returnded.
    ///   - shallBecomceBold: This Boolean says whether String shall be bold or not.
    ///   - size: Size of the String
    /// - Returns: The String as NSMutableAttributedString.
    func makeAttributedString(stringToBeMutated: String, shallBecomeBold: Bool, size: CGFloat) -> NSMutableAttributedString {
        if(shallBecomeBold) {
            let bold = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: size)]
            let attributedString =  NSMutableAttributedString(string:stringToBeMutated, attributes:bold as [NSAttributedString.Key : Any])
            return attributedString
        }
        else {
            let notBold = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-UltraLight", size: size)]
            let normalString = NSMutableAttributedString(string:stringToBeMutated, attributes: notBold as [NSAttributedString.Key : Any])
            return normalString
        }
    }
    
//    // TODO: test to modularize overlay nodes
//    var backgroundBlockerTest: SKSpriteNode {
//        let backgroundBlocker = SKSpriteNode(color: SKColor.white, size: CGSize(width: 768, height: 1024))
//        backgroundBlocker.name = "backgroundBlockerTest"
//        backgroundBlocker.zPosition = 4999
//        return backgroundBlocker
//    }
//    // TODO: test to modularize overlay nodes
//    func getBackgroundBlockerTest(shallBeTransparent: Bool, size: CGSize) {
//        let backgroundBlocker = SKSpriteNode(color: SKColor.white, size: size)
//        backgroundBlocker.name = "backgroundBlocker"
//        backgroundBlocker.zPosition = 4999
//        if shallBeTransparent {
//            backgroundBlocker.alpha = 0.5
//        }
//    }
}
