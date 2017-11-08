//
//  BaseViewController.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/11.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper
import DZNEmptyDataSet

class BaseViewController: UIViewController {
    let disposeBag: DisposeBag = DisposeBag()
    lazy var emptyContainerView = EmptyView()
    lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        return taleView
    }()
    
    fileprivate lazy  var backBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "login_back"), for: .normal)
        return loginBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackBarButton()
        setupEmptyView()

    }
    
    deinit {
        debugPrint("ViewController deinit")
    }
    
    func setBackBarButton() {
        let image = UIImage(named: "navigation_back")
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        let backBarItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarItem
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
      
    }
    
    func whenHiddenNavigationBarSetupBackBtn() {
         navigationController?.setNavigationBarHidden(true, animated: true)
         view.addSubview(backBtn)
        backBtn.rx.tap.subscribe(onNext: {[weak self]_ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        backBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(13)
            maker.top.equalTo(28 + 10)
        }
    }
    
    func setupEmptyView() {
        emptyContainerView.isHidden = true
        view.addSubview(emptyContainerView)
        emptyContainerView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
    }
}
