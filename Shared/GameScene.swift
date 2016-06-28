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
#elseif os(iOS)
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
        return node
    }()
    
    var board: Board {
        let size = CGSize(width: 100.0, height: 100.0)
        let board = Board(columns: 3, rows: 3, piece: size)
        
        return board
    }
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = Color.grayColor()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.addChild(boardNode)
        
        positionPieces()
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
                let name = "\(colChar)\((board.rows - 1) - row)"
                let square = SKLabelNode(text: name)
                square.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
                
                let point = CGPoint(x: CGFloat(col) * size.width - offset.x, y: CGFloat(row) * size.height - offset.y)
                square.position = point
                square.name = "\(colChar)\(2-row)"
                
                self.addChild(square)
            }
        }
        
        ["a1", "b1", "c1"].forEach { (name) in
            let place = self.childNodeWithName(name)
            let piece = createPieceX()
            
            place?.addChild(piece)
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
        
        return node
    }
}

extension GameScene {
    #if os(OSX)
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
    
    }
    
    #elseif os(iOS)
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
    }
    
    #endif
}
