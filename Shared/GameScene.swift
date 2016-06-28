//
//  GameScene.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/27/16.
//  Copyright (c) 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit

#if os(OSX)
    typealias Color = NSColor
#elseif os(iOS) || os(tvOS)
    typealias Color = UIColor
#endif

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
        let button = MenuButton(title: title, texture: "smallButton", action: self.quitGameScene)
        
        return button
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
        
        self.backgroundColor = Color.grayColor()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.addChild(boardNode)
        
        positionPieces()
        positionButtons()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    private func positionPieces() {
        let size = board.piece
        let alphas = "abcdefgh"
        let offset = CGPoint(x: 100.0, y: 100.0)
        
        for row in 0..<board.columns {
            for col in 0..<board.rows {
                let colChar = Array(alphas.characters)[col]
                let square = SKSpriteNode(color: Color.clearColor(), size: size)
                square.name = "\(colChar)\(2-row)"
                square.userInteractionEnabled = false
                
                let point = CGPoint(x: CGFloat(col) * size.width - offset.x, y: CGFloat(row) * size.height - offset.y)
                square.position = point
                
                self.addChild(square)
            }
        }
    }
    
    private func createPieceX() -> SKLabelNode {
        return self.createNode(with: "X")
    }
    
    private func createPieceO() -> SKLabelNode {
        return self.createNode(with: "O")
    }
    
    private func createNode(with text: String) -> SKLabelNode {
        let node = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        
        node.text = text
        node.fontSize = 96.0
        node.verticalAlignmentMode = .Center
        node.userInteractionEnabled = false
        
        return node
    }
    
    private func positionButtons() {
        self.quitButton.position = CGPoint(x: -120, y: 260)
        
        self.addChild(quitButton)
    }
    
    private func quitGameScene() {
        manager.stateMachine.enterState(MenuState.self)
    }
    
    private func childNodeName(forTouchPoint touchPoint: CGPoint) -> SKNode? {
        return nil
    }
}

extension GameScene {
    #if os(iOS)
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if containsTouches(touches) {
            guard let touch = touches.first else { return }
            guard let scene = scene else { return }
            
            let touchPoint = touch.locationInNode(scene)
            let touchedNode = scene.nodeAtPoint(touchPoint)
            
            if let _ = touchedNode.name {
                let piece = createPieceX()
                touchedNode.addChild(piece)
            }
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
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
    
    #endif
}