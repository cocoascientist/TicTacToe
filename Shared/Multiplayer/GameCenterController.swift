//
//  GameCenterController.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 7/11/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

// GCHelper.swift (v. 0.3.2)
//
// Copyright (c) 2016 Jack Cook
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import GameKit


public protocol GameCenterControllerDelegate: class {
    
    /// Method called when a match has been initiated.
    func matchStarted()
    
    /// Method called when the device received data about the match from another device in the match.
    func match(_ match: GKMatch, didReceiveData: Data, fromPlayer: String)
    
    /// Method called when the match has ended.
    func matchEnded()
}

open class GameCenterController: NSObject {
    
    open static let shared = GameCenterController()
    
    /// The match object provided by GameKit.
    fileprivate(set) var match: GKMatch!
    
    fileprivate weak var delegate: GameCenterControllerDelegate?
    fileprivate var invite: GKInvite!
    fileprivate var invitedPlayer: GKPlayer!
    fileprivate var playersDict = [String: AnyObject]()
    fileprivate weak var presentingViewController: UIViewController!
    
    fileprivate var authenticated = false
    fileprivate var matchStarted = false
    
    override init() {
        super.init()
        
        let name = Notification.Name(rawValue: "GKPlayerAuthenticationDidChangeNotificationName")
        let selector = #selector(GameCenterController.authenticationChanged(sender:))
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    /**
     Authenticates the user with their Game Center account if possible
     
     */
    public func authenticateLocalUser() {
        print("Authenticating local user...")
        if GKLocalPlayer.localPlayer().isAuthenticated == false {
            GKLocalPlayer.localPlayer().authenticateHandler = { (view, error) in
                guard error == nil else {
                    print("Authentication error: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                self.authenticated = true
            }
        } else {
            print("Already authenticated")
        }
    }
    
    /**
     Attempts to pair up the user with other users who are also looking for a match.
     
     :param: minPlayers The minimum number of players required to create a match.
     :param: maxPlayers The maximum number of players allowed to create a match.
     :param: viewController The view controller to present required GameKit view controllers from.
     :param: delegate The delegate receiving data from GCHelper.
     */
    public func findMatchWithMinPlayers(minPlayers: Int, maxPlayers: Int, viewController: UIViewController, delegate: GameCenterControllerDelegate) {
        self.matchStarted = false
        self.match = nil
        self.presentingViewController = viewController
        self.delegate = delegate
        presentingViewController.dismiss(animated: false, completion: nil)
        
        let request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        
        let mmvc = GKTurnBasedMatchmakerViewController(matchRequest: request)
//        mmvc.turnBasedMatchmakerDelegate = self
        
        presentingViewController.present(mmvc, animated: true, completion: nil)
    }
    
    /**
     Presents the game center view controller provided by GameKit.
     
     :param: viewController The view controller to present GameKit's view controller from.
     :param: viewState The state in which to present the new view controller.
     */
    public func showGameCenter(viewController: UIViewController, viewState: GKGameCenterViewControllerState) {
        presentingViewController = viewController
        
        let gcvc = GKGameCenterViewController()
        gcvc.viewState = viewState
        gcvc.gameCenterDelegate = self
        presentingViewController.present(gcvc, animated: true, completion: nil)
    }
}

extension GameCenterController {
    @objc internal func authenticationChanged(sender: NSNotification) {
        if GKLocalPlayer.localPlayer().isAuthenticated && !authenticated {
            print("Authentication changed: player authenticated")
            authenticated = true
        } else {
            print("Authentication changed: player not authenticated")
            authenticated = false
        }
    }
    
    fileprivate func lookupPlayers() {
        let playerIDs = match.players.map { $0.playerID } as! [String]
        
        GKPlayer.loadPlayers(forIdentifiers: playerIDs) { (players, error) -> Void in
            guard error == nil else {
                print("Error retrieving player info: \(String(describing: error?.localizedDescription))")
                self.matchStarted = false
                self.delegate?.matchEnded()
                return
            }
            
            guard let players = players else {
                print("Error retrieving players; returned nil")
                return
            }
            
            for player in players {
                print("Found player: \(String(describing: player.alias))")
                self.playersDict[player.playerID!] = player
            }
            
            self.matchStarted = true
            GKMatchmaker.shared().finishMatchmaking(for: self.match)
            self.delegate?.matchStarted()
        }
    }
}

extension GameCenterController: GKGameCenterControllerDelegate {
    public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}

extension GameCenterController: GKMatchmakerViewControllerDelegate {
    public func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    public func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        presentingViewController.dismiss(animated: true, completion: nil)
        print("Error finding match: \(error.localizedDescription)")
    }
    
    public func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        presentingViewController.dismiss(animated: true, completion: nil)
        self.match = match
        
        match.delegate = self
        if !matchStarted && match.expectedPlayerCount == 0 {
            print("Ready to start match!")
            self.lookupPlayers()
        }
    }
}

extension GameCenterController: GKMatchDelegate {
    public func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        if self.match != match { return }
        guard let playerID = player.playerID else { return }
        
        delegate?.match(match, didReceiveData: data, fromPlayer: playerID)
    }
    
    public func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        if self.match != match { return }
        
        switch state {
        case .stateConnected where !matchStarted && match.expectedPlayerCount == 0:
            lookupPlayers()
        case .stateDisconnected:
            matchStarted = false
            delegate?.matchEnded()
            self.match = nil
        default:
            break
        }
    }
    
    public func match(_ match: GKMatch, didFailWithError error: Error?) {
        if self.match != match { return }
        
        print("Match failed with error: \(String(describing: error?.localizedDescription))")
        self.matchStarted = false
        delegate?.matchEnded()
    }
}

extension GameCenterController: GKLocalPlayerListener {
    public func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        let mmvc = GKMatchmakerViewController(invite: invite)!
        mmvc.matchmakerDelegate = self
        presentingViewController.present(mmvc, animated: true, completion: nil)
    }
}
