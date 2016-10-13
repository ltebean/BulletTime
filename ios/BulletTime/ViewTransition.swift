//
//  HomeTransition.swift
//  Todotrix
//
//  Created by leo on 16/7/5.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit
import Async

protocol AnimatableViewController: class {
    
    func viewsToAnimate() -> [UIView]
    
    func backgroundColor() -> UIColor
}

extension AnimatableViewController {
    
    func viewsToAnimate() -> [UIView] {
        return []
    }
    
    func backgroundColor() -> UIColor {
        return UIColor.whiteColor()
    }
}


class ViewTransitionDelegate: NSObject, UINavigationControllerDelegate {
    
    let transition: ViewTransition
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.transition = ViewTransition(navigationController: navigationController)
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.push = operation == UINavigationControllerOperation.Push
        return transition
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}

class ViewTransition: NSObject, UIViewControllerAnimatedTransitioning, UIGestureRecognizerDelegate {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var push = true
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.7
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! 
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let fromView = fromVC.view
        let toView = toVC.view
        let containerView = transitionContext.containerView()

        let duration = transitionDuration(transitionContext) / 2
        
        if (push) {
            handleBack(toVC)
        }
        
        let fromAnimatable = fromVC as! AnimatableViewController
        let toAnimatable = toVC as! AnimatableViewController

        let fromViews = fromAnimatable.viewsToAnimate()
        let toViews = toAnimatable.viewsToAnimate()

        UIView.animateWithDuration(duration,  delay: 0, options: [.CurveEaseOut], animations: {
            fromViews.forEach {
                $0.alpha = 0
                $0.transform.ty = self.push ? -60 : 60
            }
            fromView.backgroundColor = toAnimatable.backgroundColor()
        }, completion: { finished in
            fromViews.forEach {
                $0.alpha = 1
                $0.transform.ty = 0
            }
            fromView.backgroundColor = fromAnimatable.backgroundColor()
            
            containerView.addSubview(toView)
            
            
            toViews.forEach {
                $0.alpha = 0
                $0.transform.ty = self.push ? 60 : -60
            }
            
            UIView.animateWithDuration(duration,  delay: 0, options: [.CurveEaseOut], animations: {
                toViews.forEach {
                    $0.alpha = 1
                    $0.transform.ty = 0
                }
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })

        })
        
        
    
    }
    
    func handleBack(vc: UIViewController) {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewTransition.handleSwipe))
        gesture.direction = .Down
        vc.view.addGestureRecognizer(gesture)
    }
    
    func handleSwipe(gesture: UISwipeGestureRecognizer) {
        if gesture.state == .Ended {
            let vc = navigationController.topViewController!
            vc.pop()
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
