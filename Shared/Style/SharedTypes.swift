//
//  SharedTypes.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

#if os(iOS) || os(tvOS)
    
typealias Font = UIFont
typealias Color = UIColor
    
#elseif os(OSX)
    
typealias Font = NSFont
typealias Color = NSColor

#endif
