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
    case none
    
    case x
    case o
    
    var glyph: String {
        switch self {
        case .x:
            return "X"
        case .o:
            return "O"
        default:
            return "+"
        }
    }
    
    var hexColor: String {
        switch self {
        case .x:
            return "#EF946C"
        case .o:
            return "#00FCDB"
        default:
            return "#FFFFFF"
        }
    }
    
    var opposite: TTTPiece {
        switch self {
        case .x:
            return .o
        case .o:
            return .x
        default:
            return self
        }
    }
}

typealias Placemarker = (value: Int, piece: TTTPiece)

private func emptyBoardPlaces() -> [Placemarker] {
    // http://mathworld.wolfram.com/MagicSquare.html
    let magicSquares = [8, 1, 6, 3, 5, 7, 4, 9, 2]
    
    let pieces = magicSquares.map({ (value) -> Placemarker in
        return (value: value, piece: .none)
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
    
    func afterMaking(_ move: TTTMove) -> TTTBoard {
        return afterMakingMove(with: move.piece, at: move.index)
    }
    
    func afterMakingMove(with piece: TTTPiece, at index: Int) -> TTTBoard {
        var pieces = self.pieces
        let placemarker = pieces[index]
        pieces[index] = (value: placemarker.value, piece: piece)
        
        return TTTBoard(pieces: pieces)
    }
    
    func hasEmptyPlaces() -> Bool {
        let empty = self.pieces.filter { (_, piece) -> Bool in
            return piece == .none
        }
        
        return empty.count > 0
    }
    
    func winningCombo() -> [Int]? {
        
        var winners: [Int]? = nil
        
        for combo in winningCombos {
            
            if isWinCombo(combo, forPiece: .o) || isWinCombo(combo, forPiece: .x) {
                winners = combo
                break
            }
        }
        
        return winners
    }
    
    func isWinCombo(_ combo: [Int], forPiece piece: TTTPiece) -> Bool {
        var accumulated: Int = 0
        
        for index in combo {
            let current = self.pieces[index]
            if current.piece == piece {
                accumulated += 1
            }
        }
        
        return (accumulated == 3)
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
    
    private var corners: [Int] {
        return [0,2,6,8]
    }
    
    private var middle: Int {
        return 4
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
    
    func score(forPiece piece: TTTPiece) -> Int {
        var score = 0
        
        // checking for opponant winning combos
        for combo in winningCombos {
            var matches = 0
            for index in combo {
                let current = self.pieces[index]
                if current.piece == piece.opposite {
                    matches += 1
                }
            }
            
            if matches == 3 {
                score -= 100
            }
        }
        
        if score < 0 { return score }
        
        // checking for opponant 2-in-a-row with empty place
        for combo in winningCombos {
            var matches = 0
            var empty = 0
            for index in combo {
                let current = self.pieces[index]
                if current.piece == piece.opposite {
                    matches += 1
                } else if current.piece == TTTPiece.none {
                    empty += 1
                }
            }
            
            if matches == 2 && empty == 1 {
                score -= 90
            }
        }
        
        if score < 0 { return score }
        
        // checking winning combos
        for combo in winningCombos {
            var matches = 0
            var empty = 0
            
            for index in combo {
                let current = self.pieces[index]
                if current.piece == piece {
                    matches += 1
                } else if current.piece == .none {
                    empty += 1
                }
            }
            
            if matches == 3 {
                score += 100
            } else if matches == 2 && empty == 1 {
                score += 50
            }
        }
        
        // check the corners
        for index in corners {
            let current = self.pieces[index]
            if current.piece == piece {
                score += 20
            }
        }
        
        // check middle piece
        let current = self.pieces[middle]
        if current.piece == piece {
            score += 30
        }
        
        return score
    }
}
