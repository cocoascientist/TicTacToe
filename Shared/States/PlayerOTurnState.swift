//
//  PlayerOTurnState.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit
import SpriteKit

class PlayerOTurnState: GKState {
    
    private let isComputerPlayer: Bool
    private(set) unowned var scene: SKScene
    
    init(scene: SKScene, isComputerPlayer: Bool = false) {
        self.scene = scene
        self.isComputerPlayer = isComputerPlayer
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func didEnter(withPreviousState previousState: GKState?) {
        if isComputerPlayer {
            guard let scene = scene as? GameScene else { return }
            guard let player = scene.model.activePlayer as? TTTPlayer else { return }
            
            let title = NSLocalizedString("Player O is making a move...", comment: "")
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
    }
    
    override func update(withDeltaTime seconds: TimeInterval) {
        print("update!")
    }
}
