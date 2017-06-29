//
//  PositionNode.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit

private class DebugLabel: SKLabelNode {
    override init() {
        super.init()
        
        self.fontSize = CGFloat(Style.Font.debug.size)
        self.fontName = Style.Font.debug.name
        self.zPosition = 100
        self.isUserInteractionEnabled = false
        self.verticalAlignmentMode = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PositionNode: SKSpriteNode {
    
    let row: Int
    let column: Int
    
    private lazy var debugLabel: DebugLabel = {
        let node = DebugLabel()
        
        node.text = "\(self.row), \(self.column)"
        node.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        return node
    }()
    
    init(row: Int, column: Int, size: CGSize) {
        self.row = row
        self.column = column
        
        super.init(texture: nil, color: Color.clear, size: size)
        
//        self.addChild(debugLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
