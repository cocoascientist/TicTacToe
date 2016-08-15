//
//  CheckBoardState.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit

class CheckBoardState: InPlayState {
    
    override func didEnter(from previousState: GKState?) {
        let piece = playerPiece()
        
        if model.board.isWin(forPiece: piece) {
            self.stateMachine?.enter(GameOverState.self)
        } else if model.board.hasEmptyPlaces() == false {
            self.stateMachine?.enter(GameOverState.self)
        } else {
            self.stateMachine?.enter(SelectNextPlayerState.self)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass is GameOverState.Type || stateClass is SelectNextPlayerState.Type)
    }
    
    fileprivate func playerPiece() -> TTTPiece {
        guard let machine = self.stateMachine as? InPlayStateMachine else { fatalError() }
        
        switch machine.lastPlayerState {
        case is PlayerOTurnState.Type:
            return TTTPiece.o
        case is PlayerXTurnState.Type:
            return TTTPiece.x
        default:
            fatalError()
        }
    }
}
