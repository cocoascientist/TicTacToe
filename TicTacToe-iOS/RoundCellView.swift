//
//  RoundCellView.swift
//  TicTacToe
//
//  Created by Andrew Shepard on 1/12/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit

class RoundCellView: UIView {
    
    var selected: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var highlighted: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        Style.Colors.button.setFill()
        
        let height = rect.height
        let radius = (height.truncatingRemainder(dividingBy: 2) == 0) ? height : height - 1
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        path.addClip()
        path.fill()
    }

}
