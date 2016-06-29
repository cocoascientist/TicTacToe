//
//  ChooserScene.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/27/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    unowned var manager: SceneManager
    
    var buttonSize: CGSize {
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
    
    lazy var highScoresButton: MenuButton = {
        let title = NSLocalizedString("High Scores", comment: "High Scores")
        let button = MenuButton(title: title, size: self.buttonSize, action: self.startTwoPlayerGame)
        
        return button
    }()
    
    lazy var settingsButton: MenuButton = {
        let title = NSLocalizedString("Settings", comment: "Settings")
        let button = MenuButton(title: title, size: self.buttonSize, action: self.startTwoPlayerGame)
        
        return button
    }()
    
    init(manager: SceneManager, size: CGSize) {
        self.manager = manager
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = Style.Colors.background
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.removeAllChildren()
        positionButtons()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

extension MenuScene {
    private func positionButtons() {
        onePlayerButton.position = CGPoint(x: 0, y: 150)
        twoPlayerButton.position = CGPoint(x: 0, y: 75)
        highScoresButton.position = CGPoint(x: 0, y: -25)
        settingsButton.position = CGPoint(x: 0, y: -100)
        
        self.addChild(onePlayerButton)
        self.addChild(twoPlayerButton)
        self.addChild(highScoresButton)
        self.addChild(settingsButton)
    }
    
    private func startOnePlayerGame() {
        print("start one player")
        
        manager.stateMachine.enterState(GameState.self)
    }
    
    private func startTwoPlayerGame() {
        print("start two player")
        
        manager.stateMachine.enterState(GameState.self)
    }
}
