//
//  TTTBoard.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/29/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation

enum TTTPiece {
    case x
    case o

    var glyph: String {
        switch self {
        case .x:
            return "X"
        case .o:
            return "O"
        }
    }

    var hexColor: String {
        switch self {
        case .x:
            return "#EF946C"
        case .o:
            return "#00FCDB"
        }
    }

    var opposite: TTTPiece {
        switch self {
        case .x:
            return .o
        case .o:
            return .x
        }
    }
}

enum TTTPosition {
    case empty
    case piece(TTTPiece)
}

func ==(lhs: TTTPosition, rhs: TTTPosition) -> Bool {
    switch (lhs, rhs) {
    case (.empty, .empty):
        return true
    case (let .piece(p1), let .piece(p2)):
        return p1 == p2
    default: return false
    }
}

typealias PositionMarker = (value: Int, position: TTTPosition)

private func emptyBoardPositions() -> [PositionMarker] {
    // http://mathworld.wolfram.com/MagicSquare.html
    let magicSquares = [8, 1, 6, 3, 5, 7, 4, 9, 2]

    let positions = magicSquares.map({ (value) -> PositionMarker in
        return (value: value, position: .empty)
    })

    return positions
}

struct TTTBoard {
    let rows = 3
    let columns = 3
    var positions: [PositionMarker]

    // http://mathworld.wolfram.com/MagicSquare.html
    fileprivate let magicSquares = [8, 1, 6, 3, 5, 7, 4, 9, 2]

    init(positions: [PositionMarker] = emptyBoardPositions()) {
        self.positions = positions
    }

    func afterMaking(_ move: TTTMove) -> TTTBoard {
        return afterMakingMove(with: move.piece, at: move.index)
    }

    func afterMakingMove(with piece: TTTPiece, at index: Int) -> TTTBoard {
        var positions = self.positions
        let placemarker = positions[index]
        positions[index] = (value: placemarker.value, position: .piece(piece))

        return TTTBoard(positions: positions)
    }

    func hasEmptyPlaces() -> Bool {
        let empty = self.positions.filter { (value, position) -> Bool in
            return position == TTTPosition.empty
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
            let position = self.positions[index].position
            if case .piece(let current) = position, current == piece {
                accumulated += 1
            }
        }

        return (accumulated == 3)
    }

    fileprivate var winningCombos: [[Int]] {
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

    fileprivate var corners: [Int] {
        return [0,2,6,8]
    }

    fileprivate var middle: Int {
        return 4
    }

    func isWin(forPiece piece: TTTPiece) -> Bool {
        var didWin = false

        for combo in winningCombos {
            var accumulated = 0

            for index in combo {
                let position = self.positions[index].position
                if case .piece(let current) = position, current == piece {
                    accumulated += self.positions[index].value
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
                let position = self.positions[index].position
                if case .piece(let current) = position, current == piece.opposite {
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
                let position = self.positions[index].position
                if case .piece(let current) = position, current == piece.opposite {
                    matches += 1
                } else if case .empty = position {
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
                let position = self.positions[index].position
                if case .piece(let current) = position, current == piece.opposite {
                    matches += 1
                } else if case .empty = position {
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
            let position = self.positions[index].position
            if case .piece(let current) = position, current == piece {
                score += 20
            }
        }

        // check middle piece
        let position = self.positions[middle].position
        if case .piece(let current) = position,  current == piece {
            score += 30
        }

        return score
    }
}
