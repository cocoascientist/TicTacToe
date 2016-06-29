//
//  GameScene.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/27/16.
//  Copyright (c) 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit
import GameplayKit

private struct Board {
    static let size = CGSize(width: 100.0, height: 100.0)
    static let dimension = 3
}

class GameScene: SKScene {
    lazy var boardNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "board3")
        node.position = CGPoint(x: 0.0, y: 0.0)
        node.zPosition = -1
        node.userInteractionEnabled = false
        return node
    }()
    
    lazy var quitButton: GameButton = {
        let title = NSLocalizedString("Quit", comment: "Quit")
        let size = CGSize(width: 64, height: 34)
        let action = self.quitGameScene
        let button = GameButton(title: title, size: size, action: action)
        
        return button
    }()
    
    lazy var gameStateMachine: GameplayStateMachine = {
        let states = [
            SelectNextPlayerState(),
            PlayerXTurnState(),
            PlayerOTurnState(),
            CheckBoardState(model: self.model),
            GameOverState()
        ]
        
        let machine = GameplayStateMachine(states: states)
        return machine
    }()
    
    private(set) var model: TTTModel
    private(set) var playerX: TTTPlayer
    private(set) var playerO: TTTPlayer
    
    private(set) unowned var manager: SceneManager
    
    private let strategist: GKMinmaxStrategist = GKMinmaxStrategist()
    
    init(manager: SceneManager, size: CGSize) {
        self.manager = manager
        
        self.playerX = TTTPlayer(playerId: 1, piece: .X)
        self.playerO = TTTPlayer(playerId: 2, piece: .O)
        self.model = TTTModel(players: [playerO, playerX])
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        self.removeAllChildren()
        
        self.backgroundColor = Style.Colors.background
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.addChild(boardNode)
        
        resetGamePlayState()
        positionPieces()
        positionButtons()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

extension GameScene {
    private func resetGamePlayState() {
        self.gameStateMachine.resetToInitialState()
    }
    
    private func positionPieces() {
        let size = Board.size
        let dimension = Board.dimension
        let alphas = "abcdefgh"
        let offset = CGPoint(x: 100.0, y: 100.0)
        
        for row in 0..<dimension {
            for column in 0..<dimension {
                let node = PositionNode(row: row, column: column, size: size)
                node.name = "\(Array(alphas.characters)[column])\(2-row)"
                
                let xPos = CGFloat(column) * size.width - offset.x
                let yPos = (CGFloat(row) * size.height * -1) + offset.y
                let point = CGPoint(x: xPos, y: yPos)
                
                node.position = point
                
                self.addChild(node)
            }
        }
    }
    
    private func positionButtons() {
        guard let frame = self.view?.frame else { return }
        
        let xPos = -1 * frame.midX + quitButton.size.width
        let yPos = 1 * frame.midY - quitButton.size.height
        
        self.quitButton.position = CGPoint(x: xPos, y: yPos)
        
        self.addChild(quitButton)
    }
    
    private func quitGameScene() {
        manager.stateMachine.enterState(MenuState.self)
    }
    
    // called in response to touch event...
    internal func placePieceOn(node: SKNode) {
        guard let node = node as? PositionNode else { return }
        guard node.children.count == 0 else { return }
        
        let glyph = gameStateMachine.glyphForState
        let sprite = GlyphNode(glyph: glyph)
        
        let color = gameStateMachine.glyphColorForState
        
        sprite.fillColor = color
        sprite.strokeColor = color
        
        let frame = sprite.calculateAccumulatedFrame()
        
        sprite.position = CGPoint(x: -frame.midX, y: -frame.midY)
        node.addChild(sprite)
        
        //            let new = model.board.afterMakingMove(with: .X, at: 0)
        
        // TODO: maps between nodes and board indexes
        
        // columnIndex * numberOfRows + rowIndex.
        
        let index = node.row * 3 + node.column
//        let piece = (gameStateMachine.currentState is PlayerXTurnState) ? TTTPiece.X : TTTPiece.O
        
        if let lastPlayerState = gameStateMachine.lastPlayerState {
            if lastPlayerState is PlayerXTurnState.Type {
                let update = TTTMove(index: index, piece: .X)
                self.model.applyGameModelUpdate(update)
            }
            else {
                let update = TTTMove(index: index, piece: .O)
                self.model.applyGameModelUpdate(update)
            }
        }
        

        
//        let update = TTTMove(index: index, piece: .O)
//        self.model.applyGameModelUpdate(update)
    }
}