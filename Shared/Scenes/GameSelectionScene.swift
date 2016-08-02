//
//  GameSelectionScene.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 7/12/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit

class GameSelectionScene: SKScene {
    
    let controller = MulitpeerController()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.backgroundColor = UIColor.red
        
        controller.browser.startBrowsingForPeers()
        controller.advertiser.startAdvertisingPeer()
    }
}
