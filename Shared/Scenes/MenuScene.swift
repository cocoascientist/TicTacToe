//
//  ChooserScene.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/27/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    unowned var stateMachine: GKStateMachine
    
    private var buttonSize: CGSize {
        return CGSize(width: 300, height: 50)
    }
    
    lazy var onePlayerButton: MenuButton = {
        let title = NSLocalizedString("One Player", comment: "One Player")
        let button = MenuButton(title: title, size: self.buttonSize, action: self.startOnePlayerGame)
        
        return button
    }()
    
    lazy var twoPlayerButton: MenuButton = {
        let title = NSLocalizedString("Two Player", comment: "Two Player")
        let button = MenuButton(title: title, size: self.buttonSize, action: self.startTwoPlayerGame)
        
        return button
    }()
    
//    lazy var highScoresButton: MenuButton = {
//        let title = NSLocalizedString("High Scores", comment: "High Scores")
//        let button = MenuButton(title: title, size: self.buttonSize, action: self.startTwoPlayerGame)
//        
//        return button
//    }()
//    
//    lazy var settingsButton: MenuButton = {
//        let title = NSLocalizedString("Settings", comment: "Settings")
//        let button = MenuButton(title: title, size: self.buttonSize, action: self.startTwoPlayerGame)
//        
//        return button
//    }()
    
    lazy var toadSprite: SKSpriteNode = {
        return SKSpriteNode(imageNamed: "toad")
    }()
    
    init(size: CGSize, stateMachine: GKStateMachine) {
        self.stateMachine = stateMachine
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = Style.Colors.background
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.removeAllChildren()
        positionButtons()
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}

extension MenuScene {
    private func positionButtons() {
        onePlayerButton.position = CGPoint(x: 0, y: 150)
        twoPlayerButton.position = CGPoint(x: 0, y: 75)
        
        toadSprite.position = CGPoint(x: 0, y: -100)
        
        self.addChild(onePlayerButton)
        self.addChild(twoPlayerButton)
        
        self.addChild(toadSprite)
    }
    
    private func startOnePlayerGame() {
        self.stateMachine.enterState(OnePlayerState.self)
    }
    
    private func startTwoPlayerGame() {
        self.stateMachine.enterState(TwoPlayerState.self)
    }
}
