//
//  HomeTransition.swift
//  Todotrix
//
//  Created by leo on 16/7/5.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit

protocol SharedViewTransition {
    func sharedView(isPush: Bool) -> UIView?
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
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.push = operation == UINavigationControllerOperation.push
        transition.delegate = self
        return transition
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
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
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let sourceVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let destinationVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let sourceView = sourceVC.view
        let destinationView = destinationVC.view
        let containerView = transitionContext.containerView
        
        let duration = transitionDuration(using: transitionContext)
        
        
        let height = UIScreen.main.bounds.height
        
        containerView.addSubview(destinationView!)
        destinationView?.layoutIfNeeded()
        
        if (push) {
            destinationView?.transform.ty = height
            handleBack(destinationView!)
        } else {
            destinationView?.transform.ty = -height
        }
        

        let sourceTransition = sourceVC as! SharedViewTransition
        let destinationTransition = destinationVC as! SharedViewTransition
        
        let sharedSourceView = sourceTransition.sharedView(isPush: push)
        let sharedDestinationView = destinationTransition.sharedView(isPush: !push)
        
        let needsAnimation = sharedSourceView != nil && sharedDestinationView != nil
        
        var snapshotView: UIView?
        if needsAnimation {
            snapshotView = sharedSourceView!.snapshotView(afterScreenUpdates: false)
            snapshotView!.center = containerView.convert(sharedSourceView!.center, from: sharedSourceView!.superview)
            snapshotView!.translatesAutoresizingMaskIntoConstraints = true
            sharedSourceView!.isHidden = true
            
            sharedDestinationView!.isHidden = true
            containerView.addSubview(snapshotView!)
        }
        
        let sourceBackgroundColor = sourceTransition.requiredBackgroundColor()
        let destinationBackgroundColor = destinationTransition.requiredBackgroundColor()

        let needsBGTransition = (sourceBackgroundColor != nil) && (destinationBackgroundColor != nil)
        
        if needsBGTransition {
            destinationView?.backgroundColor = sourceBackgroundColor
        }

        
        UIView.animate(withDuration: duration, delay: 0, options: [], animations: {

            if (self.push) {
                sourceView?.transform.ty = -height
                destinationView?.transform.ty = 0
            } else {
                sourceView?.transform.ty = height
                destinationView?.transform.ty = 0
            }
            if needsAnimation {
                snapshotView!.center = containerView.convert(sharedDestinationView!.center, from: sharedDestinationView!.superview)
            }
            
            if needsBGTransition {
                sourceView?.backgroundColor = destinationBackgroundColor!
                destinationView?.backgroundColor = destinationBackgroundColor!
            }
            containerView.layoutIfNeeded()
            
        }, completion: { finished in
                
            sourceView?.transform = CGAffineTransform.identity
            destinationView?.transform = CGAffineTransform.identity
            
            if needsBGTransition {
                sourceView?.backgroundColor = sourceBackgroundColor!
            }

            if needsAnimation {
                sharedSourceView!.isHidden = false
                sharedDestinationView!.isHidden = false
                snapshotView!.removeFromSuperview()
            }

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
    }
    
    func handleBack(_ view: UIView) {
        let gesture = PanDirectionGestureRecognizer(direction: .vertical, target: self, action: #selector(Transition.handlePan))
        //        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    func handlePan(_ gesture: UIPanGestureRecognizer) {
        let progress = gesture.translation(in: gesture.view).y / UIScreen.main.bounds.height
        
        if gesture.state == .began {
            delegate.interactiveTransition = UIPercentDrivenInteractiveTransition()
            navigationController.popViewController(animated: true)
        }
        else if gesture.state == .changed {
            delegate.interactiveTransition?.update(progress)
        }
        else if gesture.state == .ended || gesture.state == .cancelled {
            if progress > 0.3 {
                delegate.interactiveTransition?.finish()
            } else {
                delegate.interactiveTransition?.cancel()
            }
            delegate.interactiveTransition = nil
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
