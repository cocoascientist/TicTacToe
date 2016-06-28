//
//  GameState.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/27/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameState: GKState {
    let view: SKView
    
    lazy var scene: SKScene = {
        let size = self.view.bounds.size
        let scene = GameScene(size: size)
        
        scene.scaleMode = .AspectFit
        
        return scene
    }()
    
    init(view: SKView) {
        self.view = view
        super.init()
        
        configure()
    }
    
    // MARK: GKState overrides
    
    /// Highlights the sprite representing the state.
    override func didEnterWithPreviousState(previousState: GKState?) {
        self.view.presentScene(self.scene)
    }
    
    /// Unhighlights the sprite representing the state.
    override func willExitWithNextState(nextState: GKState) {
        //
    }
}

extension GameState {
    private func configure() {
        self.view.ignoresSiblingOrder = true
        self.view.showsFPS = true
        self.view.showsNodeCount = true
    }
}