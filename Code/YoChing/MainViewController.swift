//
//  ViewController.swift
//  YoChing
//
//  Created by SirWellington on 10/01/15.
//  Copyright © 2015 Yo Ching. All rights reserved.
//

import AromaSwiftClient
import LTMorphingLabel
import UIKit
import QuartzCore
import WebKit

class MainViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var whatsYourSituationLabel: UILabel!
    fileprivate let phrases: [String] = [
        "WHAT'S YOUR SITUATION?",
        "WHAT'S UP?",
        "WHAT'S HAPPENING?",
        "WHAT'S GOING ON?",
        "WHERE YOU AT?" ,
        "WHAT'S SHAKIN?"
    ]
    
    @IBOutlet weak var coinOneImage: UIImageView!
    @IBOutlet weak var coinTwoImage: UIImageView!
    @IBOutlet weak var coinThreeImage: UIImageView!
    
    @IBOutlet weak var wrexLinesContainer: UIView!
    @IBOutlet weak var wrexLine1: UIImageView!
    @IBOutlet weak var wrexLine2: UIImageView!
    @IBOutlet weak var wrexLine3: UIImageView!
    @IBOutlet weak var wrexLine4: UIImageView!
    @IBOutlet weak var wrexLine5: UIImageView!
    @IBOutlet weak var wrexLine6: UIImageView!
    
    @IBOutlet weak fileprivate var flipButton: UIButton!
    
    
    //MARK: Internal Variables
    fileprivate var coinOne: Coin!
    fileprivate var coinTwo: Coin!
    fileprivate var coinThree: Coin!
    
    fileprivate var maxTosses = 6
    fileprivate var tosses  = 0
    fileprivate var hexNum = ""
    fileprivate var animationRandomFactor = 1
    
    fileprivate var coinsInTheAir = 0
    fileprivate let main = OperationQueue.main
    fileprivate let async = OperationQueue()
    
    fileprivate let transition = AnimateLeft()
    
    //MARK: Wrex Lines
    fileprivate lazy var splitLineImage: UIImage? = {
        if let image = UIImage(named: "WREX_MASTER-splitline") {
            return image
        }
        else {
            AromaClient.sendHighPriorityMessage(withTitle: "Split Line Image Failed To Load")
            return nil
        }
    }()
    
    fileprivate lazy var strongLineImage: UIImage? = {
        if let image = UIImage(named: "WREX_MASTER-strongline") {
            return image
        }
        else {
            AromaClient.sendHighPriorityMessage(withTitle: "Strong Line Failed To Load")
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinOne = Coin(image: coinOneImage)
        coinTwo = Coin(image: coinTwoImage)
        coinThree = Coin(image: coinThreeImage)
        
        whatsYourSituationLabel.isHidden = true
        
        async.maxConcurrentOperationCount = 1
        
        addSwipeGesture()
        
        setCoins(coinOneImage, coinTwoImage, coinThreeImage)
        addTapGestures(coinOneImage, coinTwoImage, coinThreeImage)
        
        if Settings.isFirstTimeRunning {
            Settings.isFirstTimeRunning = false
            
            self.goToTutorial()
        }
    }
    
    fileprivate func addTapGestures(_ imageView: UIImageView...) {
        
        for image in imageView {
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
            gesture.numberOfTapsRequired = 1
            
            image.addGestureRecognizer(gesture)
        }
        
    }
    
    func onTap(_ gesture: UIGestureRecognizer) {
        guard let view = gesture.view as? UIImageView else { return }
        
        flipCoin(view)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.maxTosses = Settings.isQuickEnabled ? 1 : 6
        
        if tosses == 0 {
            
            hideWrexLines()
            animationRandomFactor = Int.random(from: 1, to: 5)
            showPrompt()
        }
        else {
            
            hidePrompt()
        }
    }
    
    fileprivate func showPrompt() {
        
        guard let isHidden = whatsYourSituationLabel?.isHidden, isHidden
        else { return }
        
        //In order for the animation to show, the text in the label has to change, or appear to change value.
        let phrase = phrases.selectOne() ?? "WHAT'S YOUR SITUATION?"
        
        whatsYourSituationLabel?.text = nil
        
        let animations = { [weak whatsYourSituationLabel] in
            
            whatsYourSituationLabel?.isHidden = false
            whatsYourSituationLabel?.text = phrase
            return
        }
        
        UIView.transition(with: whatsYourSituationLabel, duration: 0.5, options: .transitionCrossDissolve, animations: animations, completion: nil)
    }
    
    fileprivate func hidePrompt() {
        
        let animation = { [weak whatsYourSituationLabel] in
            
            whatsYourSituationLabel?.isHidden = true
            return
        }
        
        UIView.transition(with: whatsYourSituationLabel, duration: 0.5, options: .transitionCrossDissolve, animations: animation, completion: nil)
    }
    
    fileprivate func setCoins(_ imageView: UIImageView...) {
        
        for image in imageView {
            
            let animations: (Void) -> Void = {
                image.image = Coin.headsCoin
            }
            
            UIView.transition(with: image, duration: 0.2, options: .transitionFlipFromTop, animations: animations, completion: nil)
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            self.flipCoinAction(nil)
        }
    }
    
    fileprivate func addSwipeGesture() {
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.onSwipeRight(_:)))
        rightGesture.direction = .right
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.onSwipeLeft(_:)))
        leftGesture.direction = .left
        
        self.view.addGestureRecognizer(rightGesture)
        self.view.addGestureRecognizer(leftGesture)
    }

    
}


