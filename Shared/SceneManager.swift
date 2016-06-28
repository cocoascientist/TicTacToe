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
    let view: SKView
    
    private(set) var state: GKState?
    private(set) var scene: SKScene?
    
    lazy var stateMachine: GKStateMachine = {
        let states = [
            MenuState(view: self.view),
            GameState(view: self.view)
        ]
        
        return GKStateMachine(states: states)
    }()
    
    init(view: SKView) {
        self.view = view
    }
    
    func configure(view: SKView, forGameSceneSize size: CGSize) {
        let scene = GameScene(size: size)
        scene.scaleMode = .AspectFit
        
        view.ignoresSiblingOrder = true
        
        view.showsFPS = true
        view.showsNodeCount = true
        
        view.presentScene(scene)
    }
}