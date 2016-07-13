//
//  InPlayState.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 7/11/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

protocol InPlayStateType {
    unowned var scene: SKScene { get }
    var model: TTTModel { get }
    
    init(scene: SKScene)
}

extension InPlayStateType where Self: GKState {
    var model: TTTModel {
        guard let scene = scene as? GameScene else { fatalError() }
        return scene.model
    }
}

class InPlayState: GKState, InPlayStateType {
    private(set) unowned var scene: SKScene
    
    required init(scene: SKScene) {
        self.scene = scene
        super.init()
    }
}
