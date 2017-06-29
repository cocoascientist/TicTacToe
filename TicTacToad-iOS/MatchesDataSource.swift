//
//  MatchesDataSource.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 9/27/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import UIKit
import GameKit

typealias LoadedMatchesCompletion = ([GKTurnBasedMatch]?, Error?) -> Void

class MatchesDataSource: NSObject {
    private(set) var matches: [AnyObject] = []
    
    func loadMatches(completion: @escaping LoadedMatchesCompletion) -> Void {
        GKTurnBasedMatch.loadMatches { (matches, error) in
            completion(matches, error)
        }
    }
}
