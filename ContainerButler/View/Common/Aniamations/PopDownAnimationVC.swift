//
//  PopDownAnimationVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/20.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import pop

class PopDownAnimationVC: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewController(forKey: .from)?.view, let toView = transitionContext.viewController(forKey: .to)?.view else { return   }
        fromView.tintAdjustmentMode = .dimmed
        fromView.isUserInteractionEnabled = false
        toView.frame = CGRect(x: 0,
                              y: 0,
                              width: transitionContext.containerView.bounds.width - 100,
                              height: transitionContext.containerView.bounds.height - 280)
        let p = CGPoint(x: transitionContext.containerView.center.x,
                        y: -transitionContext.containerView.center.y)
        toView.center = p
        transitionContext.containerView.addSubview(toView)
        let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        positionAnimation?.toValue = transitionContext.containerView.center.y
        positionAnimation?.springBounciness = 10
        positionAnimation?.completionBlock = { _, _ in
            transitionContext.completeTransition(true)
            
        }
        let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation?.springBounciness = 20
        scaleAnimation?.fromValue = NSValue.init(cgPoint: CGPoint(x: 1.2, y: 1.4))
        if let position = positionAnimation, let scale = scaleAnimation {
            toView.layer.pop_add(position, forKey: "positionAnimation")
            toView.layer.pop_add(scale, forKey: "scaleAnimation")
        }
    }
}

class PopDowanDismissingVC: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewController(forKey: .from)?.view, let toView = transitionContext.viewController(forKey: .to)?.view else { return   }
        toView.tintAdjustmentMode = .dimmed
        toView.isUserInteractionEnabled = true
        
        let closeAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)
        closeAnimation?.toValue = -fromView.layer.position.y
        closeAnimation?.completionBlock = { _, _ in
            transitionContext.completeTransition(true)
            
        }
        let scaleDownAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleDownAnimation?.springBounciness = 20
        scaleDownAnimation?.toValue = NSValue.init(cgPoint: CGPoint(x: 0, y: 0))
        if let close = closeAnimation, let scale = scaleDownAnimation {
            fromView.layer.pop_add(close, forKey: "closeAnimation")
            fromView.layer.pop_add(scale, forKey: "scaleDownAnimation")
        }
    }
}
