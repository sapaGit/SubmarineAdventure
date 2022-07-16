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
    @IBOutlet var superMissleButton: UIButton!
    @IBOutlet var gameOverScoreLabel: UILabel!
    
    
    //MARK: - let/var
    private var currentUser = User(userName: "User")
    
    private var submarineImageView = UIImageView()
    
    //created for checking intersection
    private var submarineSafeAreaView = UIView()
    
    private var shipImageView = UIImageView()
    private var boomImageView = UIImageView()
    private var missleImageView = UIImageView()
    private var superMissleImageView = UIImageView()
    private var plantImageView = UIImageView()
    private var oxygenBubble = UIImageView()
    private var mysteryBox = UIImageView()
    
    //created to hide elements when pop to root VC
    private var interfaceImageView = UIImageView()
    
    //created for gestureRecognizer
    private var gestureView = UIView()
    
    
    private var sharkImageViewCollection = [UIImageView(), UIImageView()]
    private var sprayImageViewCollection = [UIImageView(), UIImageView()]
    private var movingSkyViewCollection = [UIImageView(), UIImageView()]
    private var movingGroundImageViewCollection = [UIImageView(), UIImageView()]
    
    //created for checking intersection
    private var groundSafeArea = UIView()
    
    private var oxygenViewFull = UIView()
    
    //not installed, this is white view when oxygen is decreasing
    private var oxygenViewEmpty = UIView()
   
    //shows bonus points for some actions in game
    private var bonusLabel = UILabel()
    
    private var oxygenTimer = Timer()
    private var sharkTimer = Timer()
    private var shipTimer = Timer()
    private var bubbleTimer = Timer()
    private var groundTimer = Timer()
    private var crabTimer = Timer()
    private var skyTimer = Timer()
    private var plantTimer = Timer()
    private var sprayTimer = Timer()
    private var buttonTimer = Timer()
    private var missleTimer = Timer()
    private var scoreTimer = Timer()
    private var seaBubbleTimer = Timer()
    private var gameDificultyTimer = Timer()
    private var graviTimer = Timer()
    private var oxygenBubbleTimer = Timer()
    private var mysteryBoxTimer = Timer()
    
    //for checking is submarine already damaged
    private var isLive = true
    
    //multiplier for changing game speed
    private var speedMultiplier = 1.0
    
    //creating objects
    private var ship = Ship()
    private var shark = Shark()
    private var submarine = Submarine()
    private var missle = Missle()
    private var superMisssle = SuperMissle()
    
    private var currentScore = 0
    private var gameTime = 0
    private var sharkIndex = 2
    private var superMissleCount = 0
    private var xSharkPosition: CGFloat = 0

    
    //MARK: - lifecycle funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInterface()
        startTimers()
        
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
    @IBAction func superButtonTapped(_ sender: UIButton) {
    }
    @IBAction func reloadTapped(_ sender: UIButton) {
        removeCreatedSharks()
        setSharkStartPosition()
        sharkImageViewCollection[0].frame = CGRect(x: view.frame.width - 150, y: sharkYPosition(index: 0), width: shark.width, height: shark.height)
        sharkImageViewCollection[1].frame = CGRect(x: view.frame.width*1.5, y: sharkYPosition(index: 1), width: shark.width, height: shark.height)
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
        gameTime = 0
        sharkIndex = 2
        self.isLive = true
        self.gestureView.isUserInteractionEnabled = true
        self.upButton.isUserInteractionEnabled = true
        startTimers()
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
                addOxygen()
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
    
    func addGestures() {
    let longPressGesture = UITapGestureRecognizer(target: self, action: #selector(longPressDetected))
        gestureView.addGestureRecognizer(longPressGesture)
    }
    @objc func longPressDetected() {
        UIView.animate(withDuration: 0.5) {
            if self.isInRightPositionUp(){
                self.submarineImageView.frame.origin.y -= 50
                self.oxygenViewFull.frame.origin.y -= 50
                
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
        xSharkPosition = view.frame.width - 150
        seaImageView.clipsToBounds = true
        setShark()
        setShip()
        setSubmarine()
        setOxygenView()
        gameOverLabel.layer.zPosition = 1
        gameOverScoreLabel.layer.zPosition = 1
        reloadButton.layer.zPosition = 1
        goToMain.layer.zPosition = 2
        upButton.layer.zPosition = 1
        upButton.alpha = 0.02
        gameOverLabel.rounded()
        gameOverScoreLabel.rounded()
        reloadButton.rounded()
        setMovingGroundImageView()
        setMovingSkyImageView()
        setMissle()
        setBoom()
        setPlant()
        setOxygenBubble()
        setSprayImageView()
        setInterfaceImageView()
        setBonusLabel()
        fireButton.layer.zPosition = 1
        //setGestureView()
        //addGestures()
    }
    
    func setGestureView() {
        gestureView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        gestureView.isUserInteractionEnabled = true
        gestureView.layer.zPosition = 2
        self.view.addSubview(gestureView)
    }
    
    func setSharkStartPosition() {
        var tempIndex = 0
        for sharkImageView in sharkImageViewCollection {
        sharkImageView.frame = CGRect(x: xSharkPosition, y: sharkYPosition(index: tempIndex), width: shark.width, height: shark.height)
        xSharkPosition += self.view.frame.width*0.7
            tempIndex += 1
        }
    }
    func setShark() {
        var tempIndex = 0
        for sharkImageView in sharkImageViewCollection{
            sharkImageView.clipsToBounds = true
            sharkImageView.contentMode = .scaleAspectFit
            sharkImageView.frame = CGRect(x: xSharkPosition, y: sharkYPosition(index: tempIndex), width: shark.width, height: shark.height)
            xSharkPosition += self.view.frame.width*0.7
            tempIndex += 1
            sharkImageView.image = UIImage(named: shark.imageName.randomElement() ?? "Fish")
            view.addSubview(sharkImageView)
        }
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
    func addAnoterShark() {
        let sharkImageView = UIImageView()
        sharkImageView.clipsToBounds = true
        sharkImageView.contentMode = .scaleAspectFit
        sharkImageView.frame = CGRect(x: xSharkPosition, y: sharkYPosition(index: sharkIndex), width: shark.width, height: shark.height)
        sharkIndex += 1
        for imageView in sharkImageViewCollection {
            if sharkImageView.frame.intersects(imageView.frame) {
                print("Shark intersection detected")
                return
            }
        }
        sharkImageView.image = UIImage(named: shark.imageName.randomElement() ?? "Fish")
        sharkImageViewCollection.append(sharkImageView)
        view.addSubview(sharkImageView)
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
    func setOxygenBubble() {
        oxygenBubble.frame = CGRect(x: self.view.frame.width*1.2, y: randomSeaYPosition(), width: sharkImageViewCollection[0].frame.height, height: sharkImageViewCollection[0].frame.height)
        oxygenBubble.image = UIImage(named: "OxygenBubble")
        oxygenBubble.contentMode = .scaleToFill
        oxygenBubble.clipsToBounds = true
        oxygenBubble.layer.zPosition = 1
        view.addSubview(oxygenBubble)
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
    
    func setInterfaceImageView() {
        interfaceImageView.frame = CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        interfaceImageView.layer.zPosition = 2
        interfaceImageView.image = UIImage(named: "YellowSubmarine")
        interfaceImageView.contentMode = .scaleAspectFill
        self.view.addSubview(interfaceImageView)
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
    //next
    func sharkYPosition(index: Int) -> CGFloat {
        switch index {
        case 0: return seaImageView.frame.origin.y + seaImageView.frame.height/10
        case 1: return seaImageView.frame.origin.y + seaImageView.frame.height/3.3
        case 2: return seaImageView.frame.origin.y + seaImageView.frame.height/2.1
        case 3: return seaImageView.frame.origin.y + seaImageView.frame.height/1.5
        default: return CGFloat.random(in: seaImageView.frame.origin.y + shark.height/2...seaImageView.frame.height - seaImageView.frame.height/5)
        }
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
    
    func startSharkXPosition() -> CGFloat {
        for sharkImageView in sharkImageViewCollection {
            if sharkImageView.frame.maxX > self.view.frame.width * 1.5 {
                return self.view.frame.width * 1.5 + shark.width }
        }
        return self.view.frame.width * 1.5
    }
    
    func randomSeaYPosition()-> CGFloat {
        return CGFloat.random(in: seaImageView.frame.minY+submarine.height...seaImageView.frame.maxY-2*submarine.height)
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
                boomAnimation()
                missleTimer.invalidate()
                missleImageView.removeFromSuperview()
                missleImageView.frame.origin.x = submarineImageView.frame.maxX
                missleImageView.frame.origin.y = submarineImageView.frame.midY
                sharkImageView.frame.origin.x = self.view.frame.width*1.5
                while isSharkIntersectedWithPrevious() {
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
                sharkImageView.frame.origin.x = startSharkXPosition()
                sharkImageView.image = UIImage(named: shark.imageName.randomElement() ?? "Fish")
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
    
    func moveOxygenBubble() {
        if self.submarineSafeAreaView.frame.intersects(self.oxygenBubble.frame) {
            print("Oxygen added!")
            oxygenBubble.frame.origin.x = self.view.frame.width*3
            addOxygen()
            return
        }
         if oxygenBubble.frame.maxX < 0 {
             oxygenBubble.frame.origin.x = self.view.frame.width*3
             oxygenBubble.frame.origin.y = randomSeaYPosition()
         }
         oxygenBubble.frame.origin.x -= 1
    }
    func moveSky() {
        for skyView in movingSkyViewCollection {
            if skyView.frame.maxX == 0 {
                skyView.frame.origin.x = self.view.frame.width
            }
            skyView.frame.origin.x -= 1
        }
    }
    
    func addOxygen() {
        UIView.animate(withDuration: 0.5) {
            self.oxygenViewFull.frame.size.width = self.submarineImageView.frame.width
        } completion: { _ in
            self.oxygenViewFull.frame.size.width = self.submarineImageView.frame.width
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
    
    func startOxygenBubbleTimer() {
        oxygenBubbleTimer = Timer.scheduledTimer(withTimeInterval: 0.025/Double(currentUser.speed)/speedMultiplier, repeats: true, block: { _ in
            self.moveOxygenBubble()
        })
        oxygenBubbleTimer.fire()
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
    
    func removeCreatedSharks() {
        if gameTime > 14 {
            sharkImageViewCollection[sharkImageViewCollection.count-1].removeFromSuperview()
            sharkImageViewCollection.removeLast()
            print("Shark 4 removed")
        }
        if gameTime > 4 {
            sharkImageViewCollection[sharkImageViewCollection.count-1].removeFromSuperview()
            sharkImageViewCollection.removeLast()
            print("Shark 3 removed")
        }
    }
    
    func startGameDificultyTimer(){
        gameDificultyTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.reloadTimers()
            self.speedMultiplier += 0.02
            self.gameTime += 1
            if self.gameTime == 5 {
                self.addAnoterShark()
            }
            if self.gameTime == 15 {
                self.addAnoterShark()
            }
        })
        gameDificultyTimer.fire()
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
    func startTimers() {
        startShipTimer()
        startSharkTimer()
        startOxygenViewTimer()
        startGroundTimer()
        startScoreTimer()
        startSprayTimer()
        startSkyTimer()
        startPlantTimer()
        startOxygenBubbleTimer()
        startSeaBubbleTimer()
        startGameDificultyTimer()
        startCrabTimer()
        startGraviTimer()
        startBubbleTimer()
    }
    
    func reloadTimers() {
        shipTimer.invalidate()
        sharkTimer.invalidate()
        groundTimer.invalidate()
        plantTimer.invalidate()
        skyTimer.invalidate()
        sprayTimer.invalidate()
        oxygenBubbleTimer.invalidate()
        startSprayTimer()
        startOxygenBubbleTimer()
        startPlantTimer()
        startGroundTimer()
        startSkyTimer()
        startShipTimer()
        startSharkTimer()
    }
    
    func stopGame() {
        self.oxygenViewFull.alpha = 0
        self.gestureView.isUserInteractionEnabled = false
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
        self.oxygenBubbleTimer.invalidate()
        self.gameDificultyTimer.invalidate()
        self.crabTimer.invalidate()
        self.graviTimer.invalidate()
        self.seaBubbleTimer.invalidate()
        gameOverScoreLabel.text = " \(currentUser.userName) your score: \(currentScore) "
        scoreLabel.alpha = 0
        self.currentScore = 0
        xSharkPosition = view.frame.width - 150
        self.isLive = false
        self.fireButton.isHidden = true
        self.animateGameOverLabels()
        self.upButton.isUserInteractionEnabled = false
    }
}
