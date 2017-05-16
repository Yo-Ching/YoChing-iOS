//
//  Coin.swift
//  YoChing
//
//  Created by SirWellington on 3/31/16.
//  Copyright © 2016 Yo Ching. All rights reserved.
//

import Archeota
import Foundation
import QuartzCore
import UIKit

let kMAX_REPS_QUICK = 5
let kMAX_REPS_SLOW = 10
let kSLOW_ANIMATION: Double = 0.4
let kQUICK_ANIMATION: Double = 0.10

class Coin {
    
    weak var image: UIImageView?
    
    fileprivate var repeatCount = 0
    fileprivate var animationDuration = kQUICK_ANIMATION
    fileprivate var maxReps = kMAX_REPS_QUICK
    
    fileprivate var onDone: ((CoinSide) -> Void)?
    
    enum CoinSide {
        case heads
        case tails
    }
    
    init(image: UIImageView) {
        self.image = image
    }

    func doAnimation() {
        
        guard let image = image else { return }
        
        if repeatCount > maxReps  { //This means we're done
            
            let possibleSides = [CoinSide.heads, CoinSide.tails]
            let resultingSide = possibleSides.selectOne() ?? .heads
            
            image.layer.contents =  resultingSide == .heads ? Coin.headsCoin.cgImage : Coin.tailsCoin.cgImage
            image.layer.transform = CATransform3DIdentity

            onDone?(resultingSide)
            
            return
        }
        repeatCount += 1
        
        if repeatCount == 1 {					// first time for this animation
            let duration: Double = (animationDuration * Double((maxReps+1)))
            let startFrame = image.frame
            UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                var frame = image.frame
                
                frame.origin.y = 90.0
                image.frame = frame
                }, completion: {
                    _ in
                    
                    UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                        
                        image.frame = startFrame
                        }, completion: nil)
            })
        }
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { [weak self] in
            
            guard self != nil else { return }
            
            var rotation = CATransform3DIdentity
            rotation = CATransform3DRotate(rotation, CGFloat(Double.pi / 2), 1.0, 0.0, 0.0)
            image.layer.transform = rotation
            
            }, completion: {
                _ in
                
                image.layer.contents = Coin.tailsCoin.cgImage
                UIView.animate(withDuration: self.animationDuration, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                    
                    var rotation = image.layer.transform
                    
                    rotation = CATransform3DRotate(rotation, CGFloat(Double.pi), 1.0, 0.0, 0.0)
                    image.layer.transform = rotation;
                    }, completion: {
                        _ in
                        
                        image.layer.contents = Coin.headsCoin.cgImage
                        self.doAnimation()
                })
        })
    }
    
    
    func flipCoinAction(_ onDone: @escaping (CoinSide) -> Void) {
        
        LOG.debug("Flip Coin called")
        
        guard let image = self.image else {
            LOG.warn("Coin Missing Image")
            return
        }
        
        self.repeatCount = 0
        self.onDone = onDone
        
        image.layer.removeAllAnimations()
        image.layer.contents = Coin.headsCoin.cgImage
        doAnimation()
    }
}

extension Coin {
    
    static var headsCoin: UIImage {
        let name = Settings.isSlickEnabled ? "Coins.Slick.Heads" : "Coin_Heads"
        return UIImage(named: name) ?? UIImage()
    }
    
    static var tailsCoin: UIImage {
        let name = Settings.isSlickEnabled ? "Coins.Slick.Tails" : "Coin_Tails"
        return UIImage(named: name) ?? UIImage()
    }
    
}
