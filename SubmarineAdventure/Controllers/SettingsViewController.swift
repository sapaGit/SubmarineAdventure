//
//  SettingsViewController.swift
//  SubmarineAdventure
//
//  Created by Sergey Pavlov on 02.06.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    let currentUser = User(userName: "Hello")
    var imageNameArray = ["SubmarineGrey", "SubmarineGreen", "SubmarineBlue", "SubmarineRed"]
    var index = 0
    @IBOutlet var textField: UITextField!
    @IBOutlet var submarineView: UIImageView!
    @IBOutlet var speedButton: [UIButton]!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var submarineButtonsCollection: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        setInterface()
 
    }
    
    @IBAction func goToMainPressed(_ sender: UIButton) {
        if textField.text == "" {
            currentUser.userName = "User"
        } else if let name = textField.text {
            currentUser.userName = name
        }
        currentUser.submarineColor = imageNameArray[index]
        UserDefaults.standard.set(encodable: currentUser, forKey: "currentUser")
        self.navigationController?.popToRootViewController(animated: true)
    
    }
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        self.changeImageLeft()
    }
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        self.changeImageRight()
    }
    @IBAction func speedButtonPressed(_ sender: UIButton) {
        for button in speedButton {
            button.backgroundColor = .systemYellow
        }
        if sender.tag == 0 {
            currentUser.speed = 1
        } else if sender.tag == 1 {
            currentUser.speed = 2
        } else {
            currentUser.speed = 4
        }
        speedButton[sender.tag].backgroundColor = .yellow
        print(currentUser.speed)
    }
    
   private func changeImageLeft() {
        if index == 0 {
                index = imageNameArray.count-1
            } else { index -= 1
        }
        submarineView.image = UIImage(named: imageNameArray[index])
    }
    private func changeImageRight() {
        if index > imageNameArray.count-2 {
            index = 0
        } else { index += 1
        }
        submarineView.image = UIImage(named: imageNameArray[index])
    }
    
    private func setInterface() {
        for button in speedButton {
            button.rounded()
            button.dropShadow()
        }
        textField.dropShadow()
    }
    

}
