//
//  AnimateTransition.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 6/12/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit

class AnimateTransition: NSObject, UIViewControllerAnimatedTransitioning {
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    var first = true
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5;
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        var containerView = transitionContext.containerView()
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MotivateVC
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! PicUpload
        var button = fromViewController.filterBtn
        //if first {
           // var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MotivateVC
           // var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! PicUpload
           // var button = fromViewController.filterBtn
//        } else { // second time
//            var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! PicUpload
//            var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! MotivateVC
//            var button = fromViewController.navigationController?.navigationBar.backItem
//        }
    
        containerView.addSubview(toViewController.view)
        
        var circleMaskPathInitial = UIBezierPath(ovalInRect: button.frame)
        var extremePoint = CGPoint(x: button.center.x - 0, y: button.center.y - CGRectGetHeight(toViewController.view.bounds))
        var radius = sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y))
        var circleMaskPathFinal = UIBezierPath(ovalInRect: CGRectInset(button.frame, -radius, -radius))
        
        var maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.CGPath
        toViewController.view.layer.mask = maskLayer
        
        var maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = circleMaskPathInitial.CGPath
        maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
        maskLayerAnimation.duration = self.transitionDuration(transitionContext)
        maskLayerAnimation.delegate = self
        maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
        if first {
            first = false
        } else {
            first = true
        }
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
        self.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
    }
    
}
