//
//  ScenePresentationDelegate.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 7/13/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation
import SpriteKit

protocol ScenePresentationDelegate {
    func shouldDismissScene(_ scene: SKScene) -> Void
}
