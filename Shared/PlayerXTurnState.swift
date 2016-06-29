//
//  PlayerXTurnState.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit

class PlayerXTurnState: GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is CheckBoardState.Type
    }
}