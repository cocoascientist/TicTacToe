//
//  ButtonIdentifier.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 6/28/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation

/// The complete set of button identifiers supported in the app.
enum ButtonIdentifier: String {
    case OnePlayer
    case TwoPlayer
    case Scores
    case Settings
    
    case LogIntoGamplay
    
    case OK
    case Cancel
    
    /// Convenience array of all available button identifiers.
    static let menuButtonIdentifiers: [ButtonIdentifier] = [
        .OnePlayer, .TwoPlayer, .Scores, .Settings
    ]
    
    /// The name of the texture to use for a button when the button is selected.
    var selectedTextureName: String? {
        switch self {
        default:
            return nil
        }
    }
}