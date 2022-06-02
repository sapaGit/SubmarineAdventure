//
//  GameViewController.swift
//  SubmarineAdventure
//
//  Created by Sergey Pavlov on 02.06.2022.
//

import UIKit

class GameViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet var nameUser: UILabel!
    @IBOutlet var upButton: UIButton!
    @IBOutlet var downButton: UIButton!
    @IBOutlet var skyImageView: UIImageView!
    @IBOutlet var seaImageView: UIImageView!
    @IBOutlet var groundImageView: UIImageView!
    
    
    //MARK: - let/var
    private var submarineImageView = UIImageView()
    private var sharkImageView = UIImageView()
    private var shipImageView = UIImageView()
    private var oxygenView = UIView()
    private var oxygenTimer = Timer()
    private var sharkTimer = Timer()
    private var shipTimer = Timer()
    private var isLive = true
    private var buttonTimer = Timer()
    
    var user = User(userName: "User")
    //MARK: - lifecycle funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubmarine()
        setShark()
        setShip()
        startShipTimer()
        startSharkTimer()
        
    }
    //MARK: - IBActions
    @IBAction func goToMainPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func upButtonHold(sender: UIButton) {
        buttonTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(moveSubmarineUp), userInfo: nil, repeats: true)
    }
    @IBAction func upButtonCancelled(sender: UIButton){
        buttonTimer.invalidate()
    }
    
    @IBAction func downButtonHold(sender: UIButton) {
        buttonTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(moveSubmarineDown), userInfo: nil, repeats: true)
    }
    
    @IBAction func downButtonCancelled(sender: UIButton) {
        buttonTimer.invalidate()
    }
    
    //MARK: - flow  funcs
    
    @objc func moveSubmarineDown() {
        submarineImageView.frame.origin.y += 1
    }
    @objc func moveSubmarineUp() {
        submarineImageView.frame.origin.y -= 1
    }
    
    func setShark() {
        sharkImageView.frame = CGRect(x: view.frame.width - 150, y: seaImageView.center.y, width: 80, height: 60)
        sharkImageView.image = UIImage(named: "Fish")
        sharkImageView.clipsToBounds = true
        sharkImageView.contentMode = .scaleAspectFill
        view.addSubview(sharkImageView)
    }
    func setSubmarine() {
        submarineImageView.frame = CGRect(x: seaImageView.frame.minX+40, y: seaImageView.center.y, width: 80, height: 60)
        if let user = UserDefaults.standard.value(User.self, forKey: "currentUser") {
            self.user = user
        } else { let user = User(userName: "User")
            self.user = user
        }
        submarineImageView.image = UIImage(named: user.submarineColor)
        submarineImageView.contentMode = .scaleAspectFill
        submarineImageView.clipsToBounds = true
        nameUser.text = user.userName
        view.addSubview(submarineImageView)
    }
    func setShip() {
        shipImageView.frame = CGRect(x: self.view.frame.width + 1, y: seaImageView.frame.minY-45, width: 150, height: 90)
        shipImageView.image = UIImage(named: "Ship")
        shipImageView.contentMode = .scaleAspectFill
        
        view.addSubview(shipImageView)
    }
    func moveShip() {
        UIView.animate(withDuration: 14, delay: 0, options: .curveLinear, animations: {
            self.shipImageView.frame.origin.x -= self.view.bounds.width + 152
        }, completion: { _ in
            self.shipImageView.frame.origin.x = self.view.bounds.width + 1
        })
    }
    
    func moveShark() {
        if self.submarineImageView.frame.intersects(self.sharkImageView.frame) {
            print("Hi")
            self.sharkTimer.invalidate()
            self.shipTimer.invalidate()
            return
        }
        self.sharkImageView.frame.origin.x -= 1
        
        if self.sharkImageView.frame.maxX < 0 {
            self.sharkImageView.frame.origin.x = self.view.bounds.width + 1
        }
    }
    
    
    func startSharkTimer() {
        sharkTimer = Timer.scheduledTimer(withTimeInterval: 0.020/Double(user.speed), repeats: true, block: { _ in
            self.moveShark()
        })
        sharkTimer.fire()
    }
    func startShipTimer() {
        shipTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: { _ in
            self.moveShip()
        })
        shipTimer.fire()
    }
    
    func checkIntersection() {
        if submarineImageView.bounds.intersects(sharkImageView.bounds) {
            sharkTimer.invalidate()
        }
    }
}
