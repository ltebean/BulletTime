//
//  InteractiveModalViewTransition.swift
//  Slowmo
//
//  Created by ltebean on 16/4/14.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit

public class InteractiveModalViewTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var transition: InteractiveModalViewTransition!
    var reversedTransition: UIViewControllerAnimatedTransitioning!
    var interactivePopTransition: UIPercentDrivenInteractiveTransition?
    
    private var isDragging = false
    public var thresholdContentOffsetY: CGFloat = 0
    private var previousContentOffsetY: CGFloat = 0
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = InteractiveModalViewTransition(duration: 0.5)
        return transition
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        reversedTransition = InteractiveModalViewReversedTransition(duration: 0.25)
        return reversedTransition
    }
    
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactivePopTransition
    }
    
    public func handlePanInScrollView(scrollView: UIScrollView, thresholdContentOffsetY: CGFloat) {
        self.thresholdContentOffsetY = thresholdContentOffsetY
        scrollView.delegate = self
    }
    
}

extension InteractiveModalViewTransitionDelegate: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if isDragging {
            if y <= thresholdContentOffsetY {
                transition.handlePan(scrollView.panGestureRecognizer)
                scrollView.transform = CGAffineTransformMakeTranslation(0, (y - thresholdContentOffsetY))
            } else {
                if y >= previousContentOffsetY {
                    transition.handlePan(scrollView.panGestureRecognizer)
                }
                scrollView.transform = CGAffineTransformIdentity
            }
        }
        previousContentOffsetY = y
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isDragging = true
        previousContentOffsetY = scrollView.contentOffset.y
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        transition.handlePan(scrollView.panGestureRecognizer)
        scrollView.transform = CGAffineTransformIdentity
        isDragging = false
    }
}


public class InteractiveModalViewTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: NSTimeInterval
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    weak var toVC: UIViewController?
    
    init(duration: NSTimeInterval) {
        self.duration = duration
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let sourceView = fromVC.view
        let destinationView = toVC.view
        let containerView = transitionContext.containerView()!
        
        containerView.addSubview(destinationView)
        
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
        
        destinationView.transform = CGAffineTransformMakeTranslation(0, screenHeight)
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            sourceView.alpha = 0.2
            sourceView.transform = CGAffineTransformMakeScale(0.8, 0.8)
            destinationView.transform = CGAffineTransformMakeTranslation(0, 0)
            
            },
            completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
        )
    }
    
    public func handlePan(recognizer: UIPanGestureRecognizer) {
        let translationY = recognizer.translationInView(recognizer.view).y
        
        let progress = min(1.0, max(0.0, translationY / screenHeight))
        
        let transitionDelegate = toVC?.transitioningDelegate as! InteractiveModalViewTransitionDelegate
        
        func begin() {
            transitionDelegate.interactivePopTransition = UIPercentDrivenInteractiveTransition()
            toVC?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        
        if recognizer.state == .Began {
            if translationY > 0 {
                begin()
            }
        }
            
        else if recognizer.state == .Changed {
            if translationY > 0 && transitionDelegate.interactivePopTransition == nil {
                begin()
            }
            transitionDelegate.interactivePopTransition?.updateInteractiveTransition(progress)
        }
            
        else if recognizer.state == .Ended || recognizer.state == .Cancelled {
            if progress >= 0.3 {
                transitionDelegate.interactivePopTransition?.finishInteractiveTransition()
            } else {
                transitionDelegate.interactivePopTransition?.cancelInteractiveTransition()
            }
            transitionDelegate.interactivePopTransition = nil
        }
    }
}


class InteractiveModalViewReversedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: NSTimeInterval
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    
    init(duration: NSTimeInterval) {
        self.duration = duration
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let sourceView = fromVC.view
        let destinationView = toVC.view
        let containerView = transitionContext.containerView()!
        
        containerView.addSubview(destinationView)
        containerView.bringSubviewToFront(sourceView)
        
        sourceView.alpha = 1
        
        UIView.animateWithDuration(duration, delay: 0, options: [.CurveLinear],
            animations: {
                sourceView.transform = CGAffineTransformMakeTranslation(0, self.screenHeight)
                destinationView.transform = CGAffineTransformIdentity
                destinationView.alpha = 1
            },
            completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
        )
    }
}

