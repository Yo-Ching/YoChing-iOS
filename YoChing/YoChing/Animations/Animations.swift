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
    
    private var isPresenting = true
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()
        
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
              let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        else { return }
        
        let offScreenRight = CGAffineTransformMakeTranslation(container.frame.width, 0)
        let offScreenLeft = CGAffineTransformMakeTranslation(-container.frame.width, 0)
        
        toView.transform = offScreenRight
        
        
        container.addSubview(toView)
        container.addSubview(fromView)
        
        let duration = self.transitionDuration(transitionContext)
        
        if isPresenting {
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .TransitionNone,
                                       animations: {
                                        fromView.transform = offScreenRight
                                        toView.transform = CGAffineTransformIdentity
                },
                                       completion: { finished in
                                        transitionContext.completeTransition(true)
            })
        }
        else {
            
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .TransitionNone,
                                       animations: {
                                        fromView.transform = offScreenLeft
                                        toView.transform = CGAffineTransformIdentity
                },
                                       completion: { finished in
                                        transitionContext.completeTransition(true)
            })
            
        }
        
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        return self
    }
}


class AnimateRight: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    private var isPresenting = true

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        let container = transitionContext.containerView()

        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
              let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        else { return }

        let offScreenRight = CGAffineTransformMakeTranslation(container.frame.width, 0)
        let offScreenLeft = CGAffineTransformMakeTranslation(-container.frame.width, 0)
        
        toView.transform = isPresenting ? offScreenRight : offScreenLeft

        if isPresenting {
            container.addSubview(toView)
            container.addSubview(fromView)
        }
        else {
            container.addSubview(fromView)
            container.addSubview(toView)
        }

        let duration = self.transitionDuration(transitionContext)

        if isPresenting {
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .TransitionNone,
                animations: {
                    fromView.transform = offScreenLeft
                    toView.transform = CGAffineTransformIdentity
                },
                completion: { finished in
                    transitionContext.completeTransition(true)
            })
        }
        else {

            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .TransitionNone,
                animations: {
                    fromView.transform = offScreenRight
                    toView.transform = CGAffineTransformIdentity
                },
                completion: { finished in
                    transitionContext.completeTransition(true)
            })
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        return self
    }
}
