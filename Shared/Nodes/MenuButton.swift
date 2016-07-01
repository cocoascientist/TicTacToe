//
//  MenuButton.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit

class MenuButton: ButtonNode {
    
    lazy var label: SKLabelNode = {
        let node = SKLabelNode(text: self.title)
        
        node.verticalAlignmentMode = .Center
        node.fontName = "MarkerFelt-Wide"
        node.zPosition = 5
        node.fontColor = Style.Colors.text
        
        return node
    }()
    
    override init(title: String, size: CGSize, action: ButtonAction) {
        super.init(title: title, size: size, action: action)
        
        addChild(self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}