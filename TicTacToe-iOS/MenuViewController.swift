//
//  MenuViewController.swift
//  TicTacToe
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

    fileprivate lazy var matchesViewController: MatchesViewController = {
        let identifier = String(describing: MatchesViewController.self)
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) as? MatchesViewController else {
            fatalError("missing \(identifier)")
        }

        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isHidden = true

        self.view.backgroundColor = Style.Colors.background

        self.tableView.bounces = false
        self.tableView.backgroundColor = .clear

        self.tableView.dataSource = self
        self.tableView.delegate = self

        let nib = UINib(nibName: "MenuTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: menuCellIdentifier)

        self.tableView.separatorStyle = .none

//        GameCenterController.shared.authenticateLocalUser()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: menuCellIdentifier) as? MenuTableViewCell else { fatalError() }

        let title = self.options[indexPath.row]
        cell.titleLabel.text = title

        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) { [unowned self] in

            let identifier = String(describing: GameViewController.self)
            guard let gameViewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) as? GameViewController else {
                fatalError("missing \(identifier)")
            }

            if indexPath.row == 0 {
                // one player
                gameViewController.type = GameType.onePlayer
                self.navigationController?.pushViewController(gameViewController, animated: true)
            }
            else if indexPath.row == 1 {
                // two player
                gameViewController.type = GameType.twoPlayer
                self.navigationController?.pushViewController(gameViewController, animated: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
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
