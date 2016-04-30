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

class MainViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var whatsYourSituationLabel: UILabel!
    private let phrases: [String] = [
        "WHAT'S YOUR SITUATION?",
        "WHAT'S UP?",
        "WHAT'S HAPPENING?",
        "WHAT'S GOING ON?",
        "WHERE YOU AT?"
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
    
    @IBOutlet weak private var flipButton: UIButton!
    
    
    //MARK: Internal Variables
    private var coinOne: Coin!
    private var coinTwo: Coin!
    private var coinThree: Coin!
    
    private var maxTosses = 6
    private var tosses  = 0
    private var hexNum = ""
    private var animationRandomFactor = 1
    
    private var coinsInTheAir = 0
    private let main = NSOperationQueue.mainQueue()
    private let async = NSOperationQueue()
    
    private let transition = AnimateLeft()
    
    private var splitLineImage: UIImage? {
        if let image = UIImage(named: "WREX_MASTER-splitline") {
            AromaClient.sendLowPriorityMessage(withTitle: "Split Line Image Loaded")
            return image
        }
        else {
            AromaClient.sendLowPriorityMessage(withTitle: "Split Line Image Failed To Load")
            return nil
        }
    }
    
    private var strongLineImage: UIImage? {
        if let image = UIImage(named: "WREX_MASTER-strongline") {
            AromaClient.sendLowPriorityMessage(withTitle: "Strong Line Image Loaded")
            return image
        }
        else {
            AromaClient.sendLowPriorityMessage(withTitle: "String Line Failed To Load")
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinOne = Coin(image: coinOneImage)
        coinTwo = Coin(image: coinTwoImage)
        coinThree = Coin(image: coinThreeImage)
        
        whatsYourSituationLabel.hidden = true
        
        async.maxConcurrentOperationCount = 1
        
        addSwipeGesture()
        
        setCoins(coinOneImage, coinTwoImage, coinThreeImage)
        addTapGestures(coinOneImage, coinTwoImage, coinThreeImage)
    }
    
    private func addTapGestures(imageView: UIImageView...) {
        
        for image in imageView {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
            gesture.numberOfTapsRequired = 1
            image.addGestureRecognizer(gesture)
        }
        
    }
    
    func onTap(gesture: UIGestureRecognizer) {
        guard let view = gesture.view as? UIImageView else { return }
        
        flipCoin(view)
    }

    override func viewDidAppear(animated: Bool) {
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
    
    private func showPrompt() {
        
        guard let isHidden = whatsYourSituationLabel?.hidden where isHidden
        else { return }
        
        //In order for the animation to show, the text in the label has to change, or appear to change value.
        let phrase = phrases.selectOne() ?? "WHAT'S YOUR SITUATION?"
        
        whatsYourSituationLabel?.text = nil
        
        let animations = { [weak whatsYourSituationLabel] in
            whatsYourSituationLabel?.hidden = false
            whatsYourSituationLabel?.text = phrase
            return
        }
        
        UIView.transitionWithView(whatsYourSituationLabel, duration: 0.5, options: .TransitionCrossDissolve, animations: animations, completion: nil)
    }
    
    private func hidePrompt() {
        
        let animation = { [weak whatsYourSituationLabel] in
            whatsYourSituationLabel?.hidden = true
            return
        }
        
        UIView.transitionWithView(whatsYourSituationLabel, duration: 0.5, options: .TransitionCrossDissolve, animations: animation, completion: nil)
    }
    
    private func setCoins(imageView: UIImageView...) {
        
        for image in imageView {
            
            let animations: Void -> Void = {
                image.image = Coin.headsCoin
            }
            
            UIView.transitionWithView(image, duration: 0.2, options: .TransitionFlipFromTop, animations: animations, completion: nil)
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            self.flipCoinAction(NSNull)
        }
    }
    
    private func addSwipeGesture() {
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.onSwipeRight(_:)))
        rightGesture.direction = .Right
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.onSwipeLeft(_:)))
        leftGesture.direction = .Left
        
        self.view.addGestureRecognizer(rightGesture)
        self.view.addGestureRecognizer(leftGesture)
    }

    
}


//MARK : Actions
extension MainViewController {
    
    func onSwipeRight(sender: UIGestureRecognizer) {
        self.goToSettings()
    }
    
    func onSwipeLeft(sender: UIGestureRecognizer) {
        self.goToWrexagramList()
    }
    
    @IBAction func scaleUpButton(sender: UIButton) {
        UIView.animateWithDuration(0.1) {
            sender.titleLabel?.transform = CGAffineTransformMakeScale(0.8, 0.8)
        }
    }
    
    @IBAction func scaleDownButton(sender: UIButton) {
        UIView.animateWithDuration(0.1) {
            sender.titleLabel?.transform = CGAffineTransformIdentity
        }
    }
    
    @IBAction func flipCoinAction(sender: AnyObject) {
        throwTheYo()
    }
    
    private func randomDouble(lower: Double = 0.0, _ upper: Double = 0.35) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
    
    
    private func randomWrexagram() -> String {
        let randomNum = Int(arc4random_uniform(63) + 1)
        let wrex = String(format: "wrexagram%02d", randomNum)
        return wrex
    }
    

}

//MARK: Segues
extension MainViewController {
    
    @IBAction func onGoToNext(sender: AnyObject) {
        self.performSegueWithIdentifier("ToCoinResults", sender: sender)
    }
    
    private func goToWrex(outcome: Int) {
        self.performSegueWithIdentifier("ToPager", sender: outcome)
    }
    
