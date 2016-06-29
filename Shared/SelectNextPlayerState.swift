//
//  SelectNextPlayerState.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/29/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit
import SpriteKit

class SelectNextPlayerState: GKState {
    
    private(set) unowned var scene: SKScene
    
    init(scene: SKScene) {
        self.scene = scene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        guard let machine = self.stateMachine as? GameplayStateMachine else { return }
        guard let scene = self.scene as? GameScene else { return }
        
        if let previousState = previousState {
            if previousState is GameOverState {
                let title = NSLocalizedString("Restart", comment: "Restart")
                scene.restartButton.label.text = title
            }
        }
        
        if machine.lastPlayerState is PlayerXTurnState.Type {
            let title = NSLocalizedString("Next move, Player O", comment: "Next move, Player O")
            scene.moveLabel.text = title
            scene.moveLabel.fontColor = Style.Colors.blue
            
            machine.lastPlayerState = PlayerOTurnState.self
            machine.enterState(PlayerOTurnState.self)
        }
        else {
            let title = NSLocalizedString("Next move, Player X", comment: "Next move, Player X")
            scene.moveLabel.text = title
            scene.moveLabel.fontColor = Style.Colors.orange
            
            machine.lastPlayerState = PlayerXTurnState.self
            machine.enterState(PlayerXTurnState.self)
        }
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is PlayerXTurnState.Type || stateClass is PlayerOTurnState.Type
    }
}
