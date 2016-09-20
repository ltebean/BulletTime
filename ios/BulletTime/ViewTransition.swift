//
//  HomeTransition.swift
//  Todotrix
//
//  Created by leo on 16/7/5.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit
import Async

class AnimatableViewController: UIViewController {
    
    var isPush = false
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        let views = viewsToAnimate()
//        UIView.animateWithDuration(0.3, delay: 0, options: [.CurveEaseOut], animations: {
//            views.forEach {
//                $0.alpha = 1
//                $0.transform.ty = 0
//            }
//            self.view.backgroundColor = self.backgroundColor()
//        }, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    func viewsToAnimate() -> [UIView] {
        return []
    }
    
    func backgroundColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    func push(viewController: AnimatableViewController) {
        let views = viewsToAnimate()
        UIView.animateWithDuration(0.35,  delay: 0, options: [.CurveEaseOut], animations: {
            views.forEach {
                $0.alpha = 0
                $0.transform.ty = -60
            }
            self.view.backgroundColor = viewController.backgroundColor()
        }, completion: { finished in
            views.forEach {
                $0.alpha = 1
                $0.transform.ty = 0
            }
            self.view.backgroundColor = self.backgroundColor()
            self.navigationController?.pushViewController(viewController, animated: true)
        })
   
    }
    
    func pop() {
        let targetVC = navigationController?.viewControllers[(navigationController?.viewControllers.count)! - 2] as! AnimatableViewController
        let views = viewsToAnimate()
        UIView.animateWithDuration(0.35,  delay: 0, options: [.CurveEaseOut], animations: {
            views.forEach {
                $0.alpha = 0
                $0.transform.ty = 60
            }
            self.view.backgroundColor = targetVC.backgroundColor()
        }, completion: { finished in
            self.navigationController?.popViewControllerAnimated(true)
        })
    }

}

class ViewTransitionDelegate: NSObject, UINavigationControllerDelegate {
    
    var interactiveTransition: UIPercentDrivenInteractiveTransition?
    let transition: ViewTransition
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.transition = ViewTransition(navigationController: navigationController)
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.push = operation == UINavigationControllerOperation.Push
        transition.delegate = self
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
    weak var delegate: ViewTransitionDelegate!
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.35
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! as! AnimatableViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as! AnimatableViewController
        fromVC.isPush = push
        toVC.isPush = !push
        
        let toView = toVC.view
        
        let containerView = transitionContext.containerView()
        
        let duration = transitionDuration(transitionContext)
        
        if (push) {
            handleBack(toVC)
        }
        
        containerView.addSubview(toView)
        
        
        let views = toVC.viewsToAnimate()
        
        views.forEach {
            $0.alpha = 0
            $0.transform.ty = push ? 60 : -60
        }
        UIView.animateWithDuration(duration,  delay: 0, options: [.CurveEaseOut], animations: {
            views.forEach {
                $0.alpha = 1
                $0.transform.ty = 0
            }
        }, completion: { finished in
    
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())

        })
    
        
        
        
    }
    
    func handleBack(vc: AnimatableViewController) {
//        let gesture = PanDirectionGestureRecognizer(direction: .Vertical, target: self, action: #selector(Transition.handlePan))
//        //        gesture.delegate = self
//        vc.view.addGestureRecognizer(gesture)
//        
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewTransition.handleSwipe))
        gesture.direction = .Down
        vc.view.addGestureRecognizer(gesture)
    }
    
    func handleSwipe(gesture: UISwipeGestureRecognizer) {
        if gesture.state == .Ended {
            let vc = navigationController.topViewController as! AnimatableViewController
            vc.pop()
        }
    }
    
    
    func handlePan(gesture: UIPanGestureRecognizer) {
        let progress = gesture.translationInView(gesture.view).y / UIScreen.mainScreen().bounds.height
        
        if gesture.state == .Began {
            delegate.interactiveTransition = UIPercentDrivenInteractiveTransition()
            let vc = navigationController.topViewController as! AnimatableViewController
            vc.pop()
        }
        else if gesture.state == .Changed {
            delegate.interactiveTransition?.updateInteractiveTransition(progress)
        }
        else if gesture.state == .Ended || gesture.state == .Cancelled {
            if progress > 0.3 {
                delegate.interactiveTransition?.finishInteractiveTransition()
            } else {
                delegate.interactiveTransition?.cancelInteractiveTransition()
            }
            delegate.interactiveTransition = nil
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
