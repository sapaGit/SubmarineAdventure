//
//  MenuViewController.swift
//  SubmarineAdventure
//
//  Created by Sergey Pavlov on 02.06.2022.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var buttonsCollection: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
        setButtons()
    }

    @IBAction func startPressed(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    @IBAction func recordsPressed(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "RecordsViewController") as! RecordsViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func settingsPressed(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func setLabel() {
        
        titleLabel.dropShadow()
    }
    func setButtons() {
        for button in buttonsCollection {
            button.rounded()
            button.dropShadow()
        }
    }


}
