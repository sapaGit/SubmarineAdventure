//
//  RecordsViewController.swift
//  SubmarineAdventure
//
//  Created by Sergey Pavlov on 02.06.2022.
//

import UIKit

class RecordsViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    
    private var currentUser = User(userName: "User")
    override func viewDidLoad() {
        super.viewDidLoad()
        setUser()
    }
    
    @IBAction func goToMainPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setUser() {
        if let user = UserDefaults.standard.value(User.self, forKey: "currentUser") {
            currentUser = user
        }
    }
    
    
}
extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.score.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomViewCell", for: indexPath) as? CustomViewCell else { return UITableViewCell() }
        cell.configue(with: "\(currentUser.score[indexPath.row])")
                return cell
    }
}
