//
//  GameOverState.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/29/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameOverState: GKState {
    private(set) unowned var scene: SKScene
    
    init(scene: SKScene) {
        self.scene = scene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        guard let scene = self.scene as? GameScene else { return }
        
        let board = scene.model.board
        
        if board.isWin(forPiece: .X) {
            let title = NSLocalizedString("Player X wins!", comment: "Player X wins!")
            scene.moveLabel.text = title
            scene.moveLabel.fontColor = Style.Colors.orange
        }
        else if board.isWin(forPiece: .O) {
            let title = NSLocalizedString("Player O wins!", comment: "Player O wins!")
            scene.moveLabel.text = title
            scene.moveLabel.fontColor = Style.Colors.blue
        }
        else {
            let title = NSLocalizedString("It's a Draw!", comment: "It's a Draw!")
            scene.moveLabel.text = title
            scene.moveLabel.fontColor = Style.Colors.blue
        }
        
        // digging too deep in restart button... hide this?
        let title = NSLocalizedString("Again?", comment: "Again?")
        scene.restartButton.label.text = title
        
        guard let winningCombo = board.winningCombo() else { return }
        
        winningCombo.forEach { (index) in
            let column = index % board.rows
            let row = index / board.rows
            scene.wiggleNodeAt(row, column: column)
        }
    }
}
