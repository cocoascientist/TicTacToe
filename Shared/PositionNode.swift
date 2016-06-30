//
//  PositionNode.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit

class PositionNode: SKSpriteNode {
    
    let row: Int
    let column: Int
    
    lazy var debugLabel: SKLabelNode = {
        let text = "\(self.row), \(self.column)"
        let node = SKLabelNode(text: text)
        
        node.fontSize = 12
        node.fontName = "Helvetica"
//        node.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        node.zPosition = 100
        
        return node
    }()
    
    init(row: Int, column: Int, size: CGSize) {
        self.row = row
        self.column = column
        
        super.init(texture: nil, color: Color.clearColor(), size: size)
        
        self.addChild(debugLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}