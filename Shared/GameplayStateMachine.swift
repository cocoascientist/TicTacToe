//
//  GameplayStateMachine.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit

class GameplayStateMachine: GKStateMachine {
    
    private(set) var moveCount: Int = 0
    
    func resetToInitialState() {
        self.moveCount = 0
        self.enterState(PlayerXTurnState.self)
    }
    
    func moveToNextState() {
        if currentState is PlayerOTurnState {
            self.enterState(PlayerXTurnState.self)
        }
        else if currentState is PlayerXTurnState {
            self.enterState(PlayerOTurnState.self)
        }
    }
    
    var glyphForState: String {
        return currentState is PlayerXTurnState ? "X" : "O"
    }
}
