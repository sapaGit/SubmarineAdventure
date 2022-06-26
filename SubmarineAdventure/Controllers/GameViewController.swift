//
//  GameViewController.swift
//  SubmarineAdventure
//
//  Created by Sergey Pavlov on 02.06.2022.
//

import UIKit

class GameViewController: UIViewController {

    //comment
    //MARK: - IBOutlets
    @IBOutlet var nameUser: UILabel!
    @IBOutlet var upButton: UIButton!
    @IBOutlet var downButton: UIButton!
    @IBOutlet var goToMain: UIButton!
    @IBOutlet var skyImageView: UIImageView!
    @IBOutlet var seaImageView: UIImageView!
    @IBOutlet var gameOverLabel: UILabel!
    @IBOutlet var reloadButton: UIButton!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var fireButton: UIButton!
    @IBOutlet var gameOverScoreLabel: UILabel!
    
    
    //MARK: - let/var
    private var currentUser = User(userName: "User")
    
    private var submarineImageView = UIImageView()
    private var submarineSafeAreaView = UIView()
    private var sharkImageViewCollection = [UIImageView(), UIImageView()]
    private var shipImageView = UIImageView()
    private var boomImageView = UIImageView()
    private var missleImageView = UIImageView()
    private var oxygenViewFull = UIView()
    private var oxygenViewEmpty = UIView()
    private var movingGroundImageViewCollection = [UIImageView(), UIImageView()]
    private var groundSafeArea = UIView()
    private var plantImageView = UIImageView()
    private var bonusLabel = UILabel()
    private var sprayImageViewCollection = [UIImageView(), UIImageView()]
    private var movingSkyViewCollection = [UIImageView(), UIImageView()]
    private var oxygenTimer = Timer()
    private var sharkTimer = Timer()
    private var shipTimer = Timer()
    private var bubbleTimer = Timer()
    private var groundTimer = Timer()
    private var crabTimer = Timer()
    private var skyTimer = Timer()
    private var plantTimer = Timer()
    private var sprayTimer = Timer()
    private var isLive = true
    private var buttonTimer = Timer()
    private var missleTimer = Timer()
    private var scoreTimer = Timer()
    private var seaBubbleTimer = Timer()
    private var gameSpeedTimer = Timer()
    private var graviTimer = Timer()
    private var speedMultiplier = 1.0
    private var ship = Ship()
    private var shark = Shark()
    private var submarine = Submarine()
    private var missle = Missle()
    private var currentScore = 0
    
    

