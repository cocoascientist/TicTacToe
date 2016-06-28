//
//  SceneManager.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/27/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit
import GameplayKit

class SceneManager {
    unowned var view: SKView
    
    private(set) var state: GKState?
    private(set) var scene: SKScene?
    
    lazy var stateMachine: GKStateMachine = {
        let states = [
            MenuState(view: self.view, manager: self),
            GameState(view: self.view, manager: self)
        ]
        
        return GKStateMachine(states: states)
    }()
    
    init(view: SKView) {
        self.view = view
    }
}