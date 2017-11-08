//
//  TransmationAnimator.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/20.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import pop

class PopoverPresentationController: UIPresentationController {
    var presentFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func containerViewWillLayoutSubviews() {
        if presentFrame == CGRect(x: 0, y: 0, width: 0, height: 0) {
            presentedView?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        } else {
            presentedView?.frame = presentFrame
        }
        containerView?.insertSubview(coverView, at: 0)
    }
    
    fileprivate lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.main.bounds
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.close))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    @objc func close() {
        //        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

class TransitionAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    var isPresent: Bool = false
    var presentFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let pc = PopoverPresentationController(presentedViewController: presented, presenting: presenting)
        pc.presentFrame = presentFrame
        return pc
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            if let toView = transitionContext.view(forKey: UITransitionContextViewKey.to), let
            positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY), let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY) {
                transitionContext.containerView.addSubview(toView)
                positionAnimation.toValue = transitionContext.containerView.center.y
                positionAnimation.springBounciness = 10
                positionAnimation.completionBlock = { _, _ in
                    transitionContext.completeTransition(true)
                    
                }
                scaleAnimation.springBounciness = 20
                scaleAnimation.fromValue = NSValue.init(cgPoint: CGPoint(x: 1.2, y: 1.4))
                toView.layer.pop_add(positionAnimation, forKey: "positionAnimation")
                toView.layer.pop_add(scaleAnimation, forKey: "scaleAnimation")
            }
        } else {
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
                fromView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: { (_) -> Void in
                
                transitionContext.completeTransition(true)
            })
        }
    }
    
}
