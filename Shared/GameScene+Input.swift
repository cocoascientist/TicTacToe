//
//  GameScene+Input.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/29/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

extension GameScene {
    #if os(iOS)
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if self.gameStateMachine.currentState is CheckBoardState {
            return
        }
        
        if containsTouches(touches) {
            guard let touch = touches.first else { return }
            guard let scene = scene else { return }
            
            let touchPoint = touch.locationInNode(scene)
            let node = scene.nodeAtPoint(touchPoint)
            
            guard node is PositionNode else { return }
            
            self.placePieceOn(node)
            self.gameStateMachine.enterState(CheckBoardState.self)
        }
    }
    
    private func containsTouches(touches: Set<UITouch>) -> Bool {
        guard let scene = scene else { fatalError("Button must be used within a scene.") }
        
        return touches.contains { touch in
            let touchPoint = touch.locationInNode(scene)
            let touchedNode = scene.nodeAtPoint(touchPoint)
            return touchedNode === self || touchedNode.inParentHierarchy(self)
        }
    }
    
    #elseif os(OSX)
    
    override func mouseUp(event: NSEvent) {
        if self.gameStateMachine.currentState is CheckBoardState {
            return
        }
        
        if containsLocationForEvent(event) {
            guard let scene = scene else { return }
            let location = event.locationInNode(scene)
            let node = scene.nodeAtPoint(location)
            
            guard node is PositionNode else { return }
            
            self.handleUIEventOn(node)
            self.gameStateMachine.enterState(CheckBoardState.self)
        }
    }
    
    private func containsLocationForEvent(event: NSEvent) -> Bool {
        guard let scene = scene else { fatalError("Button must be used within a scene.")  }
        
        let location = event.locationInNode(scene)
        let clickedNode = scene.nodeAtPoint(location)
        return clickedNode === self || clickedNode.inParentHierarchy(self)
    }
    
    #endif
}