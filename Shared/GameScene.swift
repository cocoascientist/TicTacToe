//
//  GameScene.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/27/16.
//  Copyright (c) 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Board {
    let columns, rows: Int
    let piece: CGSize
    
    init(columns: Int, rows: Int, piece: CGSize) {
        self.columns = columns
        self.rows = rows
        
        self.piece = piece
    }
}
    

class GameScene: SKScene {
    lazy var boardNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "board3")
        node.position = CGPoint(x: 0.0, y: 0.0)
        node.zPosition = -1
        node.userInteractionEnabled = false
        return node
    }()
    
    lazy var quitButton: MenuButton = {
        let title = NSLocalizedString("Quit", comment: "Quit")
        let size = CGSize(width: 64, height: 34)
        let action = self.quitGameScene
        let button = MenuButton(title: title, size: size, action: action)
        
        return button
    }()
    
    lazy var gameStateMachine: GameplayStateMachine = {
        let states = [
            PlayerXTurnState(),
            PlayerOTurnState(),
            CheckBoardState()
        ]
        
        
        let machine = GameplayStateMachine(states: [PlayerXTurnState(), PlayerOTurnState(), CheckBoardState()])
        return machine
    }()
    
    var board: Board {
        let size = CGSize(width: 100.0, height: 100.0)
        let board = Board(columns: 3, rows: 3, piece: size)
        
        return board
    }
    
    private(set) unowned var manager: SceneManager
    
    init(manager: SceneManager, size: CGSize) {
        self.manager = manager
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
        let size = board.piece
        let alphas = "abcdefgh"
        let offset = CGPoint(x: 100.0, y: 100.0)
        
        for row in 0..<board.columns {
            for col in 0..<board.rows {
                let name = "\(Array(alphas.characters)[col])\(2-row)"
                let node = PositionNode(name: name, size: size)
                
                let xPos = CGFloat(col) * size.width - offset.x
                let yPos = CGFloat(row) * size.height - offset.y
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
    
    private func childNodeName(forTouchPoint touchPoint: CGPoint) -> SKNode? {
        return nil
    }
    
    private func placePieceOn(node: SKNode) {
        if node.children.count == 0 {
            let glyph = gameStateMachine.glyphForState
            let piece = GlyphNode(glyph: glyph)
            
            let color = gameStateMachine.glyphColorForState
            
            piece.fillColor = color
            piece.strokeColor = color
            
            let frame = piece.calculateAccumulatedFrame()
            
            piece.position = CGPoint(x: -frame.midX, y: -frame.midY)
            node.addChild(piece)
        }
    }
}

extension GameScene {
    #if os(iOS)
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if containsTouches(touches) {
            guard let touch = touches.first else { return }
            guard let scene = scene else { return }
            
            let touchPoint = touch.locationInNode(scene)
            let node = scene.nodeAtPoint(touchPoint)
            
            placePieceOn(node)
            self.gameStateMachine.moveToNextState()
        }
    }
    
    private func containsTouches(touches: Set<UITouch>) -> Bool {
        guard let scene = scene else { fatalError("Button must be used within a scene.") }
        
        return touches.contains { touch in
            let touchPoint = touch.locationInNode(scene)
            let touchedNode = scene.nodeAtPoint(touchPoint)
            return touchedNode === self || touchedNode.inParentHierarchy(self)
        }
    }
    
    #elseif os(OSX)
    
    override func mouseUp(event: NSEvent) {
        if self.gameStateMachine.currentState is CheckBoardState {
            return
        }
        
        if containsLocationForEvent(event) {
            guard let scene = scene else { return }
            let location = event.locationInNode(scene)
            let node = scene.nodeAtPoint(location)
            
            guard node is PositionNode else { return }
            
            placePieceOn(node)
            self.gameStateMachine.moveToNextState()
        }
    }
    
    private func containsLocationForEvent(event: NSEvent) -> Bool {
        guard let scene = scene else { fatalError("Button must be used within a scene.")  }
        
        let location = event.locationInNode(scene)
        let clickedNode = scene.nodeAtPoint(location)
        return clickedNode === self || clickedNode.inParentHierarchy(self)
    }
    
    #endif
}