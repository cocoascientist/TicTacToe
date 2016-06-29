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
    
    lazy var onePlayerButton: MenuButton = {
        let title = NSLocalizedString("One Player", comment: "One Player")
        let button = MenuButton(title: title, texture: "purpleButton", action: self.startOnePlayerGame)
        
        return button
    }()
    
    lazy var twoPlayerButton: MenuButton = {
        let title = NSLocalizedString("Two Player", comment: "Two Player")
        let button = MenuButton(title: title, texture: "purpleButton", action: self.startTwoPlayerGame)
        
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
        self.backgroundColor = Color.hexColor("#06D6A0")
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
        
        self.addChild(onePlayerButton)
        self.addChild(twoPlayerButton)
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
