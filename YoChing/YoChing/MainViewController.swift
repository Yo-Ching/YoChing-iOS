//
//  ViewController.swift
//  CoinToss
//
//  Created by main on 10/01/15.
//  Copyright (c) 2015 Marc Risney. All rights reserved.
//

import AromaSwiftClient
import UIKit
import QuartzCore

class MainViewController: UIViewController {
                            
    @IBOutlet weak var coinOneImage: UIImageView!
    @IBOutlet weak var coinTwoImage: UIImageView!
    @IBOutlet weak var coinThreeImage: UIImageView!
    
    private var coinOne: Coin!
    private var coinTwo: Coin!
    private var coinThree: Coin!
    
    private var maxTosses = 1
    private var tosses  = 0
    private var hexNum = ""
    
    private var coinsInTheAir = 0
    private let main = NSOperationQueue.mainQueue()
    private let async = NSOperationQueue()
    
    @IBOutlet weak private var flipButton: UIButton!
    
    private let transition = AnimateLeft()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        coinOne = Coin(image: coinOneImage)
        coinTwo = Coin(image: coinTwoImage)
        coinThree = Coin(image: coinThreeImage)
        
        async.maxConcurrentOperationCount = 1
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
         self.maxTosses = Settings.isClassicEnabled ? 6 : 1
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            self.flipCoinAction(NSNull)
        }
    }
  
    @IBAction func flipCoinAction(sender: AnyObject) {
        
        flipButton.enabled = false
        
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
                    } else {
                        let hexNumber = Int(self.hexNum) ?? 111111
                        outcome  = WrexagramLibrary.getOutcome(hexNumber)
                    }
                    
                    defer {
                        AromaClient.begin().withTitle("Coins Flipped")
                            .withBody("Result: \(outcome)\n\nFrom: \(UIDevice.currentDevice().name)")
                            .send()
                    }
                    
                    let wrexNumber = Int(outcome.stringByReplacingOccurrencesOfString("wrexagram", withString: "")) ?? 01
                    self.goToWrex(wrexNumber)
                }
            }
               
        }
    }
    
    private func randomDouble(lower: Double = 0.0, _ upper: Double = 0.35) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
    
    
    private func randomWrexagram() -> String {
        let randomNum = Int(arc4random_uniform(63) + 1)
        let wrex = String(format: "wrexagram%02d", randomNum)
        return wrex
    }
    
    private func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    
    private func recordCoinTossResult(coinTossResults: [Coin.CoinSide]) {
        
        let headCount = coinTossResults.filter{$0 == Coin.CoinSide.HEADS}.count
        (headCount >= 2) ? (hexNum += "2") : (hexNum += "1")

    }
    

}

//MARK: Segues
extension MainViewController {
    
    @IBAction func onGoToNext(sender: AnyObject) {
        self.performSegueWithIdentifier("ToCoinResults", sender: sender)
    }
    
    private func goToWrex(outcome: Int) {
        self.performSegueWithIdentifier("ToWrexagram", sender: outcome)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let wrexegramView = segue.destinationViewController as? WrexagramViewController {
            if let outcome = sender as? Int {
                print("transitioning to wrexagram with outcome \(outcome)")
                wrexegramView.wrexagramNumber = outcome
            }
        }
        
        if let settings = segue.destinationViewController as? SettingsViewController {
            settings.transitioningDelegate = self.transition
        }
        
    }
    
    
    @IBAction func unwindFromSettings(segue: UIStoryboardSegue) {
        print("Unwinding")
    }
}
