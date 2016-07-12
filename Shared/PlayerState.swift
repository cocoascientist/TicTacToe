//
//  PlayerState.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 7/11/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation
import GameplayKit

class PlayerState: InPlayState {
    private let isComputerPlayer: Bool
    
    required init(scene: SKScene, isComputerPlayer: Bool = false) {
        self.isComputerPlayer = isComputerPlayer
        super.init(scene: scene)
    }
    
    required init(scene: SKScene) {
        self.isComputerPlayer = false
        super.init(scene: scene)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func didEnter(withPreviousState previousState: GKState?) {
        if isComputerPlayer {
            guard let scene = scene as? GameScene else { return }
            guard let player = scene.model.activePlayer as? TTTPlayer else { return }
            let glyph = player.piece.glyph
            
            let title = NSLocalizedString("Player \(glyph) is making a move...", comment: "")
            scene.moveLabel.text = title
            scene.moveLabel.fontColor = Style.Colors.blue
            
            let delay = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.after(when: delay) {
                if let move = scene.strategist.bestMove(for: player) {
                    scene.makeMoveForActivePlayer(move)
                }
                else {
                    fatalError("no moves found...")
                }
            }
        }
        else {
            // if the player isn't artificial, the UI will transition
            // states when the user makes a move.
        }
    }
}

class PlayerOTurnState: PlayerState { }
class PlayerXTurnState: PlayerState { }
