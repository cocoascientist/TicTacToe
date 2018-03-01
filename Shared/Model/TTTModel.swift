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

    fileprivate(set) var board: TTTBoard

    init(players: [GKGameModelPlayer]?) {
        self.players = players
        self.board = TTTBoard()
        super.init()
    }

    func resetGameBoard() {
        self.board = TTTBoard()
        self.activePlayer = nil
    }
}

extension TTTModel: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let model = TTTModel(players: players)
        model.setGameModel(self)
        return model
    }
}

extension TTTModel {
    fileprivate func nextPlayerAfter(_ player: GKGameModelPlayer?) -> GKGameModelPlayer? {
        guard let players = players as? [TTTPlayer] else { return nil }
        guard let player = player as? TTTPlayer else { return nil }

        assert(players.count == 2)

        let playerX = players.filter { $0.piece == TTTPiece.x }.first!
        let playerO = players.filter { $0.piece == TTTPiece.o }.first!

        return (player == playerX) ? playerO : playerX
    }
}

extension TTTModel: GKGameModel {
    func setGameModel(_ model: GKGameModel) {
        guard let model = model as? TTTModel else { return }

        self.board = model.board
        self.activePlayer = model.activePlayer
    }

    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        guard let player = player as? TTTPlayer else { return nil }

        let indexed = board.positions.enumerated().map { return (index: $0, marker: $1) }
        let empty = indexed.filter { (_, marker) -> Bool in
            return (marker.position == .empty) ? true : false
        }

        let moves = empty.map { return TTTMove(index: $0.index, piece: player.piece)}
        return (moves.count > 0) ? moves: nil
    }

    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        guard let move = gameModelUpdate as? TTTMove else { return }

        self.board = board.afterMaking(move)
        self.activePlayer = nextPlayerAfter(activePlayer)
    }

    func score(for player: GKGameModelPlayer) -> Int {
        guard let player = player as? TTTPlayer else { return 0 }
        let piece = player.piece

        let score = board.score(forPiece: piece)
        let opponent = (board.score(forPiece: piece.opposite) - 20) * -1
        let adjusted = score + opponent

        return adjusted
    }
}
