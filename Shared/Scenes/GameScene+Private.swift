//
//  GameScene+Private.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 7/12/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    internal func quitGameScene() {
        self.removeGamePieces()
        self.model.resetGameBoard()
        self.gameStateMachine.resetToInitialState()
        
        self.presentationDelegate?.shouldDismissScene(self)
    }
    
    internal func restartGameScene() {
        self.moveLabel.text = ""
        animateNodesOffScreen()
        
        let delay = DispatchTime.now() + Double(Int64(0.55 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) { [unowned self] in
            self.removeGamePieces()
            self.model.resetGameBoard()
            self.gameStateMachine.resetToInitialState()
        }
    }
    
    internal func setupEmptyGame() {
        positionPieces()
        #if os(iOS)
        positionButtons()
        #endif
        positionLabels()
        
        self.model.resetGameBoard()
        gameStateMachine.resetToInitialState()
    }
    
    internal func placePiece(_ piece: TTTPiece, row: Int, column: Int) {
        let node = nodeAt(row, column: column)
        addPiece(piece, on: node)
    }
    
    internal func nodeAt(_ row: Int, column: Int) -> PositionNode {
        //FIXME: shouldn't these be board node children?
        
        let positions = self.children.filter {
            return $0 is PositionNode
            }.compactMap {
                return $0 as? PositionNode
            }.filter {
                return $0.column == column && $0.row == row
        }
        
        assert(positions.count == 1)
        
        guard let node = positions.first else { fatalError() }
        
        return node
    }
}

extension GameScene {
    
    fileprivate func positionPieces() {
        let size = Board.pieceSize
        let dimension = Board.dimension
        
        for row in 0..<dimension {
            for column in 0..<dimension {
                let node = PositionNode(row: row, column: column, size: size)
                node.name = "\(Array("abc")[column])\(2-row)"
                
                let xPos = (CGFloat(column) * size.width * 1) - size.width
                let yPos = (CGFloat(row) * size.height * -1) + size.height
                let point = CGPoint(x: xPos, y: yPos)
                
                print(point)
                
                node.position = point
                
                self.addChild(node)
            }
        }
    }
    
    fileprivate func positionButtons() {
        guard let frame = self.view?.frame else { return }
        
        let xPos = -1 * frame.midX + 54
        let yPos = 1 * frame.midY - quitButton.size.height
        
        self.quitButton.position = CGPoint(x: xPos, y: yPos)
        self.restartButton.position = CGPoint(x: -xPos, y: yPos)
        
        self.addChild(quitButton)
        self.addChild(restartButton)
    }
    
    fileprivate func positionLabels() {
        guard let frame = self.view?.frame else { return }
        
        let yPos = frame.midY - 20
        self.moveLabel.position = CGPoint(x: 0, y: -yPos)
        
        self.addChild(moveLabel)
    }
    
    fileprivate func removeGamePieces() {
        self.children.forEach { (node) in
            if node is PositionNode {
                node.removeAllChildren()
                node.removeAllActions()
                node.xScale = 1.0
                node.yScale = 1.0
            }
        }
    }
    
    fileprivate func canAddPiece() -> Bool {
        let state = gameStateMachine.currentState
        return state is PlayerXTurnState || state is PlayerOTurnState
    }
    
    fileprivate func isGameOver() -> Bool {
        return gameStateMachine.currentState is GameOverState
    }
    
    fileprivate func currentGamePiece() -> TTTPiece {
        guard let player = self.model.activePlayer as? TTTPlayer else { fatalError() }
        
        return player.piece
    }
    
    fileprivate func addPiece(_ piece: TTTPiece, on node: SKNode) {
        let sprite = GlyphNode(glyph: piece.glyph)
        let color = Color.hexColor(piece.hexColor)
        
        sprite.fillColor = color
        sprite.strokeColor = color
        
        let frame = sprite.calculateAccumulatedFrame()
        
        sprite.position = CGPoint(x: -frame.midX, y: -frame.midY)
        node.addChild(sprite)
    }
    
    fileprivate func placePieceOn(_ node: SKNode) -> Bool {
        guard let node = node as? PositionNode else { return false }
        guard node.children.count == 0 else { return false }
        guard canAddPiece() else { return false }
        
        let piece = currentGamePiece()
        placePiece(piece, row: node.row, column: node.column)
        
        return true
    }
}
