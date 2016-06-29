//
//  TTTModel.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/29/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit

enum TTTPiece {
    case None
    
    case X
    case O
}

typealias Placemarker = (value: Int, piece: TTTPiece)

struct TTTBoard {
    let rows = 3
    let columns = 3
    var pieces: [Placemarker]
    
    // http://mathworld.wolfram.com/MagicSquare.html
    private let magicSquares = [8, 1, 6, 3, 5, 7, 4, 9, 2]
    
    init() {
        self.pieces = magicSquares.map({ (value) -> Placemarker in
            return (value: value, piece: .None)
        })
    }
    
    func afterMakingMove(with piece: TTTPiece, at index: Int) -> TTTBoard {
        var board = self
        let placemarker = board.pieces[index]
        
        board.pieces[index] = (value: placemarker.value, piece: piece)
        
        return board
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

class TTTModel: NSObject, GKGameModel {
    private(set) var players: [GKGameModelPlayer]?
    private(set) var activePlayer: GKGameModelPlayer?
    
    private(set) var board: TTTBoard
    
    init(players: [GKGameModelPlayer]?) {
        self.players = players
        self.board = TTTBoard()
        super.init()
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let model = TTTModel(players: players)
        model.setGameModel(self)
        return model
    }
    
    func setGameModel(model: GKGameModel) {
        guard let model = model as? TTTModel else { return }
        
        self.board = model.board
        self.activePlayer = model.activePlayer
    }
    
    func gameModelUpdatesForPlayer(player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        
        guard let player = player as? TTTPlayer else { return nil }
        
        let indexed = board.pieces.enumerate().map { return (index: $0, placemarker: $1) }
        let empty = indexed.filter { return $1.piece == .None }
        let moves = empty.map { return TTTMove(index: $0.index, piece: player.piece)}
        
        return (moves.count > 0) ? moves: nil
    }
    
    func applyGameModelUpdate(gameModelUpdate: GKGameModelUpdate) {
        guard let move = gameModelUpdate as? TTTMove else { return }
        
        // don't have connection between TTTPlayer and X or O piece type
        
        let updatedBoard = board.afterMakingMove(with: .O, at: move.index)
        self.board = updatedBoard
    }
}