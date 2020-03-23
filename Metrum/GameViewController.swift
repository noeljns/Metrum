//
//  GameViewController.swift
//  Metrum
//
//  Created by Jonas Zwink on 06.02.20.
//  Copyright © 2020 Jonas Zwink. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    /// Copies specified files from main bundle to user document directory
    ///
    /// - Parameters:
    ///   - fileName: name of file that shall be copied from mail bundle to user document directory
    ///   - fileType: type of file that shall be copied from mail bundle to user document directory
    func copyFilesToUserDocumentDirectory(fileName: String, fileType: String) {
        let fileManager = FileManager.default
        do {
            try fileManager.copyfileToUserDocumentDirectory(forResource: fileName, ofType: fileType)
        } catch {
            fatalError("failed to copy \(fileName).\(fileType) from main bundle to user document directory")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // copy relevant json files from main bundle to user document directory so that they are stored in app's sandbox
        copyFilesToUserDocumentDirectory(fileName: "lines", fileType: "json")
        copyFilesToUserDocumentDirectory(fileName: "words", fileType: "json")
        
        if let view = self.view as! SKView? {

            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "MainMenuScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true

            // disable debugging tools
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // forbid landscape mode
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .portrait
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
