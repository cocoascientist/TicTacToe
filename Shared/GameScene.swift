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
        let size = CGSize(width: 84, height: 34)
        let action = self.quitGameScene
        let button = GameButton(title: title, size: size, action: action)
        
        return button
    }()
    
    lazy var restartButton: GameButton = {
        let title = NSLocalizedString("Restart", comment: "Restart")
        let size = CGSize(width: 84, height: 34)
        let action = self.restartGameScene
        let button = GameButton(title: title, size: size, action: action)
        
        return button
    }()
    
    lazy var moveLabel: SKLabelNode = {
        let node = SKLabelNode(text: "")
        
        node.fontName = "MarkerFelt-Wide"
        node.fontSize = 24
        
        return node
    }()
    
    lazy var gameStateMachine: GameplayStateMachine = {
        let states = [
            SelectNextPlayerState(scene: self),
            PlayerXTurnState(),
            PlayerOTurnState(),
            CheckBoardState(model: self.model),
            GameOverState(scene: self)
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
        
        positionPieces()
        positionButtons()
        positionLabels()
        restartGameScene()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

extension GameScene {
    
    private func positionPieces() {
        let size = Board.size
        let dimension = Board.dimension
        let alphas = "abcdefgh"
        let offset = CGPoint(x: 100.0, y: 100.0)
        
        for row in 0..<dimension {
            for column in 0..<dimension {
                let node = PositionNode(row: row, column: column, size: size)
                node.name = "\(Array(alphas.characters)[column])\(2-row)"
                
                let xPos = (CGFloat(column) * size.width * 1) - offset.x
                let yPos = (CGFloat(row) * size.height * -1) + offset.y
                let point = CGPoint(x: xPos, y: yPos)
                
                node.position = point
                
                self.addChild(node)
            }
        }
    }
    
    private func positionButtons() {
        guard let frame = self.view?.frame else { return }
        
        let xPos = -1 * frame.midX + 54
        let yPos = 1 * frame.midY - quitButton.size.height
        
        self.quitButton.position = CGPoint(x: xPos, y: yPos)
        self.restartButton.position = CGPoint(x: -xPos, y: yPos)
        
        self.addChild(quitButton)
        self.addChild(restartButton)
    }
    
    private func positionLabels() {
        guard let frame = self.view?.frame else { return }

        let yPos = frame.midY - 20
        self.moveLabel.position = CGPoint(x: 0, y: -yPos)
        
        self.addChild(moveLabel)
    }
    
    private func quitGameScene() {
        manager.stateMachine.enterState(MenuState.self)
    }
    
    private func restartGameScene() {
        self.model.resetGameBoard()
        gameStateMachine.resetToInitialState()
        
        for node in self.children {
            if node is PositionNode {
                node.removeAllChildren()
            }
        }
    }
    
    private func canAddPiece() -> Bool {
        let state = gameStateMachine.currentState
        return state is PlayerXTurnState || state is PlayerOTurnState
    }
    
    private func isGameOver() -> Bool {
        return gameStateMachine.currentState is GameOverState
    }
    
    internal func placePieceOn(node: SKNode) {
        guard let node = node as? PositionNode else { return }
        guard node.children.count == 0 else { return }
        guard canAddPiece() else { return }
        
        let glyph = gameStateMachine.glyphForState
        let sprite = GlyphNode(glyph: glyph)
        
        let color = gameStateMachine.glyphColorForState
        
        sprite.fillColor = color
        sprite.strokeColor = color
        
        let frame = sprite.calculateAccumulatedFrame()
        
        sprite.position = CGPoint(x: -frame.midX, y: -frame.midY)
        node.addChild(sprite)
        
        let index = node.row * 3 + node.column
        
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
    }
}