//
//  LeftAnimation.swift
//  YoChing
//
//  Created by SirWellington on 4/11/16.
//  Copyright © 2016 Yo Ching. All rights reserved.
//

import Foundation
import UIKit

class AnimateLeft : NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    fileprivate var isPresenting = true
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from),
              let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        else { return }
        
        let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        
        toView.transform = offScreenRight
        
        
        container.addSubview(toView)
        container.addSubview(fromView)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        if isPresenting {
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions(),
                                       animations: {
                                        fromView.transform = offScreenRight
                                        toView.transform = CGAffineTransform.identity
                },
                                       completion: { finished in
                                        transitionContext.completeTransition(true)
            })
        }
        else {
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions(),
                                       animations: {
                                        fromView.transform = offScreenLeft
                                        toView.transform = CGAffineTransform.identity
                },
                                       completion: { finished in
                                        transitionContext.completeTransition(true)
            })
            
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        return self
    }
}


class AnimateRight: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    fileprivate var isPresenting = true

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let container = transitionContext.containerView

        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from),
              let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        else { return }

        let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        
        toView.transform = isPresenting ? offScreenRight : offScreenLeft

        if isPresenting {
            container.addSubview(toView)
            container.addSubview(fromView)
        }
        else {
            container.addSubview(fromView)
            container.addSubview(toView)
        }

        let duration = self.transitionDuration(using: transitionContext)

        if isPresenting {
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions(),
                animations: {
                    fromView.transform = offScreenLeft
                    toView.transform = CGAffineTransform.identity
                },
                completion: { finished in
                    transitionContext.completeTransition(true)
            })
        }
        else {

            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions(),
                animations: {
                    fromView.transform = offScreenRight
                    toView.transform = CGAffineTransform.identity
                },
                completion: { finished in
                    transitionContext.completeTransition(true)
            })
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        return self
    }
}
