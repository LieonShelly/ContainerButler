//
//  ContainerViewController.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import MJRefresh
import DZNEmptyDataSet

class ContainerViewController: BaseViewController {
    fileprivate lazy var containerVM: ContainerViewModel = ContainerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.containerVM.requestCommand.onNext(true)
    }
}

extension ContainerViewController {
    fileprivate func setupUI() {
        title = "货柜"
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(ContainerTableViewCell.self, forCellReuseIdentifier: "ContainerTableViewCell")
        tableView.register(ContainerSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "ContainerSectionHeaderView")
        view.addSubview(tableView)
        let tableviewHeader = UIView()
        tableviewHeader.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        tableviewHeader.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 12)
        tableView.tableHeaderView = tableviewHeader
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
        let addBtn = UIButton()
        addBtn.setImage(UIImage(named: "add"), for: .normal)
        addBtn.frame = CGRect(x: UIScreen.width - 44, y: 20, width: 44, height: 44)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addBtn)
        addBtn.rx.tap.subscribe(onNext: { [weak self] in
            let point = CGPoint(x:  UIScreen.width - 44 + 12, y: 12 + 44)
            YBPopupMenu.show(at: point, titles: ["待补清单", "补货记录"],
                             icons: ["pending_replenishment_list", "replenishment_record"],
                             menuWidth: 125) { menu in
                menu?.arrowDirection = .top
                menu?.rectCorner = UIRectCorner.bottomRight
                menu?.delegate = self
                menu?.backColor = UIColor(hex: 0x333333)
                menu?.textColor = UIColor.white
                menu?.fontSize = 13
            }
        })
        .disposed(by: disposeBag)
    }
    
    fileprivate func setupRX() {
        tableView.dataSource = self
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        containerVM
            .responseType
            .asObservable()
            .map {$0 == StatusType.networkUnavailable ? false: true}
            .bind(to: emptyContainerView.rx.isHidden)
            .disposed(by: disposeBag)
        
        containerVM
            .responseType
            .asObservable()
            .map {$0 == StatusType.success ? false: true}
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        emptyContainerView.reloadBtn.onTap {[weak self] in
             HUD.showLoading()
             self?.containerVM.requestCommand.onNext(true)
        }
        
        containerVM
            .models
            .asObservable()
            .subscribe(onNext: { [weak self](_) in
                HUD.hideLoading()
                self?.tableView.reloadData()
        })
            .disposed(by: disposeBag)
        
        containerVM
            .totalCount
            .asObservable()
            .subscribe(onNext: { [weak self](value) in
                HUD.hideLoading()
                self?.title = "货柜(\(value))"
            })
            .disposed(by: disposeBag)
        
        containerVM.refreshStatus
            .asObservable()
            .subscribe(onNext: {[weak self] (status) in
            switch status {
            case .beingHeaderRefresh:
                self?.tableView.mj_header.beginRefreshing()
            case .endHeaderRefresh:
                self?.tableView.mj_header.endRefreshing()
            case .beingFooterRefresh:
                self?.tableView.mj_footer.beginRefreshing()
            case .endFooterRefresh:
                self?.tableView.mj_footer.endRefreshing()
            case .noMoreData:
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            default:
                break
            }
        })
            .disposed(by: disposeBag)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[unowned self] in
            self.containerVM.requestCommand.onNext(true)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.containerVM.requestCommand.onNext(false)
        })
    }
}

extension ContainerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
          return containerVM.models.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return containerVM.models.value[section].groups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContainerTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let containers = containerVM.models.value[indexPath.section].groups?[indexPath.row].containers {
            cell.config(containers, index: indexPath.row + 1)
        }
        let scence = containerVM.models.value[indexPath.section]
        
        cell.itemdidSelected = { [weak self] model in
            guard let weakSelf = self else { return }
            if model.isCentralContainer {
                let vcc = CenteralContainerVC()
                vcc.deviceNum = model.number
               weakSelf.navigationController?.pushViewController(vcc, animated: true)
            } else {
                HUD.showAlert(from: weakSelf, title: "花样年华T3优享空间", message: "对\(model.name ?? "")进行补货\n补货时，货柜将暂停服务", enterTitle: "取消", cancleTitle: "开始补货", enterAction: nil, cancleAction: { [weak self] in
                    guard let weakSelf = self else { return }
                    let param = ContainerSessionParam()
                    param.sceneSn = scence.number
                    HUD.showLoading()
                    weakSelf.containerVM.startSupplyGoods(param)
                        .subscribe(onNext: { (resonse) in
                            if let scence = resonse.object, let name = scence.name, !name.isEmpty {
                                HUD.showAlert(from: weakSelf, title: "系统提示", message: "您尚未完成\(name)优享空间的补货，请完成后再对下一个优享空间进行补货", enterTitle: "确定", isHiddenCancleTitle: true, cancleTitle: nil, enterAction: nil, cancleAction: nil)
                            } else {
                                let vcc =  ContainerManageVC()
                                vcc.container = model
                                vcc.currentScence = scence
                                weakSelf.navigationController?.pushViewController(vcc, animated: true)
                            }
                        }, onError: { (error) in
                            if let error = error as? AppError {
                                HUD.showError(error.message)
                            }
                        }, onCompleted: {
                            HUD.hideLoading()
                        }).disposed(by: weakSelf.disposeBag)
                })
            }
        }
        return cell
    }
}
extension ContainerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ContainerSectionHeaderView = tableView.dequeueReusableHeaderFooter()
        let scence = containerVM.models.value[section]
        headerView.config(scence)
        headerView.listTapAction = {[unowned self] model in
            let param = ContainerSessionParam()
            param.sceneSn = scence.number
            HUD.showLoading()
            self.containerVM.finishSupplyGoods(param)
                .subscribe(onNext: { (resonse) in
                    HUD.showSuccess("完成补货")
                }, onError: { (error) in
                    if let error = error as? AppError {
                        HUD.showError(error.message)
                    }
                }).disposed(by: self.disposeBag)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view  = UIView()
        view.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         let scence = containerVM.models.value[section]
        if let groups = scence.groups, !groups.isEmpty {
             return 72
        }
         return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section < containerVM.cellHeights.count {
          let rowHeights = containerVM.cellHeights[indexPath.section]
            if indexPath.row < rowHeights.count {
                return rowHeights[indexPath.row]
            }
        }
       return 0.0
    }
}

extension ContainerViewController: YBPopupMenuDelegate {
    func ybPopupMenuDidSelected(at index: Int, ybPopupMenu: YBPopupMenu!) {
        switch index {
        case 0: /// 待补清单
            navigationController?.pushViewController(NotReplenishedGoodsListVC(), animated: true)
        case 1: /// 补货记录
            navigationController?.pushViewController(ReplenishHistoryVC(), animated: true)
        default:
            break
        }
    }
}
