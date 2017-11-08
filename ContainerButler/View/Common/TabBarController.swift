//
//  TabBarController.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/12.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension TabBarController {
    
    fileprivate func setupUI() {
        add(childVC: ContainerViewController(), title: "货柜", normalImageName: "container_grey", selectedImageName: "container")
        add(childVC: MessageHomeVC(), title: "消息", normalImageName: "news", selectedImageName: "news_grey")
        add(childVC: MineViewController(), title: "我的", normalImageName: "my_grey", selectedImageName: "my")
    }
    
    fileprivate func add(childVC: UIViewController,
                         title: String?,
                         normalImageName: String,
                         selectedImageName: String) {
        let navi = NavigationController(rootViewController: childVC)
        navi.title = title
        navi.tabBarItem = UITabBarItem(title: title, image: UIImage(named: normalImageName), selectedImage: UIImage(named: selectedImageName))
        addChildViewController(navi)
    }
}
