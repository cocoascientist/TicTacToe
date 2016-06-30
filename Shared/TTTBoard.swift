//
//  TTTBoard.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/29/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation

// TODO: remove .None case, use optionals. None is not a piece...

enum TTTPiece {
    case None
    
    case X
    case O
    
    var glyph: String {
        switch self {
        case .X:
            return "X"
        case .O:
            return "O"
        default:
            return ""
        }
    }
    
    var hexColor: String {
        switch self {
        case .X:
            return "#EF946C"
        case .O:
            return "#00FCDB"
        default:
            return "#FFFFFF"
        }
    }
}

typealias Placemarker = (value: Int, piece: TTTPiece)

private func emptyBoardPlaces() -> [Placemarker] {
    // http://mathworld.wolfram.com/MagicSquare.html
    let magicSquares = [8, 1, 6, 3, 5, 7, 4, 9, 2]
    
    let pieces = magicSquares.map({ (value) -> Placemarker in
        return (value: value, piece: .None)
    })
    
    return pieces
}

struct TTTBoard {
    let rows = 3
    let columns = 3
    var pieces: [Placemarker]
    
    // http://mathworld.wolfram.com/MagicSquare.html
    private let magicSquares = [8, 1, 6, 3, 5, 7, 4, 9, 2]
    
    init(pieces: [Placemarker] = emptyBoardPlaces()) {
        self.pieces = pieces
    }
    
    func afterMaking(move: TTTMove) -> TTTBoard {
        return afterMakingMove(with: move.piece, at: move.index)
    }
    
    func afterMakingMove(with piece: TTTPiece, at index: Int) -> TTTBoard {
        var pieces = self.pieces
        let placemarker = pieces[index]
        pieces[index] = (value: placemarker.value, piece: piece)
        
        return TTTBoard(pieces: pieces)
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
            
            didWin = (accumulated == 15)
            if didWin { break }
        }
        
        return didWin
    }
}
