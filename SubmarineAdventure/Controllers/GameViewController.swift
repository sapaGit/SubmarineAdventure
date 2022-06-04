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
    private var oxygenViewFull = UIView()
    private var oxygenViewEmpty = UIView()
    private var oxygenTimer = Timer()
    private var sharkTimer = Timer()
    private var shipTimer = Timer()
    private var isLive = true
    private var buttonTimer = Timer()
    private var ship = Ship()
    private var shark = Shark()
    private var submarine = Submarine()
    private let oxygenTimeConst = 10
    private var oxygenTimeVar = 10
    
    var user = User(userName: "User")
    //MARK: - lifecycle funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInterface()
        startShipTimer()
        startSharkTimer()
        startOxygenViewTimer()
    }
    //MARK: - IBActions
    @IBAction func goToMainPressed(_ sender: UIButton) {
        sharkTimer.invalidate()
        shipTimer.invalidate()
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
        if isInRightPositionDown() {
            if !isInAir() && submarineImageView.frame.minY == seaImageView.frame.minY {
                startOxygenViewTimer()
            }
            submarineImageView.frame.origin.y += 1
            oxygenViewEmpty.frame.origin.y += 1
            oxygenViewFull.frame.origin.y += 1
        }
    }
    @objc func moveSubmarineUp() {
        if isInRightPositionUp(){
            if isInAir() {
                print ("In the air")
                oxygenViewFull.frame.size.width = submarineImageView.frame.width
            }
            submarineImageView.frame.origin.y -= 1
            oxygenViewEmpty.frame.origin.y -= 1
            oxygenViewFull.frame.origin.y -= 1
        }
    }
    func isInRightPositionUp() -> Bool {
        if submarineImageView.frame.minY < seaImageView.frame.minY-submarine.height/4 {
            return false
        }
        return true
    }
    func isInRightPositionDown() -> Bool {
        if submarineImageView.frame.maxY > seaImageView.frame.maxY {
            return false
        }
        return true
    }
    
    func setInterface() {
        seaImageView.clipsToBounds = true
        setShark()
        setShip()
        setSubmarine()
        setOxygenView()
    }
    func setShark() {
        sharkImageView.contentMode = .scaleToFill
        sharkImageView.clipsToBounds = true
        sharkImageView.frame = CGRect(x: view.frame.width - 150, y: seaImageView.frame.midY-ship.height/2, width: shark.width, height: shark.height)
        sharkImageView.image = UIImage(named: shark.imageName)
        
        view.addSubview(sharkImageView)
    }
    func setSubmarine() {
        submarineImageView.frame = CGRect(x: seaImageView.frame.minX+submarine.width/2, y: seaImageView.center.y - submarine.height/1.5, width: submarine.width, height: submarine.height)
        if let user = UserDefaults.standard.value(User.self, forKey: "currentUser") {
            self.user = user
        } else { let user = User(userName: "User")
            self.user = user
        }
        submarineImageView.image = UIImage(named: user.submarineColor)
        submarineImageView.contentMode = .scaleToFill
        submarineImageView.clipsToBounds = true
        nameUser.text = user.userName
        view.addSubview(submarineImageView)
    }
    func setShip() {
        shipImageView.frame = CGRect(x: self.view.frame.width + 1, y: seaImageView.frame.minY-ship.height/1.3, width: ship.width, height: ship.height)
        shipImageView.image = UIImage(named: ship.imageName)
        shipImageView.clipsToBounds = true
        shipImageView.contentMode = .scaleToFill
        view.addSubview(shipImageView)
    }
    
    func setOxygenView() {
        oxygenViewFull.frame = CGRect(x: submarineImageView.frame.minX, y: submarineImageView.frame.minY - submarine.height/4, width: submarineImageView.frame.width, height: submarine.height/7)
        oxygenViewFull.roundedLess()
        oxygenViewEmpty.frame = CGRect(x: submarineImageView.frame.minX, y: submarineImageView.frame.minY - submarine.height/4, width: submarineImageView.frame.width, height: submarine.height/7)
        oxygenViewEmpty.roundedLess()
        oxygenViewEmpty.backgroundColor = .white
        oxygenViewFull.backgroundColor = .green
//        view.addSubview(oxygenViewEmpty)
        view.addSubview(oxygenViewFull)
    }
    func startOxygenViewTimer(){
        oxygenTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            self.changeOxygenView()
        })
            oxygenTimer.fire()
        
    }
    func changeOxygenView() {
        oxygenViewFull.frame.size.width -= 0.5
        if oxygenViewFull.frame.size.width == 0 {
            print("Oxygen is Empty!")
            oxygenTimer.invalidate()
        }
    }
    func isInAir()->Bool {
        if submarineImageView.frame.minY < seaImageView.frame.minY {
            return true
        }
        return false
    }
    func moveShip() {
        if self.submarineImageView.frame.intersects(self.shipImageView.frame) {
            print("Submarine damaged!")
            self.sharkTimer.invalidate()
            self.shipTimer.invalidate()
            return
        }
        self.shipImageView.frame.origin.x -= 1
        
        if self.shipImageView.frame.maxX < 0 {
            self.shipImageView.frame.origin.x = self.view.bounds.width + 1
        }
    }
    
    func moveShark() {
        if self.submarineImageView.frame.intersects(self.sharkImageView.frame) {
            print("Submarine damaged!")
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
        shipTimer = Timer.scheduledTimer(withTimeInterval: 0.015/Double(user.speed), repeats: true, block: { _ in
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
