//
//  MenuViewController.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 7/13/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import UIKit
import GameKit

class MenuViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    fileprivate let menuCellIdentifier = "MenuCellIdentifier"
    
    fileprivate var options: [String] = {
        return [
            NSLocalizedString("One Player", comment: "One Player"),
            NSLocalizedString("Two Player", comment: "Two Player"),
            NSLocalizedString("Settings", comment: "Settings")
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Main Menu", comment: "Main Menu")
        
        self.tableView.backgroundColor = Style.Colors.background
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: menuCellIdentifier)
        
        GameCenterController.shared.authenticateLocalUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: menuCellIdentifier) else { fatalError() }
        
        let title = self.options[indexPath.row]
        cell.textLabel?.text = title
        
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let identifier = String(describing: GameViewController.self)
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) as? GameViewController else {
            fatalError("missing \(identifier)")
        }
        
        if indexPath.row == 0 {
            // one player
            viewController.type = GameType.onePlayer
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if indexPath.row == 1 {
            // two player
//            viewController.type = GameType.twoPlayer
//            self.navigationController?.pushViewController(viewController, animated: true)
            
            let request = GKMatchRequest()
            request.minPlayers = 2
            request.maxPlayers = 2
            
            GKTurnBasedMatch.find(for: request, withCompletionHandler: { (match, error) in
                guard error == nil else {
                    return print("error: \(error)")
                }
                
                guard let match = match else {
                    return print("error, no match")
                }
                
                print("match found: \(match)")
            })
        }
    }
}

extension MenuViewController: GameCenterControllerDelegate {
    func matchEnded() {
        //
    }
    
    func matchStarted() {
        //
    }
    
    func match(_ match: GKMatch, didReceiveData: Data, fromPlayer: String) {
        print("data: \(didReceiveData)")
    }
}

extension MenuViewController: GKTurnBasedMatchmakerViewControllerDelegate {
    func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {
        print("error: \(error)")
        viewController.dismiss(animated: true, completion: nil)
    }
}
