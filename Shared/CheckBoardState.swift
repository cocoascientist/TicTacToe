//
//  CheckBoardState.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit

class CheckBoardState: GKState {
    
    private(set) unowned var model: TTTModel
    
    init(model: TTTModel) {
        self.model = model
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        let piece = playerPiece()
        
        print("checking win for player: \(piece)")
        
        if model.board.isWin(forPiece: piece) {
            self.stateMachine?.enterState(GameOverState.self)
        } else if model.board.hasEmptyPlaces() == false {
            self.stateMachine?.enterState(GameOverState.self)
        } else {
            self.stateMachine?.enterState(SelectNextPlayerState.self)
        }
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return (stateClass is GameOverState.Type || stateClass is SelectNextPlayerState.Type)
    }
    
    private func playerPiece() -> TTTPiece {
        guard let machine = self.stateMachine as? GameplayStateMachine else { fatalError() }
        
        switch machine.lastPlayerState {
        case is PlayerOTurnState.Type:
            return TTTPiece.O
        case is PlayerXTurnState.Type:
            return TTTPiece.X
        default:
            return TTTPiece.None
        }
    }
}