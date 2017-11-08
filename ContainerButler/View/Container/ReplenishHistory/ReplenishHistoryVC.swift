//
//  ReplenishHistoryVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//  补货记录

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import MJRefresh

class ReplenishHistoryVC: BaseViewController {
    fileprivate lazy var historyVM: ReplenishHistoryViewModel = {
        let viewModel = ReplenishHistoryViewModel()
        viewModel.requestSupplyRecords()
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }
}

extension ReplenishHistoryVC {
     fileprivate func setupUI() {
        title = "补货记录"
        tableView.register(ReplenishHistoryCell.self, forCellReuseIdentifier: "ReplenishHistoryCell")
        tableView.register(ReplenishHistoryTableHeader.self, forHeaderFooterViewReuseIdentifier: "ReplenishHistoryTableHeader")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
    }
    
    fileprivate func setupRX() {
    
        historyVM
            .supplyRecordGroups
            .asObservable()
            .subscribe(onNext: { [weak self](_) in
                HUD.hideLoading()
                self?.tableView.reloadData()
        })
            .disposed(by: disposeBag)

        historyVM
            .responseType
            .asObservable()
            .map {$0 == StatusType.networkUnavailable ? false: true}
            .bind(to: emptyContainerView.rx.isHidden)
            .disposed(by: disposeBag)
        
        historyVM
            .responseType
            .asObservable()
            .map {$0 == StatusType.success ? false: true}
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        emptyContainerView.reloadBtn.onTap {[weak self] in
            HUD.showLoading()
            self?.historyVM.requestCommand.onNext(true)
        }

        historyVM.refreshStatus
            .asObservable()
            .subscribe(onNext: {[weak self] (status) in
            switch status {
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
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            if let weakSelf = self {
                weakSelf.historyVM.requestCommand.onNext(false)
            }
        })
        historyVM.requestCommand.onNext(true)
        
    }
}

extension ReplenishHistoryVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return historyVM.supplyRecordGroups.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyVM.supplyRecordGroups.value[section].supplementList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReplenishHistoryCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let model = historyVM.supplyRecordGroups.value[indexPath.section].supplementList?[indexPath.row] {
            cell.config(model)
        }
        return cell
    }
}
extension ReplenishHistoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = historyVM.supplyRecordGroups.value[indexPath.section].supplementList?[indexPath.row] {
            let vcc = ReplenishHistoryDetailVC()
            vcc.scence = model
            navigationController?.pushViewController(vcc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view  = UIView()
        view.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        return view
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ReplenishHistoryTableHeader = tableView.dequeueReusableHeaderFooter()
        headerView.config(historyVM.supplyRecordGroups.value[section])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
