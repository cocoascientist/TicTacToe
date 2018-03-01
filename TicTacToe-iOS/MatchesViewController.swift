//
//  MatchesViewController.swift
//  TicTacToe
//
//  Created by Andrew Shepard on 9/27/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import UIKit
import GameKit

class MatchesViewController: UIViewController {

    let dataSource = MatchesDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.loadMatches { (matches, error) in
            //
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
