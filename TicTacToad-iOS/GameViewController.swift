//
//  GameViewController.swift
//  TicTacToad-iOS
//
//  Created by Andrew Shepard on 6/27/16.
//  Copyright (c) 2016 Andrew Shepard. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    lazy var skView: SKView = {
        guard let skView = self.view as? SKView else { fatalError() }
        return skView
    }()
    
    lazy var sceneStateMachine: GKStateMachine = {
        let states = [
            MenuState(view: self.skView),
            OnePlayerState(view: self.skView),
            TwoPlayerState(view: self.skView)
        ]
        
        return GKStateMachine(states: states)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneStateMachine.enterState(MenuState.self)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
