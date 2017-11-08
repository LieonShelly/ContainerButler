//
//  CenteralContainerVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/24.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Closures

class CenteralContainerVC: BaseViewController {
    var deviceNum: String?
    fileprivate var centralViewModel: CentralContainerViewModel = CentralContainerViewModel()
 
    let items = Variable([
        "音量",
        "货柜重启"
        ])
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navi = navigationController as? NavigationController {
            navi.reomvePopbackGesture()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navi = navigationController as? NavigationController {
            navi.addPopbackGesture()
        }
    }
}

extension CenteralContainerVC {
    fileprivate func setupUI() {
        title = "中控管理"
      tableView = UITableView()
      tableView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
       tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 100000, bottom: 0, right: 0)
        tableView.register(VolumeTableViewCell.self, forCellReuseIdentifier: "VolumeTableViewCell")
        tableView.register(LabelButtonCell.self, forCellReuseIdentifier: "LabelButtonCell")
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
    }
    
    fileprivate func loadData() {
        let param = ContainerSessionParam()
        param.deviceNo = deviceNum
        centralViewModel.getCurrentVolume(param)
            .subscribe(onNext: {[weak self] _ in
                self?.tableView.reloadData()
            }, onError: { (error) in
                if let error = error as? AppError {
                    HUD.showError(error.message)
                }
            }, onCompleted: {
                 HUD.hideLoading()
            }).disposed(by: disposeBag)
    }
}

extension CenteralContainerVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = items.value[indexPath.row]
        if element == "音量" {
            let cell: VolumeTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.slider.value = Float(centralViewModel.currentVolume.value) ?? 0
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cell.slider.on(.touchUpInside, handler: {[unowned self] (_, _) in
                let param = ContainerSessionParam()
                param.volume = "\(Int(cell.slider.value))"
                param.deviceNo = self.deviceNum
                self.centralViewModel.updateAduionVolume(param).subscribe( onError: { (error) in
                    if let error = error as? AppError {
                        HUD.showError(error.message)
                    }
                }).disposed(by: self.disposeBag)
            })
            return cell
        }
        if element == "货柜重启" {
            let cell: LabelButtonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.leftLabel.text = "货柜重启"
            cell.rightBtn.setTitle("重启", for: .normal)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cell.rightBtn.onTap {[weak self] in
                guard let weakSelf = self else { return }
                let param = ContainerSessionParam()
                param.deviceNo = weakSelf.deviceNum
                weakSelf.centralViewModel.rebootDevice(param)
                    .subscribe(onNext: {  _ in
                                HUD.showSuccess("重启成功")
                            },
                        onError: {  (error) in
                            if let error = error as? AppError {
                                HUD.showError(error.message)
                            }
                }).disposed(by: weakSelf.disposeBag)
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension CenteralContainerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
