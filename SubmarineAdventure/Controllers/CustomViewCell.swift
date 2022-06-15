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
        // Initialization code
    }

    func configue(with text: String) {
            scoreLabel.text = text
        }
}
