//
//  HomeTransition.swift
//  Todotrix
//
//  Created by leo on 16/7/5.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit

protocol SharedViewTransition {
    func sharedView(isPush isPush: Bool) -> UIView?
    func requiredBackgroundColor() -> UIColor?
}

class TransitionDelegate: NSObject, UINavigationControllerDelegate {
    
    var interactiveTransition: UIPercentDrivenInteractiveTransition?
    let transition: Transition
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.transition = Transition(navigationController: navigationController)
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.push = operation == UINavigationControllerOperation.Push
        transition.delegate = self
        return transition
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
}

class Transition: NSObject, UIViewControllerAnimatedTransitioning, UIGestureRecognizerDelegate {
    
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var push = true
    weak var delegate: TransitionDelegate!
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let sourceVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let destinationVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let sourceView = sourceVC.view
        let destinationView = destinationVC.view
        let containerView = transitionContext.containerView()
        
        let duration = transitionDuration(transitionContext)
        
        
        let height = UIScreen.mainScreen().bounds.height
        
        containerView.addSubview(destinationView)
        destinationView.layoutIfNeeded()
        
        if (push) {
            destinationView.transform.ty = height
            handleBack(destinationView)
        } else {
            destinationView.transform.ty = -height
        }
        

        let sourceTransition = sourceVC as! SharedViewTransition
        let destinationTransition = destinationVC as! SharedViewTransition
        
        let sharedSourceView = sourceTransition.sharedView(isPush: push)
        let sharedDestinationView = destinationTransition.sharedView(isPush: !push)
        
        let needsAnimation = sharedSourceView != nil && sharedDestinationView != nil
        
        var snapshotView: UIView?
        if needsAnimation {
            snapshotView = sharedSourceView!.snapshotViewAfterScreenUpdates(false)
            snapshotView!.center = containerView.convertPoint(sharedSourceView!.center, fromView: sharedSourceView!.superview)
            snapshotView!.translatesAutoresizingMaskIntoConstraints = true
            sharedSourceView!.hidden = true
            
            sharedDestinationView!.hidden = true
            containerView.addSubview(snapshotView!)
        }
        
        let sourceBackgroundColor = sourceTransition.requiredBackgroundColor()
        let destinationBackgroundColor = destinationTransition.requiredBackgroundColor()

        let needsBGTransition = (sourceBackgroundColor != nil) && (destinationBackgroundColor != nil)
        
        if needsBGTransition {
            destinationView.backgroundColor = sourceBackgroundColor
        }

        
        UIView.animateWithDuration(duration, delay: 0, options: [], animations: {

            if (self.push) {
                sourceView.transform.ty = -height
                destinationView.transform.ty = 0
            } else {
                sourceView.transform.ty = height
                destinationView.transform.ty = 0
            }
            if needsAnimation {
                snapshotView!.center = containerView.convertPoint(sharedDestinationView!.center, fromView: sharedDestinationView!.superview)
            }
            
            if needsBGTransition {
                sourceView.backgroundColor = destinationBackgroundColor!
                destinationView.backgroundColor = destinationBackgroundColor!
            }
            containerView.layoutIfNeeded()
            
        }, completion: { finished in
                
            sourceView.transform = CGAffineTransformIdentity
            destinationView.transform = CGAffineTransformIdentity
            
            if needsBGTransition {
                sourceView.backgroundColor = sourceBackgroundColor!
            }

            if needsAnimation {
                sharedSourceView!.hidden = false
                sharedDestinationView!.hidden = false
                snapshotView!.removeFromSuperview()
            }

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
        
    }
    
    func handleBack(view: UIView) {
        let gesture = PanDirectionGestureRecognizer(direction: .Vertical, target: self, action: #selector(Transition.handlePan))
        //        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    func handlePan(gesture: UIPanGestureRecognizer) {
        let progress = gesture.translationInView(gesture.view).y / UIScreen.mainScreen().bounds.height
        
        if gesture.state == .Began {
            delegate.interactiveTransition = UIPercentDrivenInteractiveTransition()
            navigationController.popViewControllerAnimated(true)
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
