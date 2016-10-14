//
//  InteractiveModalViewTransition.swift
//  Slowmo
//
//  Created by ltebean on 16/4/14.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit

open class InteractiveModalViewTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var transition: InteractiveModalViewTransition!
    var reversedTransition: UIViewControllerAnimatedTransitioning!
    var interactivePopTransition: UIPercentDrivenInteractiveTransition?
    
    fileprivate var isDragging = false
    open var thresholdContentOffsetY: CGFloat = 0
    fileprivate var previousContentOffsetY: CGFloat = 0
    
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = InteractiveModalViewTransition(duration: 0.5)
        return transition
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        reversedTransition = InteractiveModalViewReversedTransition(duration: 0.25)
        return reversedTransition
    }
    
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactivePopTransition
    }
    
    open func handlePanInScrollView(_ scrollView: UIScrollView, thresholdContentOffsetY: CGFloat) {
        self.thresholdContentOffsetY = thresholdContentOffsetY
        scrollView.delegate = self
    }
    
}

extension InteractiveModalViewTransitionDelegate: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if isDragging {
            if y <= thresholdContentOffsetY {
                transition.handlePan(scrollView.panGestureRecognizer)
                scrollView.transform = CGAffineTransform(translationX: 0, y: (y - thresholdContentOffsetY))
            } else {
                if y >= previousContentOffsetY {
                    transition.handlePan(scrollView.panGestureRecognizer)
                }
                scrollView.transform = CGAffineTransform.identity
            }
        }
        previousContentOffsetY = y
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
        previousContentOffsetY = scrollView.contentOffset.y
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        transition.handlePan(scrollView.panGestureRecognizer)
        scrollView.transform = CGAffineTransform.identity
        isDragging = false
    }
}


open class InteractiveModalViewTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval
    let screenHeight = UIScreen.main.bounds.size.height
    weak var toVC: UIViewController?
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let sourceView = fromVC.view
        let destinationView = toVC.view
        let containerView = transitionContext.containerView
        
        containerView.addSubview(destinationView!)
        
        self.toVC = toVC
//        let panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
//        if let vc = toVC as? UINavigationController {
//            if !(vc.topViewController is UITableViewController) {
//                vc.topViewController?.view.addGestureRecognizer(panGesture)
//            }
//        } else {
//            if !(toVC is UITableViewController) {
//                toVC.view.addGestureRecognizer(panGesture)
//            }
//        }
        
        destinationView?.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            sourceView?.alpha = 0.2
            sourceView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            destinationView?.transform = CGAffineTransform(translationX: 0, y: 0)
            
            },
            completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
    
    open func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translationY = recognizer.translation(in: recognizer.view).y
        
        let progress = min(1.0, max(0.0, translationY / screenHeight))
        
        let transitionDelegate = toVC?.transitioningDelegate as! InteractiveModalViewTransitionDelegate
        
        func begin() {
            transitionDelegate.interactivePopTransition = UIPercentDrivenInteractiveTransition()
            toVC?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
        if recognizer.state == .began {
            if translationY > 0 {
                begin()
            }
        }
            
        else if recognizer.state == .changed {
            if translationY > 0 && transitionDelegate.interactivePopTransition == nil {
                begin()
            }
            transitionDelegate.interactivePopTransition?.update(progress)
        }
            
        else if recognizer.state == .ended || recognizer.state == .cancelled {
            if progress >= 0.3 {
                transitionDelegate.interactivePopTransition?.finish()
            } else {
                transitionDelegate.interactivePopTransition?.cancel()
            }
            transitionDelegate.interactivePopTransition = nil
        }
    }
}


class InteractiveModalViewReversedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval
    let screenHeight = UIScreen.main.bounds.size.height
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let sourceView = fromVC.view
        let destinationView = toVC.view
        let containerView = transitionContext.containerView
        
        containerView.addSubview(destinationView!)
        containerView.bringSubview(toFront: sourceView!)
        
        sourceView?.alpha = 1
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear],
            animations: {
                sourceView?.transform = CGAffineTransform(translationX: 0, y: self.screenHeight)
                destinationView?.transform = CGAffineTransform.identity
                destinationView?.alpha = 1
            },
            completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}

