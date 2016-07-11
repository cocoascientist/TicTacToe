//
//  GameStateDescribable.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 7/11/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

protocol GameStateDescribable {
    unowned var view: SKView { get set }
    
    init(view: SKView)
}

extension GameStateDescribable where Self: GKState {
    func scene(for view: SKView) -> SKScene {
        let size = view.frame.size
        let scene = sceneWithSize(size)
        
        scene.scaleMode = .aspectFit
        
        return scene
    }
    
    private func sceneWithSize(_ size: CGSize) -> SKScene {
        guard let stateMachine = self.stateMachine else { fatalError() }
        
        switch self {
        case is MenuState:
            return MenuScene(size: size, stateMachine: stateMachine)
        case is OnePlayerState:
            return GameScene(size: size, stateMachine: stateMachine, type: .onePlayer)
        case is TwoPlayerState:
            return GameScene(size: size, stateMachine: stateMachine, type: .twoPlayer)
        default:
            fatalError("unsupported scene")
        }
    }
}

class GameState: GKState, GameStateDescribable {
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