//MARK : Actions
extension MainViewController {
    
    func onSwipeRight(_ sender: UIGestureRecognizer) {
        self.goToSettings()
    }
    
    func onSwipeLeft(_ sender: UIGestureRecognizer) {
        self.goToWrexagramList()
    }
    
    @IBAction func scaleUpButton(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.1, animations: {
            sender.titleLabel?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) 
    }
    
    @IBAction func scaleDownButton(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.1, animations: {
            sender.titleLabel?.transform = CGAffineTransform.identity
        }) 
    }
    
    @IBAction func flipCoinAction(_ sender: AnyObject?) {
        throwTheYo()
    }
    
    fileprivate func randomDouble(_ lower: Double = 0.0, _ upper: Double = 0.35) -> Double {
        
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
    
    
    fileprivate func randomWrexagram() -> String {
        
        let randomNum = Int(arc4random_uniform(63) + 1)
        let wrex = String(format: "wrexagram%02d", randomNum)
        return wrex
    }
    

}

//MARK: Segues
extension MainViewController {
    
    @IBAction func onGoToNext(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "ToCoinResults", sender: sender)
    }
    
    fileprivate func goToWrex(_ outcome: Int) {
        self.performSegue(withIdentifier: "ToPager", sender: outcome)
    }
    
    fileprivate func goToWrexagramList() {
        self.performSegue(withIdentifier: "ToList", sender: self)
    }
    
    fileprivate func goToSettings() {
        self.performSegue(withIdentifier: "ToSettings", sender: self)
    }
    
    fileprivate func goToTutorial() {
        self.performSegue(withIdentifier: "ToTutorial", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination
        
        if let wrexegramView = destination as? WrexagramViewController {
            if let outcome = sender as? Int {
                wrexegramView.wrexagramNumber = outcome
            }
        }
        
        if let pager = destination as? WrexagramPagerViewController, let outcome = sender as? Int {
            pager.initialIndex = outcome - 1
            pager.wrexagrams = WrexagramLibrary.wrexagrams
        }
        
        if let nav = destination as? UINavigationController, let _ = nav.topViewController as? SettingsViewController {
            nav.transitioningDelegate = self.transition
        }
        
    }
    
    
    @IBAction func unwindFromSettings(_ segue: UIStoryboardSegue) {
        
        if tosses == 0 {
            setCoins(coinOneImage, coinTwoImage, coinThreeImage)
        }
    }
}

//MARK: Wrexagram Logic
extension MainViewController {
    
    
    fileprivate func hideWrexLines() {
        
        let lines = [ wrexLine1, wrexLine2, wrexLine3, wrexLine4, wrexLine5, wrexLine6]
        lines.forEach() { line in line?.isHidden = true }
    }
    
    
    fileprivate func flipCoin(_ imageView: UIImageView) {
        
        let animation: (Void)  -> Void = {
            let heads = Int(arc4random_uniform(10)) % 2 == 0
            imageView.image = heads ? Coin.headsCoin : Coin.tailsCoin
        }
        
        UIView.transition(with: imageView, duration: 0.2, options: .transitionFlipFromTop, animations: animation, completion: nil)
    }


