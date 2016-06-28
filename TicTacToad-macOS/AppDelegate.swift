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
    
    lazy var sceneManager: SceneManager = {
        return SceneManager(view: self.skView)
    }()
    
    lazy var stateMachine: GKStateMachine = {
        return self.sceneManager.stateMachine
    }()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.stateMachine.enterState(MenuState.self)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}
