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
        return UIColor.white
    }
}


class ViewTransitionDelegate: NSObject, UINavigationControllerDelegate {
    
    let transition: ViewTransition
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.transition = ViewTransition(navigationController: navigationController)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.push = operation == UINavigationControllerOperation.push
        return transition
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}

class ViewTransition: NSObject, UIViewControllerAnimatedTransitioning, UIGestureRecognizerDelegate {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var push = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)! 
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let fromView = fromVC.view
        let toView = toVC.view
        let containerView = transitionContext.containerView

        let duration = transitionDuration(using: transitionContext) / 2
        
        if (push) {
            handleBack(toVC)
        }
        
        let fromAnimatable = fromVC as! AnimatableViewController
        let toAnimatable = toVC as! AnimatableViewController

        let fromViews = fromAnimatable.viewsToAnimate()
        let toViews = toAnimatable.viewsToAnimate()

        UIView.animate(withDuration: duration,  delay: 0, options: [.curveEaseOut], animations: {
            fromViews.forEach {
                $0.alpha = 0
                $0.transform.ty = self.push ? -60 : 60
            }
            fromView?.backgroundColor = toAnimatable.backgroundColor()
        }, completion: { finished in
            fromViews.forEach {
                $0.alpha = 1
                $0.transform.ty = 0
            }
            fromView?.backgroundColor = fromAnimatable.backgroundColor()
            
            containerView.addSubview(toView!)
            
            toViews.forEach {
                $0.alpha = 0
                $0.transform.ty = self.push ? 60 : -60
            }
            
            UIView.animate(withDuration: duration,  delay: 0, options: [.curveEaseOut], animations: {
                toViews.forEach {
                    $0.alpha = 1
                    $0.transform.ty = 0
                }
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        })
    }
    
    func handleBack(_ vc: UIViewController) {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewTransition.handleSwipe))
        gesture.direction = .down
        vc.view.addGestureRecognizer(gesture)
    }
    
    func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            let vc = navigationController.topViewController!
            vc.pop()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
