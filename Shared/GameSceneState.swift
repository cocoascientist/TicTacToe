//
//  GameSceneState.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 7/11/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameSceneState: GKState, GameStateType {
    unowned var view: SKView
    
    required init(view: SKView) {
        self.view = view
        super.init()
        
        self.view.ignoresSiblingOrder = true
    }
    
    override func didEnter(withPreviousState previousState: GKState?) {
        let transition = SKTransition.crossFade(withDuration: 0.5)
        self.view.presentScene(scene(for: view), transition: transition)
    }
}

class TwoPlayerState: GameSceneState { }
class MenuState: GameSceneState { }
class OnePlayerState: GameSceneState { }
