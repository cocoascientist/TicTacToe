//
//  TTTModel.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/29/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit


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
        
        self.board.afterMakingMove(with: move.piece, at: move.index)
    }
}