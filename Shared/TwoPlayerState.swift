//
//  TwoPlayerState.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/30/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit
import SpriteKit

class TwoPlayerState: GKState {
    unowned var view: SKView
    private(set) unowned var manager: SceneManager
    
    lazy var scene: SKScene = {
        let size = self.view.bounds.size
        let scene = GameScene(manager: self.manager, size: size, type: .TwoPlayer)
        
        scene.scaleMode = .AspectFit
        
        return scene
    }()
    
    init(view: SKView, manager: SceneManager) {
        self.view = view
        self.manager = manager
        super.init()
        
        configure()
    }
    
    // MARK: GKState overrides
    
    /// Highlights the sprite representing the state.
    override func didEnterWithPreviousState(previousState: GKState?) {
        let transition = SKTransition.doorsOpenHorizontalWithDuration(0.5)
        self.view.presentScene(scene, transition: transition)
    }
    
    /// Unhighlights the sprite representing the state.
    override func willExitWithNextState(nextState: GKState) {
        self.scene.removeAllChildren()
    }
}

extension TwoPlayerState {
    private func configure() {
        self.view.ignoresSiblingOrder = true
        self.view.showsFPS = true
        self.view.showsNodeCount = true
    }
}
