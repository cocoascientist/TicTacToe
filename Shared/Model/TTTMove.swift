//
//  TTTMove.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/29/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit

class TTTMove: NSObject, GKGameModelUpdate {
    
    internal(set) var value: Int = 0
    
    private(set) var piece: TTTPiece
    private(set) var index: Int
    
    required init(index: Int, piece: TTTPiece) {
        assert(piece != TTTPiece.none)
        
        self.index = index
        self.piece = piece
    }
}

extension TTTMove {
    override var description: String {
        return "index: \(index), value: \(value)"
    }
}
