//
//  CustomViewCell.swift
//  SubmarineAdventure
//
//  Created by Sergey Pavlov on 15.06.2022.
//

import UIKit

class CustomViewCell: UITableViewCell {

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        usernameLabel.rounded()
        usernameLabel.dropShadow()
        scoreLabel.rounded()
        scoreLabel.dropShadow()
        // Initialization code
    }

    func configue(with nameUser: String, score: String) {
            usernameLabel.text = nameUser
            scoreLabel.text = score
        }
}