    private func goToWrexagramList() {
        self.performSegueWithIdentifier("ToList", sender: self)
    }
    
    private func goToSettings() {
        self.performSegueWithIdentifier("ToSettings", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destination = segue.destinationViewController
        
        if let wrexegramView = destination as? WrexagramViewController {
            if let outcome = sender as? Int {
                print("transitioning to wrexagram with outcome \(outcome)")
                wrexegramView.wrexagramNumber = outcome
            }
        }
        
        if let pager = destination as? WrexagramPagerViewController, outcome = sender as? Int {
            pager.initialIndex = outcome - 1
            pager.wrexagrams = WrexagramLibrary.wrexagrams
        }
        
        if let nav = destination as? UINavigationController, let _ = nav.topViewController as? SettingsViewController {
            nav.transitioningDelegate = self.transition
        }
        
    }
    
    
    @IBAction func unwindFromSettings(segue: UIStoryboardSegue) {
        print("Unwinding")
        
        if tosses == 0 {
            setCoins(coinOneImage, coinTwoImage, coinThreeImage)
        }
    }
}

//MARK: Wrexagram Logic
extension MainViewController {
    
    
    private func hideWrexLines() {
        
        AromaClient.sendLowPriorityMessage(withTitle: "Hiding Wrex Lines")
        let lines = [ wrexLine1, wrexLine2, wrexLine3, wrexLine4, wrexLine5, wrexLine6]
        lines.forEach() { line in line.hidden = true }
    }
    
    
    private func flipCoin(imageView: UIImageView) {
        let animation: Void  -> Void = {
            let heads = Int(arc4random_uniform(10)) % 2 == 0
            imageView.image = heads ? Coin.headsCoin : Coin.tailsCoin
        }
        
        UIView.transitionWithView(imageView, duration: 0.2, options: .TransitionFlipFromTop, animations: animation, completion: nil)
    }
    
    
    private func getWrexLineForResults(results: [Coin.CoinSide]) -> UIImage? {
        
        guard !results.isEmpty && results.count == 3 else { return nil }
        
        let numberOfHeads = results.filter{ $0 == Coin.CoinSide.HEADS }.count
        
        if numberOfHeads >= 2 {
            return strongLineImage
        }
        else {
            return splitLineImage
        }
    }

    private func throwTheYo() {
        
        flipButton.enabled = false
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
        
        
        async.addOperationWithBlock() {
            
            self.tosses += 1
            
            while self.coinsInTheAir > 0 { } //wait
            
            self.main.addOperationWithBlock() {
                
                self.recordCoinTossResult(coinsOutcome)
                self.flipButton.enabled = true
                
                if self.tosses >= self.maxTosses {
                    
                    defer {
                        self.tosses = 0
                        self.hexNum = ""
                    }
                    
                    // confusing needs to be cleaned up, but works
                    
                    var outcome:String
                    
                    // only 1 toss ? get a random wrexagram
                    if self.maxTosses == 1 {
                        outcome = self.randomWrexagram()
                    }
                    else {
                        let hexNumber = Int(self.hexNum) ?? 111111
                        outcome  = WrexagramLibrary.getOutcome(hexNumber)
                    }
                    
                    defer {
                        AromaClient.beginWithTitle("Coins Flipped")
                            .addBody("Result: \(outcome)")
                            .withPriority(.LOW)
                            .send()
                    }
                    
                    let wrexNumber = Int(outcome.stringByReplacingOccurrencesOfString("wrexagram", withString: "")) ?? 01
                    
                    if self.maxTosses == 1 {
                        self.hideWrexLines()
                        self.goToWrex(wrexNumber)
                    }
                    else {
                        self.flipButton.enabled = false
                      
                        self.delay(0.5) {
                            self.goToWrex(wrexNumber)
                            self.hideWrexLines()
                            self.flipButton.enabled = true
                        }
                    }
                }
            }
            
        }
    }
    
    
    private func recordCoinTossResult(coinTossResults: [Coin.CoinSide]) {
        
        let headCount = coinTossResults.filter{$0 == Coin.CoinSide.HEADS}.count
        
        if headCount >= 2 {
            hexNum += "1"
        }
        else {
            hexNum += "2"
        }
        
        guard let wrexLineImage = getWrexLineForResults(coinTossResults) else { return }
        
        switch tosses {
            case 1 :  wrexLine1.image = wrexLineImage ; fadeInWrexagramLine(wrexLine1)
            case 2 :  wrexLine2.image = wrexLineImage ; fadeInWrexagramLine(wrexLine2)
            case 3 :  wrexLine3.image = wrexLineImage ; fadeInWrexagramLine(wrexLine3)
            case 4 :  wrexLine4.image = wrexLineImage ; fadeInWrexagramLine(wrexLine4)
            case 5 :  wrexLine5.image = wrexLineImage ; fadeInWrexagramLine(wrexLine5)
            default : wrexLine6.image = wrexLineImage ; fadeInWrexagramLine(wrexLine6)
        }
    }
    
    private func fadeInWrexagramLine(wrexLine: UIImageView) {
        let transition: UIViewAnimationOptions
        let duration: NSTimeInterval
        
        if animationRandomFactor.isEven() {
            transition = .TransitionCurlUp
            duration = 0.4
        }
        else {
            transition = .TransitionCurlDown
            duration = 0.3
        }
        
        AromaClient.beginWithTitle("Showing Wrex Line")
            .withPriority(.LOW)
            .addBody("Line \(tosses)")
            .send()
        
        UIView.transitionWithView(wrexLine, duration: duration, options: transition, animations: { wrexLine.hidden = false }, completion: nil)
    }
}
