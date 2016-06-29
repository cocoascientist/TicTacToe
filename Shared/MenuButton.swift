//
//  MenuButton.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit

typealias Action = () -> Void

class MenuButton: SKNode {
    private(set) var title: String
    private(set) var size: CGSize
    private(set) var action: Action
    
    lazy var label: SKLabelNode = {
        let node = SKLabelNode(text: self.title)
        
        node.verticalAlignmentMode = .Center
        node.fontName = "MarkerFelt-Wide"
        node.zPosition = 5
        node.fontColor = Style.Colors.text
        
        return node
    }()
    
    lazy var focusRing: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "focusRing")
        return node
    }()
    
    lazy var background: SKShapeNode = {
        let size = self.size
        let height = size.height / 2
        let radius = (height % 2 == 0) ? height : height - 1
        
        let node = SKShapeNode(rectOfSize: size, cornerRadius: radius)
        
        node.fillColor = Style.Colors.button
        node.strokeColor = Style.Colors.button
        
        return node
    }()
    
    init(title: String, size: CGSize, action: Action) {
        
        self.title = title
        self.action = action
        self.size = size
        super.init()
        
        addChild(self.background)
        addChild(self.label)
        
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    var isHighlighted = false {
        // Animate to a pressed / unpressed state when the highlight state changes.
        didSet {
            // Guard against repeating the same action.
            guard oldValue != isHighlighted else { return }
            
            // Remove any existing animations that may be in progress.
            removeAllActions()
            
            // Create a scale action to make the button look like it is slightly depressed.
            let newScale: CGFloat = isHighlighted ? 0.99 : 1.01
            let scaleAction = SKAction.scaleBy(newScale, duration: 0.15)
            
            // Create a color blend action to darken the button slightly when it is depressed.
            let newColorBlendFactor: CGFloat = isHighlighted ? 1.0 : 0.0
            let colorBlendAction = SKAction.colorizeWithColorBlendFactor(newColorBlendFactor, duration: 0.15)
            
            // Run the two actions at the same time.
            runAction(SKAction.group([scaleAction, colorBlendAction]))
        }
    }
    
    /**
     Input focus shows which button will be triggered when the action
     button is pressed on indirect input devices such as game controllers
     and keyboards.
     */
    var isFocused = false {
        didSet {
            if isFocused {
                runAction(SKAction.scaleTo(1.08, duration: 0.20))
                
                focusRing.alpha = 0.0
                focusRing.hidden = false
                focusRing.runAction(SKAction.fadeInWithDuration(0.2))
            }
            else {
                runAction(SKAction.scaleTo(1.0, duration: 0.20))
                
                focusRing.hidden = true
            }
        }
    }
}

extension MenuButton {
    #if os(iOS) || os(tvOS)
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        isHighlighted = true
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
    
        isHighlighted = false
        if containsTouches(touches) { action() }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        
        isHighlighted = false
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
    
    override func mouseDown(event: NSEvent) {
        isHighlighted = true
    }
    
    override func mouseUp(event: NSEvent) {
        isHighlighted = false
        if containsLocationForEvent(event) { action() }
    }
    
    private func containsLocationForEvent(event: NSEvent) -> Bool {
        guard let scene = scene else { fatalError("Button must be used within a scene.")  }
        
        let location = event.locationInNode(scene)
        let clickedNode = scene.nodeAtPoint(location)
        return clickedNode === self || clickedNode.inParentHierarchy(self)
    }
    
    #endif
}