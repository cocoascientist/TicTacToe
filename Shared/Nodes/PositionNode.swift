//
//  PositionNode.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit

class DebugLabel: SKLabelNode {
    override init() {
        super.init()
        
        self.fontSize = 12
        self.fontName = "Helvetica"
        self.zPosition = 100
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PositionNode: SKSpriteNode {
    
    let row: Int
    let column: Int
    
    lazy var debugLabel: DebugLabel = {
        let node = DebugLabel()
        
        node.text = "\(self.row), \(self.column)"
        node.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        return node
    }()
    
    init(row: Int, column: Int, size: CGSize) {
        self.row = row
        self.column = column
        
        super.init(texture: nil, color: Color.clear(), size: size)
        
//        self.addChild(debugLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
