//
//  NavigationController.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/12.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    fileprivate lazy  var panGes = UIPanGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        addPopbackGesture()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.isEmpty == false {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    func addPopbackGesture() {
        guard let systemGes = interactivePopGestureRecognizer else { return }
        guard let gesView = systemGes.view else { return }
        let targets = systemGes.value(forKey: "_targets") as? [NSObject]
        guard let targetObjc = targets?.first else { return }
        guard let target = targetObjc.value(forKey: "target") else { return }
        let action = Selector(("handleNavigationTransition:"))
        let panGes = UIPanGestureRecognizer()
        gesView.addGestureRecognizer(panGes)
        panGes.addTarget(target, action: action)
        panGes.delegate = self
        self.panGes = panGes
    }
    
    func reomvePopbackGesture() {
        guard let systemGes = interactivePopGestureRecognizer else { return }
        guard let gesView = systemGes.view else { return }
        gesView.removeGestureRecognizer(panGes)
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count == 1 {
            return false
        }
        return true
    }
}