    fileprivate func throwTheYo() {
        
        flipButton.isEnabled = false
        hidePrompt()
        
        var coinsOutcome: [Coin.CoinSide] = []
        
        self.coinsInTheAir = 3
        
        delay(randomDouble()) {
            self.coinOne?.flipCoinAction() { side in
                self.coinsInTheAir -= 1
                print("Coin 1 Flipped: \(side)")
                coinsOutcome.append(side)
            }
        }
        
        delay(randomDouble()) {
            
            self.coinTwo.flipCoinAction() { side in
                self.coinsInTheAir -= 1
                print("Coin 2 Flipped: \(side)")
                coinsOutcome.append(side)
            }
        }
        
        delay(randomDouble()) {
            
            self.coinThree?.flipCoinAction() { side in
                self.coinsInTheAir -= 1
                print("Coin 3 Flipped: \(side)")
                coinsOutcome.append(side)
            }
        }
        
        
        async.addOperation() {
            
            self.tosses += 1
            
            while self.coinsInTheAir > 0 { } //wait
            
            self.main.addOperation() {
                
                self.recordCoinTossResult(coinsOutcome)
                self.flipButton.isEnabled = true
                
                if self.tosses >= self.maxTosses {
                    
                    defer {
                        self.tosses = 0
                        self.hexNum = ""
                    }
                    
                    // confusing needs to be cleaned up, but works
                    
                    let outcome: String
                    
                    // only 1 toss ? get a random wrexagram
                    if self.maxTosses == 1 {
                        outcome = self.randomWrexagram()
                    }
                    else {
                        let hexNumber = Int(self.hexNum) ?? 111111
                        outcome  = WrexagramLibrary.getOutcome(hexNumber)
                    }
                    
                    let wrexNumber = Int(outcome.replacingOccurrences(of: "wrexagram", with: "")) ?? 01
                    
                    defer {
                        AromaClient.beginMessage(withTitle: "Coins Flipped")
                            .addBody("Result: Wrexagram \(wrexNumber)")
                            .withPriority(.low)
                            .send()
                        
                    }
                    
                    if self.maxTosses == 1 {
                        self.hideWrexLines()
                        self.goToWrex(wrexNumber)
                    }
                    else {
                        self.flipButton.isEnabled = false
                      
                        self.delay(0.5) {
                            self.goToWrex(wrexNumber)
                            self.hideWrexLines()
                            self.flipButton.isEnabled = true
                        }
                    }
                }
            }
            
        }
    }
    
    
    fileprivate func recordCoinTossResult(_ coinTossResults: [Coin.CoinSide]) {
        
        let headCount = coinTossResults.filter{$0 == Coin.CoinSide.heads}.count
        
        if headCount >= 2 {
            hexNum += "1"
        }
        else {
            hexNum += "2"
        }
        
        AromaClient.beginMessage(withTitle: "Recording Coin Toss")
            .addBody("\(headCount) Heads | \(3 - headCount) Tails").addLine(2)
            .addBody("Hex Num is \(hexNum)")
            .withPriority(.low)
            .send()
 
        guard let wrexLineImage = getWrexLineForResults(coinTossResults)
        else {
         
            AromaClient.beginMessage(withTitle: "Failed to Load Wrex Line")
                .addBody("Hex Num: \(hexNum)").addLine(2)
                .addBody("For Results:").addLine()
                .addBody("\(coinTossResults)")
                .withPriority(.low)
                .send()
           
            return
        }
        
        switch tosses {
            case 1 :  wrexLine1.image = wrexLineImage ; fadeInWrexagramLine(wrexLine1)
            case 2 :  wrexLine2.image = wrexLineImage ; fadeInWrexagramLine(wrexLine2)
            case 3 :  wrexLine3.image = wrexLineImage ; fadeInWrexagramLine(wrexLine3)
            case 4 :  wrexLine4.image = wrexLineImage ; fadeInWrexagramLine(wrexLine4)
            case 5 :  wrexLine5.image = wrexLineImage ; fadeInWrexagramLine(wrexLine5)
            default : wrexLine6.image = wrexLineImage ; fadeInWrexagramLine(wrexLine6)
        }
    }
    
    
    fileprivate func getWrexLineForResults(_ results: [Coin.CoinSide]) -> UIImage? {
        
        guard !results.isEmpty && results.count == 3
        else {
          
            AromaClient.beginMessage(withTitle: "Incorrect Coin Results")
                .withPriority(.high)
                .addBody("Coin results are either empty or not 3").addLine(2)
                .addBody("\(results.count) Coins in results").addLine()
                .addBody("\(results)")
                .send()
 
            return nil
        }
        
        
        let numberOfHeads = results.filter{ $0 == Coin.CoinSide.heads }.count
        
        if numberOfHeads >= 2 {
            return strongLineImage
        }
        else {
            return splitLineImage
        }
    }
    
    fileprivate func fadeInWrexagramLine(_ wrexLine: UIImageView) {
        
        let transition: UIViewAnimationOptions
        let duration: TimeInterval
        
        if animationRandomFactor.isEven() {
            transition = .transitionCurlUp
            duration = 0.4
        }
        else {
            transition = .transitionCurlDown
            duration = 0.3
        }
        
        UIView.transition(with: wrexLine, duration: duration, options: transition, animations: { wrexLine.isHidden = false }, completion: nil)
    }
}
