//
//  TTTBoard.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/29/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation


enum TTTPiece {
    case None
    
    case X
    case O
}

typealias Placemarker = (value: Int, piece: TTTPiece)

class TTTBoard {
    let rows = 3
    let columns = 3
    var pieces: [Placemarker]
    
    // http://mathworld.wolfram.com/MagicSquare.html
    private let magicSquares = [8, 1, 6, 3, 5, 7, 4, 9, 2]
    
    init() {
        self.pieces = magicSquares.map({ (value) -> Placemarker in
            return (value: value, piece: .None)
        })
        
        print(pieces)
    }
    
    func afterMakingMove(with piece: TTTPiece, at index: Int) {
        let placemarker = self.pieces[index]
        self.pieces[index] = (value: placemarker.value, piece: piece)
    }
    
    private var winningCombos: [[Int]] {
        /*
         0 | 1 | 2
         ---------
         3 | 4 | 5
         ---------
         6 | 7 | 8
         */
        
        return [
            [0,1,2],[3,4,5],[6,7,8], /* horizontals */
            [0,3,6],[1,4,7],[2,5,8], /* veritcals */
            [0,4,8],[2,4,6]          /* diagonals */
        ]
    }
    
    func isWin(forPiece piece: TTTPiece) -> Bool {
        var didWin = false
        
        for combo in winningCombos {
            
            var accumulated = 0
            for index in combo {
                let current = self.pieces[index]
                if current.piece == piece {
                    accumulated += current.value
                }
            }
            
            print("combo: \(combo), value: \(accumulated)")
            
            didWin = (accumulated == 15)
            
            if didWin {
                print("found win!")
                break
            }
        }
        
        return didWin
    }
}
