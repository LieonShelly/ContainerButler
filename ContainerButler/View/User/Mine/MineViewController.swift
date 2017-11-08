//
//  MineViewController.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MineViewController: BaseViewController {
    fileprivate lazy var  datas: [String] = ["用户", "密码", "退出登录"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

extension MineViewController {
    fileprivate func setupUI() {
        title = "我的"
        tableView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        tableView.register(TitleLabelTableViewCell.self, forCellReuseIdentifier: "TitleLabelTableViewCell")
        tableView.register(UserHeaderCell.self, forCellReuseIdentifier: "UserHeaderCell")
        tableView.register(CenterLabelTableViewCell.self, forCellReuseIdentifier: "CenterLabelTableViewCell")
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
    }
}

extension MineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = datas[indexPath.row]
        if  title == "用户" {
            let cell: UserHeaderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.userLog.image = UIImage(named: "logo")
            cell.titleLabel.text = title + ": " + (CoreDataManager.sharedInstance.getUserInfo()?.phoneNum ?? "9527")
            cell.isUserInteractionEnabled = false
            return cell
        } else if title == "密码" {
            let cell: TitleLabelTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.titleLabel.text = title
             return cell
        } else if title == "退出登录" {
            let cell: CenterLabelTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
             cell.centerLabel.text = title
            return cell
        }
        return UITableViewCell()
    }
}

extension MineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let title = datas[indexPath.row]
        if  title == "用户" {
            
        } else if title == "密码" {
           navigationController?.pushViewController(UpdatePasswordVC(), animated: true)
        } else if title == "退出登录" {
            HUD.hideLoading()
            let rootVC = NavigationController(rootViewController: LoginViewController())
            UIView.transition(with: self.view, duration: 0.25, options: .curveEaseInOut, animations: { [weak self] in
               guard let weakSelf = self else { return }
                CoreDataManager.sharedInstance.clearSessionInfo()
                weakSelf.view.removeFromSuperview()
                UIApplication.shared.keyWindow?.addSubview(rootVC.view)
            }, completion: { _ in
                UIApplication.shared.keyWindow?.rootViewController = rootVC
            })
        }
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let title = datas[indexPath.row]
        if  title == "用户" {
            return 100
        } else if title == "密码" {
            return 45
        } else if title == "退出登录" {
            return 45
        }
        return 45
    }
}
