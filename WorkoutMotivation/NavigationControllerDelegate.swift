//
//  NavigationControllerDelegate.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 6/12/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    @IBOutlet weak var navigationController: UINavigationController!
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //var panGesture = UIPanGestureRecognizer(target: self, action: Selector("panned:"))
        //self.navigationController!.view.addGestureRecognizer(panGesture)
        navigationController.navigationBar.clipsToBounds = true
    }
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimateTransition()
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }
}
