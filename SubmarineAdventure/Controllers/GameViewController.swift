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
    @IBOutlet var gameOverLabel: UILabel!
    @IBOutlet var reloadButton: UIButton!
    
    
    //MARK: - let/var
    private var submarineImageView = UIImageView()
    private var submarineSafeAreaView = UIView()
    private var sharkImageView = UIImageView()
    private var shipImageView = UIImageView()
    private var oxygenViewFull = UIView()
    private var oxygenViewEmpty = UIView()
    private var movingGroundImageViewCollection = [UIImageView(), UIImageView()]
    private var oxygenTimer = Timer()
    private var sharkTimer = Timer()
    private var shipTimer = Timer()
    private var groundTimer = Timer()
    private var isLive = true
    private var buttonTimer = Timer()
    private var ship = Ship()
    private var shark = Shark()
    private var submarine = Submarine()
    
    var user = User(userName: "User")
    //MARK: - lifecycle funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInterface()
        startShipTimer()
        startSharkTimer()
        startOxygenViewTimer()
        startGroundTimer()
    }
    //MARK: - IBActions
    @IBAction func goToMainPressed(_ sender: UIButton) {
        stopGame()
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
    @IBAction func reloadTapped(_ sender: UIButton) {
        sharkImageView.frame = CGRect(x: view.frame.width - 150, y: seaImageView.frame.midY-ship.height/2, width: shark.width, height: shark.height)
        submarineImageView.frame = CGRect(x: seaImageView.frame.minX+submarine.width/2, y: seaImageView.center.y - submarine.height/1.5, width: submarine.width, height: submarine.height)
        submarineSafeAreaView.frame = CGRect(x: seaImageView.frame.minX+submarine.width/1.4, y: seaImageView.center.y - submarine.height/3.5, width: submarine.width-submarine.width/2.5, height: submarine.height-submarine.height/1.7)
        shipImageView.frame = CGRect(x: self.view.frame.width + 1, y: seaImageView.frame.minY-ship.height/1.3, width: ship.width, height: ship.height)
        oxygenViewFull.frame = CGRect(x: submarineImageView.frame.minX, y: submarineImageView.frame.minY - submarine.height/4, width: submarineImageView.frame.width, height: submarine.height/7)
        self.oxygenViewFull.frame.size.width = self.submarineImageView.frame.width
        sender.isHidden = true
        sender.alpha = 0
        gameOverLabel.alpha = 0
        self.isLive = true
        startSharkTimer()
        startShipTimer()
        startOxygenViewTimer()
        startGroundTimer()
    }
    
    //MARK: - flow  funcs
    
    @objc func moveSubmarineDown() {
        if isInRightPositionDown() && isLive {
            submarineImageView.frame.origin.y += 1
            submarineSafeAreaView.frame.origin.y += 1
            oxygenViewEmpty.frame.origin.y += 1
            oxygenViewFull.frame.origin.y += 1
        }
    }
    @objc func moveSubmarineUp() {
        if isInRightPositionUp() && isLive {
            if isInAir() {
                print ("In the air")
                UIView.animate(withDuration: 0.5) {
                    self.oxygenViewFull.frame.size.width = self.submarineImageView.frame.width
                } completion: { _ in
                    self.oxygenViewFull.frame.size.width = self.submarineImageView.frame.width
                }
            }
            submarineImageView.frame.origin.y -= 1
            submarineSafeAreaView.frame.origin.y -= 1
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
        gameOverLabel.layer.zPosition = 1
        gameOverLabel.rounded()
        setMovingGroundImageView()
    }
    func setShark() {
        sharkImageView.clipsToBounds = true
        sharkImageView.contentMode = .scaleAspectFit
        sharkImageView.frame = CGRect(x: view.frame.width - 150, y: seaImageView.frame.midY-ship.height/2, width: shark.width, height: shark.height)
        sharkImageView.image = UIImage(named: shark.imageName)
        
        view.addSubview(sharkImageView)
    }
    
    func setSubmarine() {
        submarineImageView.frame = CGRect(x: seaImageView.frame.minX+submarine.width/2, y: seaImageView.center.y - submarine.height/1.5, width: submarine.width, height: submarine.height)
        submarineSafeAreaView.frame = CGRect(x: seaImageView.frame.minX+submarine.width/1.4, y: seaImageView.center.y - submarine.height/3.5, width: submarine.width-submarine.width/2.5, height: submarine.height-submarine.height/1.7)
        submarineSafeAreaView.backgroundColor = .green
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
        //view.addSubview(submarineSafeAreaView)
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
//        oxygenViewEmpty.frame = CGRect(x: submarineImageView.frame.minX, y: submarineImageView.frame.minY - submarine.height/4, width: submarineImageView.frame.width, height: submarine.height/7)
//        oxygenViewEmpty.roundedLess()
//        oxygenViewEmpty.backgroundColor = .white
        oxygenViewFull.backgroundColor = .green
//        view.addSubview(oxygenViewEmpty)
        view.addSubview(oxygenViewFull)
    }
    func setMovingGroundImageView() {
        for view in movingGroundImageViewCollection{
            view.frame = CGRect(x: groundImageView.frame.origin.x, y: groundImageView.frame.origin.y, width: groundImageView.frame.width, height: groundImageView.frame.height)
            view.image = UIImage(named: "Ground")
            view.clipsToBounds = true
            view.contentMode = .scaleToFill
            self.view.addSubview(view)
        }
        movingGroundImageViewCollection[1].frame.origin.x = self.view.frame.width
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
            stopGame()
        }
    }
    func isInAir()->Bool {
        if submarineImageView.frame.minY < seaImageView.frame.minY {
            return true
        }
        return false
    }
    func moveShip() {
        if self.submarineSafeAreaView.frame.intersects(self.shipImageView.frame) {
            print("Submarine damaged!")
            stopGame()
            return
        }
        self.shipImageView.frame.origin.x -= 1
        
        if self.shipImageView.frame.maxX < 0 {
            self.shipImageView.frame.origin.x = self.view.bounds.width + 1
        }
    }
    
    func moveShark() {
        if self.submarineSafeAreaView.frame.intersects(self.sharkImageView.frame) {
            print("Submarine damaged!")
            stopGame()
            return
        }
        self.sharkImageView.frame.origin.x -= 1
        
        if self.sharkImageView.frame.maxX < 0 {
            self.sharkImageView.frame.origin.x = self.view.bounds.width + 1
        }
    }
    
    func moveGround() {
        for view in movingGroundImageViewCollection {
            if view.frame.maxX == 0 {
                view.frame.origin.x = self.view.frame.width
            }
            view.frame.origin.x -= 1
        }
    }
    
    func startGroundTimer() {
        groundTimer = Timer.scheduledTimer(withTimeInterval: 0.020/Double(user.speed), repeats: true, block: { _ in
            self.moveGround()
        })
        groundTimer.fire()
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
    func stopGame() {
        self.sharkTimer.invalidate()
        self.shipTimer.invalidate()
        self.oxygenTimer.invalidate()
        self.groundTimer.invalidate()
        self.isLive = false
        self.reloadButton.isHidden = false
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
            self.gameOverLabel.alpha = 1
            self.reloadButton.alpha = 1
        }
    }
}
