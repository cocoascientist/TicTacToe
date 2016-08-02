//
//  GameViewController.swift
//  TicTacToad-iOS
//
//  Created by Andrew Shepard on 6/27/16.
//  Copyright (c) 2016 Andrew Shepard. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController {
    
    var type: GameType? = nil
    
    lazy var skView: SKView = {
        guard let skView = self.view as? SKView else { fatalError() }
        return skView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let type = type else { fatalError("expected game type") }
        
        self.navigationController?.navigationBar.isHidden = true
        
        switch type {
        case .onePlayer:
            let size = skView.frame.size
            let scene = GameScene(size: size, type: .onePlayer)
            scene.presentationDelegate = self
            
            self.skView.presentScene(scene)
        default:
            print("nothing")
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: ScenePresentationDelegate {
    func shouldDismissScene(_ scene: SKScene) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
}
