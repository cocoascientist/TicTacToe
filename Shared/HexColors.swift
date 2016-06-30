//
//  NSColor+HexColors.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation

extension Color {
    class func hexColor(string: String) -> Color {
        let set = NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet
        var colorString = string.stringByTrimmingCharactersInSet(set).uppercaseString
        
        if (colorString.hasPrefix("#")) {
            colorString = colorString.substringFromIndex(colorString.startIndex.advancedBy(1))
        }
        
        if (colorString.characters.count != 6) {
            return Color.grayColor()
        }
        
        var rgbValue: UInt32 = 0
        NSScanner(string: colorString).scanHexInt(&rgbValue)
        
        return Color(
            red:   CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue:  CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}