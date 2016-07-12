//
//  AppDelegate.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/27/16.
//  Copyright (c) 2016 Andrew Shepard. All rights reserved.
//


import Cocoa
import SpriteKit
import GameplayKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    lazy var sceneStateMachine: GKStateMachine = {
        let states = [
            MenuState(view: self.skView),
            OnePlayerState(view: self.skView),
            TwoPlayerState(view: self.skView)
        ]
        
        return GKStateMachine(states: states)
    }()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        self.sceneStateMachine.enterState(MenuState.self)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
