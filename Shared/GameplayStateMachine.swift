//
//  GameplayStateMachine.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit


class GameplayStateMachine: GKStateMachine {
    
    var didWin: Bool = false
    private(set) var moveCount: Int = 0
    
    private var lastPlayerState: GKState.Type?
    
    func resetToInitialState() {
        self.moveCount = 0
        self.didWin = false
        self.enterState(PlayerXTurnState.self)
        
        self.lastPlayerState = PlayerXTurnState.self
    }
    
    func moveToNextState() {
        if currentState is PlayerOTurnState || currentState is PlayerXTurnState {
            self.enterState(CheckBoardState.self)
        } else {
            if lastPlayerState is PlayerXTurnState.Type {
                lastPlayerState = PlayerOTurnState.self
                self.enterState(PlayerOTurnState.self)
            }
            else {
                lastPlayerState = PlayerXTurnState.self
                self.enterState(PlayerXTurnState.self)
            }
        }
    }
    
    var glyphForState: String {
        return currentState is PlayerXTurnState ? "X" : "O"
    }
    
    var glyphColorForState: Color {
        let colorForX = Color.hexColor("#EF946C")
        let colorForO = Color.hexColor("#00FCDB")
        
        return currentState is PlayerXTurnState ? colorForX : colorForO
    }
}
