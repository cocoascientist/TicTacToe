//
//  MenuTableViewCell.swift
//  TicTacToe
//
//  Created by Andrew Shepard on 1/12/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import QuartzCore

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet var roundView: RoundCellView!
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.clear
        self.roundView.backgroundColor = UIColor.clear
        
        self.titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 20)
        self.titleLabel.textColor = Style.Colors.text
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state 
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        let duration = 0.15
        let newScale: CGFloat = highlighted ? 0.99 : 1.0
        
        UIView.animate(withDuration: duration) { 
            self.roundView.transform = CGAffineTransform(scaleX: newScale, y: newScale)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = ""
    }
}
