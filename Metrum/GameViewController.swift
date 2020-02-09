//
//  GameViewController.swift
//  Metrum
//
//  Created by Jonas Jonas on 06.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    // https://stackoverflow.com/questions/46954696/save-state-of-gamescene-through-transitions
    // did not work to retain the Scene by making strong reference in controller
    // var levelOneScene = LevelOneScene(fileNamed: "LevelOneScene")
    // lazy var skView: SKView = self.view as! SKView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {

            // Load the SKScene from 'GameScene.sks'
            // if let scene = SKScene(fileNamed: "GameScene") {
            if let scene = SKScene(fileNamed: "MainMenuScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = false

            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
