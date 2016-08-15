//
//  InPlayStateMachine.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit


class InPlayStateMachine: GKStateMachine {
    
    var didWin: Bool = false
    fileprivate(set) var moveCount: Int = 0
    
    // should be private
    // could be state class instead of type?
    var lastPlayerState: GKState.Type?
    
    func resetToInitialState() {
        self.moveCount = 0
        self.didWin = false
        self.lastPlayerState = nil
        
        self.enter(SelectNextPlayerState.self)
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
