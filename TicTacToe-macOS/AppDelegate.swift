//
//  AppDelegate.swift
//  TicTacToe
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
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        //
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    override func awakeFromNib() {
        window.aspectRatio = window.frame.size
    }
    
    @IBAction func handleNewGame(_ sender: AnyObject) -> Void {
        print("new game!")
        
        let size = skView.frame.size
        let scene = GameScene(size: size, type: .onePlayer)
        scene.scaleMode = .aspectFit
//        scene.presentationDelegate = self
        
        self.skView.presentScene(scene)
        
        self.window.setIsVisible(true)
    }
}
