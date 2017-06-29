//
//  ButtonNode.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/29/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import SpriteKit

typealias ButtonAction = () -> Void

class ButtonNode: SKNode {
    fileprivate let delay = 0.20
    
    fileprivate(set) var title: String
    fileprivate(set) var size: CGSize
    fileprivate(set) var action: ButtonAction
    
    lazy var focusRing: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "focusRing")
        return node
    }()
    
    lazy var background: SKShapeNode = {
        let size = self.size
        let height = size.height / 2
        let radius = (height.truncatingRemainder(dividingBy: 2) == 0) ? height : height - 1
        
        let node = SKShapeNode(rectOf: size, cornerRadius: radius)
        
        node.fillColor = Style.Colors.button
        node.strokeColor = Style.Colors.button
        
        return node
    }()
    
    init(title: String, size: CGSize, action: @escaping ButtonAction) {
        
        self.title = title
        self.action = action
        self.size = size
        super.init()
        
        addChild(self.background)
        
        self.isUserInteractionEnabled = true
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
            let scaleAction = SKAction.scale(by: newScale, duration: 0.15)
            
            // Create a color blend action to darken the button slightly when it is depressed.
            let newColorBlendFactor: CGFloat = isHighlighted ? 1.0 : 0.0
            let colorBlendAction = SKAction.colorize(withColorBlendFactor: newColorBlendFactor, duration: 0.15)
            
            // Run the two actions at the same time.
            run(SKAction.group([scaleAction, colorBlendAction]))
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
                run(SKAction.scale(to: 1.08, duration: 0.20))
                
                focusRing.alpha = 0.0
                focusRing.isHidden = false
                focusRing.run(SKAction.fadeIn(withDuration: 0.2))
            }
            else {
                run(SKAction.scale(to: 1.0, duration: 0.20))
                
                focusRing.isHidden = true
            }
        }
    }
}

extension ButtonNode {
    #if os(iOS) || os(tvOS)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        isHighlighted = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        isHighlighted = false
        if containsTouches(touches) {
            let delay = DispatchTime.now() + Double(Int64(self.delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) { [unowned self] in
                self.action()
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        isHighlighted = false
    }
    
    fileprivate func containsTouches(_ touches: Set<UITouch>) -> Bool {
        guard let scene = scene else { fatalError("Button must be used within a scene.") }
        
        return touches.contains { touch in
            let touchPoint = touch.location(in: scene)
            let touchedNode = scene.atPoint(touchPoint)
            return touchedNode === self || touchedNode.inParentHierarchy(self)
        }
    }
    
    #elseif os(OSX)
    
    override func mouseDown(with event: NSEvent) {
        isHighlighted = true
    }
    
    override func mouseUp(with event: NSEvent) {
        isHighlighted = false
        if containsLocationForEvent(event: event) {
            let delay = DispatchTime.now() + Double(Int64(self.delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay, execute: { [unowned self] in
                self.action()
            })
        }
    }
    
    private func containsLocationForEvent(event: NSEvent) -> Bool {
        guard let scene = scene else { fatalError("Button must be used within a scene.")  }
    
        let location = event.location(in: scene)
        let clickedNode = scene.atPoint(location)
        return clickedNode === self || clickedNode.inParentHierarchy(self)
    }
    
    #endif
}
