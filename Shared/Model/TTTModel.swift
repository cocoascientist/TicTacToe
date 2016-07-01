//
//  TTTModel.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/29/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit


class TTTModel: NSObject {
    private(set) var players: [GKGameModelPlayer]?
    var activePlayer: GKGameModelPlayer?
    
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
    
    func resetGameBoard() {
        self.board = TTTBoard()
        self.activePlayer = nil
    }
}

extension TTTModel {
    func nextPlayerAfter(player: GKGameModelPlayer?) -> GKGameModelPlayer? {
        guard let players = players as? [TTTPlayer] else { return nil }
        guard let player = player as? TTTPlayer else { return nil }
        
        assert(players.count == 2)
        
        let playerX = players.filter { $0.piece == TTTPiece.X }.first!
        let playerO = players.filter { $0.piece == TTTPiece.O }.first!
        
        return (player == playerX) ? playerO : playerX
    }
}

extension TTTModel: GKGameModel {
    func setGameModel(model: GKGameModel) {
        guard let model = model as? TTTModel else { return }
        
        self.board = model.board
        self.activePlayer = model.activePlayer
    }
    
    func gameModelUpdatesForPlayer(player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        
        guard let player = player as? TTTPlayer else { return nil }
        
        let indexed = board.pieces.enumerate().map { return (index: $0, placemarker: $1) }
        let empty = indexed.filter { (_, placemarker) -> Bool in
            if placemarker.piece == .None {
                return true
            } else {
                return false
            }
        }
        
        let moves = empty.map { return TTTMove(index: $0.index, piece: player.piece)}
        
//        print("computer found \(moves.count) possible moves")
        
        return (moves.count > 0) ? moves: nil
    }
    
    func applyGameModelUpdate(gameModelUpdate: GKGameModelUpdate) {
        guard let move = gameModelUpdate as? TTTMove else { return }
        
        self.board = board.afterMaking(move)
        self.activePlayer = nextPlayerAfter(activePlayer)
    }
    
    func scoreForPlayer(player: GKGameModelPlayer) -> Int {
        guard let player = player as? TTTPlayer else { return 0 }
        
        let piece = player.piece
        
        let score = board.score(forPiece: piece)
        let opponent = (board.score(forPiece: piece.opposite) - 20) * -1
        
        let adjusted = score + opponent
        
//        print("board: \(printBoard()) scores a \(adjusted)")
        
        return adjusted
    }
    
    func printBoard() {
        for obj in board.pieces {
            print(obj.piece.glyph, terminator: "")
        }
        
        print("")
    }
}