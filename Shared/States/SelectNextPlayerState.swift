//
//  SelectNextPlayerState.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/29/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit
import SpriteKit

class SelectNextPlayerState: InPlayState {
    
    override func didEnter(withPreviousState previousState: GKState?) {
        guard let machine = self.stateMachine as? InPlayStateMachine else { return }
        guard let scene = self.scene as? GameScene else { return }
        
        guard let players = scene.model.players as? [TTTPlayer] else { return }
        let playerX = players.filter { $0.piece == TTTPiece.x }.first!
        let playerO = players.filter { $0.piece == TTTPiece.o }.first!
        
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
            
            scene.model.activePlayer = playerO
            
            machine.lastPlayerState = PlayerOTurnState.self
            machine.enterState(PlayerOTurnState.self)
        }
        else {
            let title = NSLocalizedString("Next move, Player X", comment: "Next move, Player X")
            scene.moveLabel.text = title
            scene.moveLabel.fontColor = Style.Colors.orange
            
            scene.model.activePlayer = playerX
            
            machine.lastPlayerState = PlayerXTurnState.self
            machine.enterState(PlayerXTurnState.self)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayerXTurnState.Type || stateClass is PlayerOTurnState.Type
    }
}
