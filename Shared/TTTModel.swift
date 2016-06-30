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
        
        return (moves.count > 0) ? moves: nil
    }
    
    func applyGameModelUpdate(gameModelUpdate: GKGameModelUpdate) {
        guard let move = gameModelUpdate as? TTTMove else { return }
        
        self.board = board.afterMaking(move)
    }
    
    func scoreForPlayer(player: GKGameModelPlayer) -> Int {
        // TODO: implement
        return 10
    }
}