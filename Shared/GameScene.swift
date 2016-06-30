//
//  GameScene.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/27/16.
//  Copyright (c) 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameType {
    case OnePlayer
    case TwoPlayer
}

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
    
    // could refactor, hide these in a different layer... button node layer
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
    
    // seems like you want a player state and computer state?
    // or should player X and O be configured as different opponent types?
    
    lazy var onePlayerStates: [GKState] = {
        let states = [
            SelectNextPlayerState(scene: self),
            PlayerXTurnState(),
            PlayerOTurnState(scene: self, isComputerPlayer: true),
            CheckBoardState(model: self.model),
            GameOverState(scene: self)
        ]
        
        return states
    }()
    
    lazy var twoPlayerStates: [GKState] = {
        let states = [
            SelectNextPlayerState(scene: self),
            PlayerXTurnState(),
            PlayerOTurnState(scene: self),
            CheckBoardState(model: self.model),
            GameOverState(scene: self)
        ]
        
        return states
    }()
    
    lazy var gameStateMachine: GameplayStateMachine = {
        let states = (self.type == .OnePlayer) ? self.onePlayerStates : self.twoPlayerStates
        let machine = GameplayStateMachine(states: states)
        return machine
    }()
    
    lazy var strategist: GKMinmaxStrategist = {
        let strategist = GKMinmaxStrategist()
        strategist.gameModel = self.model
        strategist.maxLookAheadDepth = 1
        strategist.randomSource = GKMersenneTwisterRandomSource()
        
        // none of this matters until you implement scoreForPlayer
        
        return strategist
    }()
    
    private(set) var model: TTTModel
    
    let playerX: TTTPlayer
    let playerO: TTTPlayer
    let type: GameType
    
    private(set) unowned var manager: SceneManager
    
    init(manager: SceneManager, size: CGSize, type: GameType) {
        self.manager = manager
        self.type = type
        
        // should the state machine own these?
        // the AI computer state needs to manipulate model
        // the model needs to track activePlayer...
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
    func handleUIEventOn(node: SKNode) {
        guard let node = node as? PositionNode else { return }
        guard let player = model.activePlayer as? TTTPlayer else { return }
        
        let column = node.column
        let row = node.row
        
        let index = column + row * model.board.rows
        
        let piece = player.piece
        let move = TTTMove(index: index, piece: piece)
        
        makeMoveForActivePlayer(move)
    }
    
    func makeMoveForActivePlayer(move: GKGameModelUpdate) {
        guard let move = move as? TTTMove else { return }
        
        let column = move.index % model.board.rows
        let row = move.index / model.board.rows
        
        print("move it: \(row), \(column)")
        
        placePiece(move.piece, row: row, column: column)
        
        model.applyGameModelUpdate(move)
        gameStateMachine.enterState(CheckBoardState.self)
    }
}

extension GameScene {
    
    private func positionPieces() {
        let size = Board.size
        let dimension = Board.dimension
        let offset = CGPoint(x: 100.0, y: 100.0)
        
        for row in 0..<dimension {
            for column in 0..<dimension {
                let node = PositionNode(row: row, column: column, size: size)
                node.name = "\(Array("abc".characters)[column])\(2-row)"
                
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
        self.restartGameScene()
        manager.stateMachine.enterState(MenuState.self)
    }
    
    private func restartGameScene() {
        self.model.resetGameBoard()
        gameStateMachine.resetToInitialState()
        
        // too much work for debug labels..
        for node in self.children {
            if node is PositionNode {
                for child in node.children {
                    if !(child is DebugLabel) {
                        child.removeFromParent()
                    }
                }
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
    
    private func currentGamePiece() -> TTTPiece {
        guard let player = self.model.activePlayer as? TTTPlayer else { fatalError() }
        
        return player.piece
    }
    
    private func placePiece(piece: TTTPiece, row: Int, column: Int) {
        //FIXME: shouldn't these be board node children?
        
        let positions = self.children.filter {
            return $0 is PositionNode
        }.flatMap {
            return $0 as? PositionNode
        }.filter {
            return $0.column == column && $0.row == row
        }
        
        assert(positions.count == 1)
        
        guard let node = positions.first else { return }
        
        addPiece(piece, on: node)
    }
    
    private func addPiece(piece: TTTPiece, on node: SKNode) {
        
        let sprite = GlyphNode(glyph: piece.glyph)
        let color = Color.hexColor(piece.hexColor)
        
        sprite.fillColor = color
        sprite.strokeColor = color
        
        let frame = sprite.calculateAccumulatedFrame()
        
        sprite.position = CGPoint(x: -frame.midX, y: -frame.midY)
        node.addChild(sprite)
    }
    
    private func placePieceOn(node: SKNode) -> Bool {
        guard let node = node as? PositionNode else { return false }
        guard node.children.count == 0 else { return false }
        guard canAddPiece() else { return false }
        
        let piece = currentGamePiece()
        placePiece(piece, row: node.row, column: node.column)
        
        return true
    }
}