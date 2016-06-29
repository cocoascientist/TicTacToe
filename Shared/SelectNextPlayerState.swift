//
//  SelectNextPlayerState.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/29/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit

class SelectNextPlayerState: GKState {
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        guard let machine = self.stateMachine as? GameplayStateMachine else { return }
        
        if machine.lastPlayerState is PlayerXTurnState.Type {
            print("player O, make a move")
            
            machine.lastPlayerState = PlayerOTurnState.self
            machine.enterState(PlayerOTurnState.self)
        }
        else {
            print("player X, make a move")
            
            machine.lastPlayerState = PlayerXTurnState.self
            machine.enterState(PlayerXTurnState.self)
        }
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is PlayerXTurnState.Type || stateClass is PlayerOTurnState.Type
    }
}
