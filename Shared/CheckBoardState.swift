//
//  CheckBoardState.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit

class CheckBoardState: GKState {
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExitWithNextState(nextState: GKState) {
        //
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        //
        
        guard let gameplayStateMachine = stateMachine as? GameplayStateMachine else {
            return
        }
        
        gameplayStateMachine
    }
}