    //MARK: - lifecycle funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInterface()
        startShipTimer()
        startSharkTimer()
        startOxygenViewTimer()
        startGroundTimer()
        startScoreTimer()
        startSprayTimer()
        startSkyTimer()
        startPlantTimer()
        startSeaBubbleTimer()
        startGameSpeedTimer()
        startCrabTimer()
        startGraviTimer()
    }
    //MARK: - IBActions
    
    @IBAction func goToMainPressed(_ sender: UIButton) {
        stopGame()
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func rightButtonHold(_ sender: UIButton) {
        buttonTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(moveSubmarineRight), userInfo: nil, repeats: true)
    }
    @IBAction func rightButtonCanceled(_ sender: UIButton) {
        buttonTimer.invalidate()
    }
    @IBAction func leftButtonHold(_ sender: UIButton) {
        buttonTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(moveSubmarineLeft), userInfo: nil, repeats: true)
    }
    @IBAction func leftButtonCanceled(_ sender: UIButton) {
        buttonTimer.invalidate()
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
    @IBAction func fireButtonTapped(_ sender: UIButton) {
        //checking is missle in fly
        if isAlreadyFired() {
            return
        }
        view.addSubview(missleImageView)
        startMissleTimer()
    }
    @IBAction func reloadTapped(_ sender: UIButton) {
        sharkImageViewCollection[0].frame = CGRect(x: view.frame.width - 150, y: randomY(), width: shark.width, height: shark.height)
        sharkImageViewCollection[1].frame = CGRect(x: view.frame.width*1.5, y: randomY(), width: shark.width, height: shark.height)
        submarineImageView.frame = CGRect(x: seaImageView.frame.minX+submarine.width/2, y: seaImageView.center.y - submarine.height/1.5, width: submarine.width, height: submarine.height)
        submarineSafeAreaView.frame = CGRect(x: seaImageView.frame.minX+submarine.width/1.4, y: seaImageView.center.y - submarine.height/3.5, width: submarine.width-submarine.width/2.5, height: submarine.height-submarine.height/1.7)
        shipImageView.frame = CGRect(x: self.view.frame.width + 1, y: seaImageView.frame.minY-ship.height/1.3, width: ship.width, height: ship.height)
        oxygenViewFull.frame = CGRect(x: submarineImageView.frame.minX, y: submarineImageView.frame.minY - submarine.height/4, width: submarineImageView.frame.width, height: submarine.height/7)
        self.oxygenViewFull.frame.size.width = self.submarineImageView.frame.width
        missleImageView.frame = CGRect(x: submarineImageView.frame.maxX, y: submarineImageView.frame.midY, width: submarine.width/2, height: submarine.height/5)
        movingGroundImageViewCollection[0].frame.origin.x = self.view.frame.origin.x
        movingGroundImageViewCollection[1].frame.origin.x = self.view.frame.width
        plantImageView.frame.origin.x = 1.2 * self.view.frame.width
        sender.isEnabled = false
        fireButton.isHidden = false
        sender.alpha = 0
        gameOverLabel.alpha = 0
        gameOverScoreLabel.alpha = 0
        scoreLabel.alpha = 1
        oxygenViewFull.alpha = 1
        speedMultiplier = 1
        self.isLive = true
        startSharkTimer()
        startShipTimer()
        startOxygenViewTimer()
        startGroundTimer()
        startScoreTimer()
        startBubbleTimer()
        startGraviTimer()
        startSeaBubbleTimer()
        startCrabTimer()
        startSprayTimer()
        startSkyTimer()
        startPlantTimer()
        startGameSpeedTimer()
    }
    
    //MARK: - flow  funcs
    //not installed
    @objc func moveSubmarineDown() {
        if isInRightPositionDown() && isLive {
            submarineImageView.frame.origin.y += 1
            submarineSafeAreaView.frame.origin.y += 1
            oxygenViewEmpty.frame.origin.y += 1
            oxygenViewFull.frame.origin.y += 1
            if !isAlreadyFired() { missleImageView.frame.origin.y += 1 }
        }
    }
    //not installed
    @objc func moveSubmarineRight() {
        if isInRightPositionRight() && isLive {
            submarineImageView.frame.origin.x += 1
            submarineSafeAreaView.frame.origin.x += 1
            oxygenViewEmpty.frame.origin.x += 1
            oxygenViewFull.frame.origin.x += 1
            if !isAlreadyFired() { missleImageView.frame.origin.x += 1 }
        }
    }
    //not installed
    @objc func moveSubmarineLeft() {
        if isInRightPositionLeft() && isLive {
            submarineImageView.frame.origin.x -= 1
            submarineSafeAreaView.frame.origin.x -= 1
            oxygenViewEmpty.frame.origin.x -= 1
            oxygenViewFull.frame.origin.x -= 1
            if !isAlreadyFired() { missleImageView.frame.origin.x -= 1 }
        }
    }
    @objc func moveSubmarineUp() {
        if isInRightPositionUp() && isLive {
            if isInAir() {
                UIView.animate(withDuration: 0.5) {
                    self.oxygenViewFull.frame.size.width = self.submarineImageView.frame.width
                } completion: { _ in
                    self.oxygenViewFull.frame.size.width = self.submarineImageView.frame.width
                }
            }
            UIView.animate(withDuration: 0.3) {
                self.submarineImageView.frame.origin.y -= 2
                self.submarineSafeAreaView.frame.origin.y -= 2
                self.oxygenViewEmpty.frame.origin.y -= 2
                self.oxygenViewFull.frame.origin.y -= 2
                if !self.isAlreadyFired() { self.missleImageView.frame.origin.y -= 2 }
            }
        }
    }
    func isInRightPositionUp() -> Bool {
        if submarineImageView.frame.minY < seaImageView.frame.minY-submarine.height/4 {
            return false
        }
        return true
    }
    func isInRightPositionDown() -> Bool {
        if submarineImageView.frame.maxY > seaImageView.frame.maxY + submarine.height/4 {
            return false
        }
        return true
    }
    func isInRightPositionLeft() -> Bool {
        if submarineImageView.frame.minX < seaImageView.frame.minX + submarine.width/4 {
            return false
        }
        return true
    }
    
    func isInRightPositionRight() -> Bool {
        if submarineImageView.frame.minX > seaImageView.frame.maxX - 3 * submarine.width {
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
        gameOverScoreLabel.layer.zPosition = 1
        reloadButton.layer.zPosition = 1
        goToMain.layer.zPosition = 2
        gameOverLabel.rounded()
        gameOverScoreLabel.rounded()
        reloadButton.rounded()
        setMovingGroundImageView()
        setMovingSkyImageView()
        setMissle()
        setBoom()
        setPlant()
        startBubbleTimer()
        setSprayImageView()
        setBonusLabel()
        fireButton.layer.zPosition = 1
    }
    func setShark() {
        for sharkImageView in sharkImageViewCollection{
            sharkImageView.clipsToBounds = true
            sharkImageView.contentMode = .scaleAspectFit
            sharkImageView.frame = CGRect(x: view.frame.width - 150, y: randomY(), width: shark.width, height: shark.height)
            shipImageView.layer.zPosition = 1
            sharkImageView.image = UIImage(named: shark.imageName.randomElement() ?? "Fish")
            
            view.addSubview(sharkImageView)
        }
        sharkImageViewCollection[1].frame.origin.x = view.frame.width*1.5
    }
    
    func setSubmarine() {
        submarineImageView.frame = CGRect(x: seaImageView.frame.minX+submarine.width/2, y: seaImageView.center.y - submarine.height/1.5, width: submarine.width, height: submarine.height)
        submarineSafeAreaView.frame = CGRect(x: seaImageView.frame.minX+submarine.width/1.4, y: seaImageView.center.y - submarine.height/3.5, width: submarine.width-submarine.width/2.5, height: submarine.height-submarine.height/1.7)
        submarineSafeAreaView.backgroundColor = .green
        if let user = UserDefaults.standard.value(User.self, forKey: "currentUser") {
            self.currentUser = user
        } else { let user = User(userName: "User")
            self.currentUser = user
        }
        submarineImageView.image = UIImage(named: currentUser.submarineColor)
        submarineImageView.contentMode = .scaleToFill
        submarineImageView.clipsToBounds = true
        submarineImageView.layer.zPosition = 1
        nameUser.text = currentUser.userName
        view.addSubview(submarineImageView)
        //view.addSubview(submarineSafeAreaView)
    }
    func addCrab() {
            let crabImageView = UIImageView()
        crabImageView.frame = CGRect(x: randomXSeaBubble()+view.frame.width, y: movingGroundImageViewCollection[0].frame.minY-submarine.height*0.8, width: self.view.frame.width/20, height: sharkImageViewCollection[0].frame.height)
            crabImageView.image = UIImage(named: "Crab")
            view.addSubview(crabImageView)
        UIView.animate(withDuration: 7, delay: 0, options: .curveLinear) {
            crabImageView.frame.origin.x = -crabImageView.frame.width
        } completion: { _ in
            crabImageView.removeFromSuperview()
        }

    }
    func setShip() {
        shipImageView.frame = CGRect(x: self.view.frame.width + 1, y: seaImageView.frame.minY-ship.height/1.3, width: ship.width, height: ship.height)
        shipImageView.image = UIImage(named: ship.imageName)
        shipImageView.clipsToBounds = true
        shipImageView.layer.zPosition = 1
        shipImageView.contentMode = .scaleToFill
        view.addSubview(shipImageView)
    }
    func setPlant() {
        plantImageView.frame = CGRect(x: self.view.frame.width*1.2, y: groundSafeArea.frame.minY - sharkImageViewCollection[0].frame.height*0.8, width: self.view.frame.width/18, height: sharkImageViewCollection[0].frame.height)
        plantImageView.image = UIImage(named: "Plant")
        plantImageView.contentMode = .scaleToFill
        plantImageView.clipsToBounds = true
        plantImageView.layer.zPosition = 1
        view.addSubview(plantImageView)
    }
    
    func setBoom() {
        boomImageView.frame = CGRect(x: sharkImageViewCollection[0].frame.origin.x, y: sharkImageViewCollection[0].frame.origin.y, width: sharkImageViewCollection[0].frame.width, height: sharkImageViewCollection[0].frame.height)
        boomImageView.image = UIImage(named: "Boom")
        boomImageView.contentMode = .scaleToFill
        boomImageView.clipsToBounds = true
        boomImageView.layer.zPosition = 1
        boomImageView.alpha = 0
        view.addSubview(boomImageView)
        
    }
    func setOxygenView() {
        oxygenViewFull.frame = CGRect(x: submarineImageView.frame.minX, y: submarineImageView.frame.minY - submarine.height/4, width: submarineImageView.frame.width, height: submarine.height/7)
        oxygenViewFull.roundedLess()
//        oxygenViewEmpty.frame = CGRect(x: submarineImageView.frame.minX, y: submarineImageView.frame.minY - submarine.height/4, width: submarineImageView.frame.width, height: submarine.height/7)
//        oxygenViewEmpty.roundedLess()
//        oxygenViewEmpty.backgroundColor = .white
        oxygenViewFull.backgroundColor = .green
        oxygenViewFull.layer.zPosition = 1
//        view.addSubview(oxygenViewEmpty)
        view.addSubview(oxygenViewFull)
    }
    
    func setBubble() -> UIImageView {
            let bubbleView = UIImageView()
        bubbleView.frame = CGRect(x: submarineImageView.frame.origin.x+submarineImageView.frame.width*0.7, y: submarineImageView.frame.origin.y, width: submarine.width/8, height: submarine.width/8)
            bubbleView.image = UIImage(named: "Bubble")
            bubbleView.clipsToBounds = true
            bubbleView.contentMode = .scaleToFill
        if submarineImageView.frame.origin.y < seaImageView.frame.origin.y {
            bubbleView.alpha = 0
        }
            return bubbleView
    }
    
    func setSeaBubble() -> UIImageView {
        let bubbleView = UIImageView()
        bubbleView.frame = CGRect(x: randomXSeaBubble(), y: self.view.frame.height, width: submarine.width/4, height: submarine.width/4)
        bubbleView.image = UIImage(named: "Bubble")
        bubbleView.clipsToBounds = true
        bubbleView.contentMode = .scaleToFill
        return bubbleView
    }
    func setMovingGroundImageView() {
        for view in movingGroundImageViewCollection {
            view.frame = CGRect(x: 0, y: self.view.frame.height - seaImageView.frame.height/7, width: self.view.frame.width, height: seaImageView.frame.height/7)
            view.image = UIImage(named: "SandGround")
            view.clipsToBounds = true
            view.contentMode = .scaleToFill
            self.view.addSubview(view)
        }
        movingGroundImageViewCollection[1].frame.origin.x = self.view.bounds.width
        groundSafeArea.frame = CGRect(x: 0, y: self.view.frame.height - seaImageView.frame.height/8, width: self.view.frame.width, height: seaImageView.frame.height/8)
    }
    
    func setMovingSkyImageView() {
        for view in movingSkyViewCollection {
            view.frame = skyImageView.frame
            view.image = UIImage(named: "Sky")
            view.clipsToBounds = true
            view.contentMode = .scaleToFill
            self.view.addSubview(view)
        }
        movingSkyViewCollection[1].frame.origin.x = self.view.bounds.width
    }
    
    func setSprayImageView() {
        for view in sprayImageViewCollection {
            view.frame = CGRect(x: 0, y: skyImageView.frame.maxY-skyImageView.frame.maxY/1.3, width: self.view.frame.width, height: seaImageView.frame.height)
            view.image = UIImage(named: "Spray")
            view.alpha = 0.1
            view.layer.zPosition = 0
            view.clipsToBounds = true
            view.contentMode = .redraw
            self.view.addSubview(view)
        }
        sprayImageViewCollection[1].frame.origin.x = self.view.bounds.width
    }

    func setBonusLabel() {
        bonusLabel.frame = CGRect(x: self.view.frame.midX-scoreLabel.frame.width/2, y: self.view.frame.midY, width: 50, height: 25)
        bonusLabel.textAlignment = .center
        bonusLabel.textColor = .white
        bonusLabel.text = "+25"
        bonusLabel.font = UIFont(name: "Chalkduster", size: 25)
        bonusLabel.alpha = 0
        self.view.addSubview(bonusLabel)
    }
    
    func randomY() -> CGFloat {
        return CGFloat.random(in: seaImageView.frame.origin.y + shark.height/2...seaImageView.frame.height - seaImageView.frame.height/5)
    }
    
    func randomXSeaBubble() -> CGFloat {
        return CGFloat.random(in: self.view.frame.origin.x + submarine.width/2...self.view.frame.width-submarine.width)
    }
    
    
    
    func setMissle() {
        missleImageView.frame = CGRect(x: submarineImageView.frame.maxX, y: submarineImageView.frame.midY, width: submarine.width/2, height: submarine.height/5)
        missleImageView.image = UIImage(named: missle.imageName)
        missleImageView.clipsToBounds = true
        missleImageView.layer.zPosition = 1
        missleImageView.contentMode = .scaleAspectFill
    }
    
    func bonusScoreAnimation() {
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: .calculationModeLinear) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.bonusLabel.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.bonusLabel.alpha = 0
            }
        }
    }
    func boomAnimation() {
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: .calculationModeLinear) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.05) {
                self.boomImageView.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.05, relativeDuration: 0.95) {
                self.boomImageView.alpha = 0
            }
        }
    }
    func moveBubble() {
        let oneBubble = setBubble()
        self.view.addSubview(oneBubble)
        UIImageView.animate(withDuration: 2, delay: 0, options: .curveLinear) {
            oneBubble.frame.origin.y = self.seaImageView.frame.minY
        } completion: { _ in
            oneBubble.removeFromSuperview()
        }
    }
    func moveSeaBubble() {
        let oneBubble = setSeaBubble()
        self.view.addSubview(oneBubble)
        UIImageView.animate(withDuration: 2, delay: 0, options: .curveLinear) {
            oneBubble.frame.origin.y = self.seaImageView.frame.minY
        } completion: { _ in
            oneBubble.removeFromSuperview()
        }
    }
    
    func moveMissle() {
        if missleImageView.frame.origin.x > self.view.frame.maxX {
            missleTimer.invalidate()
            missleImageView.removeFromSuperview()
            missleImageView.frame.origin.x = submarineImageView.frame.maxX
            missleImageView.frame.origin.y = submarineImageView.frame.midY
            return
        }
        
        for sharkImageView in sharkImageViewCollection {
            if missleImageView.frame.intersects(sharkImageView.frame) {
                self.boomImageView.frame.origin = sharkImageView.frame.origin
                oxygenViewFull.frame.size.width += 7
                boomAnimation()
                missleTimer.invalidate()
                missleImageView.removeFromSuperview()
                missleImageView.frame.origin.x = submarineImageView.frame.maxX
                missleImageView.frame.origin.y = submarineImageView.frame.midY
                sharkImageView.frame.origin.y = randomY()
                sharkImageView.frame.origin.x = self.view.frame.width*1.5
                if isSharkIntersectedWithPrevious() {
                    sharkImageView.frame.origin.x += sharkImageView.frame.width
                }
                sharkImageView.image = UIImage(named: shark.imageName.randomElement() ?? "Fish")
                bonusScoreAnimation()
                self.currentScore += 25
                return
            }

        }
        missleImageView.frame.origin.x += 1
    }
    
    func isSharkIntersectedWithPrevious() -> Bool {
        for index in 1...sharkImageViewCollection.count-1 {
            if sharkImageViewCollection[index].frame.intersects(sharkImageViewCollection[index-1].frame) { return true }
        }
        return false
    }
    func isAlreadyFired()-> Bool {
        if missleImageView.isDescendant(of: self.view) {
            return true
        }
        return false
    }
    
    func startOxygenViewTimer(){
        oxygenTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            self.changeOxygenView()
        })
            oxygenTimer.fire()
        
    }
    
    func startBubbleTimer() {
        bubbleTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.moveBubble()
        })
    }
    func startCrabTimer() {
        crabTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
            self.addCrab()
        })
    }
    func startSeaBubbleTimer() {
        seaBubbleTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.moveSeaBubble()
        })
    }
    func startGraviTimer() {
        graviTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { _ in
            if self.isInRightPositionDown() {
                let graviSpeed: CGFloat = 2
                self.submarineImageView.frame.origin.y += graviSpeed
                self.submarineSafeAreaView.frame.origin.y += graviSpeed
                self.oxygenViewFull.frame.origin.y += graviSpeed
                self.oxygenViewEmpty.frame.origin.y += graviSpeed
                if !self.isAlreadyFired() { self.missleImageView.frame.origin.y += graviSpeed }
            }
        })
    }
    func changeOxygenView() {
        oxygenViewFull.frame.size.width -= 0.5
        if oxygenViewFull.frame.size.width == 0 {
            print("Oxygen is Empty!")
            checkScore()
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
            boomImageView.frame.origin = submarineImageView.frame.origin
            boomAnimation()
            checkScore()
            stopGame()
            return
        }

        self.shipImageView.frame.origin.x -= 1
        
        if self.shipImageView.frame.maxX < 0 {
            self.shipImageView.frame.origin.x = self.view.bounds.width + 1
        }
    }
    
    func moveShark() {
        for sharkImageView in sharkImageViewCollection {
            if self.submarineSafeAreaView.frame.intersects(sharkImageView.frame) {
                print("Submarine damaged!")
                boomImageView.frame.origin = submarineImageView.frame.origin
                boomAnimation()
                checkScore()
                stopGame()
                return
            }
            sharkImageView.frame.origin.x -= 1
            if sharkImageView.frame.maxX < 0 {
                sharkImageView.frame.origin.x = self.view.bounds.width*1.5
                sharkImageView.image = UIImage(named: shark.imageName.randomElement() ?? "Fish")
                sharkImageView.frame.origin.y = randomY()
            }
        }
        
    }
    
    func moveGround() {
        for groundView in movingGroundImageViewCollection {
            if self.submarineSafeAreaView.frame.intersects(groundSafeArea.frame) {
                print("Submarine damaged!")
                boomImageView.frame.origin = submarineImageView.frame.origin
                boomAnimation()
                checkScore()
                stopGame()
                return
            }
            if groundView.frame.maxX == 0 {
                groundView.frame.origin.x = self.view.frame.width
            }
            groundView.frame.origin.x -= 1
        }
    }
    func moveSpray() {
        for sprayView in sprayImageViewCollection {
            if sprayView.frame.maxX == 0 {
                sprayView.frame.origin.x = self.view.frame.width
            }
            sprayView.frame.origin.x -= 1
        }
    }
    
   func movePlant() {
       if self.submarineSafeAreaView.frame.intersects(self.plantImageView.frame) {
           print("Submarine damaged!")
           boomImageView.frame.origin = submarineImageView.frame.origin
           boomAnimation()
           checkScore()
           stopGame()
           return
       }
        if plantImageView.frame.maxX < 0 {
            plantImageView.frame.origin.x = self.view.frame.width
        }
        plantImageView.frame.origin.x -= 1
    }
    func moveSky() {
        for skyView in movingSkyViewCollection {
            if skyView.frame.maxX == 0 {
                skyView.frame.origin.x = self.view.frame.width
            }
            skyView.frame.origin.x -= 1
        }
    }
    
    func startGroundTimer() {
        groundTimer = Timer.scheduledTimer(withTimeInterval: 0.030/Double(currentUser.speed)/speedMultiplier, repeats: true, block: { _ in
            self.moveGround()
        })
        groundTimer.fire()
    }
    
    func startPlantTimer() {
        plantTimer = Timer.scheduledTimer(withTimeInterval: 0.03/Double(currentUser.speed)/speedMultiplier, repeats: true, block: { _ in
            self.movePlant()
        })
        plantTimer.fire()
    }
    
    
    func startSprayTimer() {
        sprayTimer = Timer.scheduledTimer(withTimeInterval: 0.10/Double(currentUser.speed)/speedMultiplier, repeats: true, block: { _ in
            self.moveSpray()
        })
        sprayTimer.fire()
    }
    
    func startSkyTimer() {
        skyTimer = Timer.scheduledTimer(withTimeInterval: 0.10/Double(currentUser.speed)/speedMultiplier, repeats: true, block: { _ in
            self.moveSky()
        })
        skyTimer.fire()
    }
    func startMissleTimer() {
        missleTimer = Timer.scheduledTimer(withTimeInterval: 0.020/Double(missle.speed), repeats: true, block: { _ in
            self.moveMissle()
        })
    }
    func startSharkTimer() {
        sharkTimer = Timer.scheduledTimer(withTimeInterval: 0.020/Double(currentUser.speed)/speedMultiplier, repeats: true, block: { _ in
            self.moveShark()
        })
        sharkTimer.fire()
    }
    func startShipTimer() {
        shipTimer = Timer.scheduledTimer(withTimeInterval: 0.015/Double(currentUser.speed)/speedMultiplier*2, repeats: true, block: { _ in
            self.moveShip()
        })
        shipTimer.fire()
    }
    
    func startScoreTimer() {
        scoreTimer = Timer.scheduledTimer(withTimeInterval: 1/Double(currentUser.speed), repeats: true, block: { _ in
            self.currentScore += 5
            self.scoreLabel.text = String(self.currentScore)
        })
        scoreTimer.fire()
    }
    
    func startGameSpeedTimer(){
        gameSpeedTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.reloadTimers()
            self.speedMultiplier += 0.02
        })
        gameSpeedTimer.fire()
    }
    func checkScore() {
        for index in 0...currentUser.score.count-1 {
            if currentScore > currentUser.score[index] {
                currentUser.score.insert(currentScore, at: index)
                currentUser.score.remove(at: currentUser.score.count-1)
                currentUser.scoreName.insert(currentUser.userName, at: index)
                currentUser.scoreName.remove(at: currentUser.scoreName.count-1)
                print(currentUser.score, currentUser.scoreName)
                UserDefaults.standard.set(encodable: currentUser, forKey: "currentUser")
                break
            }
        }
    }
    func animateCrash() {
        UIView.animate(withDuration: 2, delay: 0, options: .curveLinear) {
            self.submarineImageView.frame.origin.y = self.view.frame.height - self.submarine.height*1.3
        }

    }
    func animateGameOverLabels() {
        UIView.animateKeyframes(withDuration: 4, delay: 0, options: .calculationModeLinear) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                self.gameOverLabel.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.5) {
                self.gameOverScoreLabel.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 1) {
                self.reloadButton.alpha = 1
            }
        } completion: { _ in
            self.reloadButton.isEnabled = true
        }
    }
    
    func reloadTimers() {
        shipTimer.invalidate()
        sharkTimer.invalidate()
        groundTimer.invalidate()
        plantTimer.invalidate()
        skyTimer.invalidate()
        sprayTimer.invalidate()
        startSprayTimer()
        startPlantTimer()
        startGroundTimer()
        startSkyTimer()
        startShipTimer()
        startSharkTimer()
    }
    
    func stopGame() {
        self.oxygenViewFull.alpha = 0
        animateCrash()
        self.sharkTimer.invalidate()
        self.shipTimer.invalidate()
        self.oxygenTimer.invalidate()
        self.groundTimer.invalidate()
        self.sprayTimer.invalidate()
        self.skyTimer.invalidate()
        self.scoreTimer.invalidate()
        self.bubbleTimer.invalidate()
        self.plantTimer.invalidate()
        self.gameSpeedTimer.invalidate()
        self.crabTimer.invalidate()
        self.graviTimer.invalidate()
        self.seaBubbleTimer.invalidate()
        gameOverScoreLabel.text = " \(currentUser.userName) your score: \(currentScore) "
        scoreLabel.alpha = 0
        self.currentScore = 0
        self.isLive = false
        self.fireButton.isHidden = true
        self.animateGameOverLabels()
       
    }
}
