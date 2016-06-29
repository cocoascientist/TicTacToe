//
//  PositionNode.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit

class PositionNode: SKSpriteNode {
    
    init(name: String, size: CGSize) {
        super.init(texture: nil, color: Color.clearColor(), size: size)
        
        self.name = name
        self.userInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}