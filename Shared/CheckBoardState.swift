//
//  CheckBoardState.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit

class CheckBoardState: GKState {
    
    private let model: TTTModel
    
    init(model: TTTModel) {
        self.model = model
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        // can use previousState to find out whose turn it was
        // who made the last move
        
        guard let machine = self.stateMachine as? GameplayStateMachine else { return }
        
        // refactor
        var win = false
        if machine.lastPlayerState is PlayerOTurnState.Type {
            win = self.model.board.isWin(forPiece: TTTPiece.O)
        }
        else if machine.lastPlayerState is PlayerXTurnState.Type {
            win = self.model.board.isWin(forPiece: TTTPiece.X)
        }
        
        if win {
            self.stateMachine?.enterState(GameOverState.self)
        } else {
            self.stateMachine?.enterState(SelectNextPlayerState.self)
        }
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return (stateClass is GameOverState.Type || stateClass is SelectNextPlayerState.Type)
    }
}