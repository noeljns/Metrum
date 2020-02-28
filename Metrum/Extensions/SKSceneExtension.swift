//
//  SKSceneExtension.swift
//  Metrum
//
//  Created by Jonas Jonas on 28.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import SpriteKit

extension SKScene {
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
    
    /// Gets data from json file and saves deserialized Line objects to selection variable.
    func loadInputFile(inputFile: String) -> Set<Line>{
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
            return Set<Line>(lines)
        }
    }
    
    var backgroundBlockerTest: SKSpriteNode {
        let backgroundBlocker = SKSpriteNode(color: SKColor.white, size: CGSize(width: 768, height: 1024))
        backgroundBlocker.name = "backgroundBlockerTest"
        backgroundBlocker.zPosition = 4999
        return backgroundBlocker
    }
    
    
    func getBackgroundBlockerTest(shallBeTransparent: Bool, size: CGSize) {
        let backgroundBlocker = SKSpriteNode(color: SKColor.white, size: size)
        backgroundBlocker.name = "backgroundBlocker"
        backgroundBlocker.zPosition = 4999
        if shallBeTransparent {
            backgroundBlocker.alpha = 0.5
        }
    }
    
    func getBackgroundBlocker(shallBeTransparent: Bool, size: CGSize) -> SKSpriteNode {
        let backgroundBlocker = SKSpriteNode(color: SKColor.white, size: size)
        backgroundBlocker.name = "backgroundBlocker"
        backgroundBlocker.zPosition = 4999
        if shallBeTransparent {
            backgroundBlocker.alpha = 0.5
        }
        return backgroundBlocker
    }
}
