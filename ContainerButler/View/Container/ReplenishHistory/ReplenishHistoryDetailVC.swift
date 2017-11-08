//
//  ReplenishHistoryDetailVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ReplenishHistoryDetailVC: BaseViewController {
    var scence: SuplementRecord?
    
    fileprivate lazy var detailVM: ReplenishHistoryViewModel = { [unowned self] in
        let viewModel = ReplenishHistoryViewModel()
        let param = ContainerSessionParam()
        param.sceneSn = self.scence?.sceneSn
        viewModel.requestSupplementRecordDetails(param)
        return viewModel
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }

}

extension ReplenishHistoryDetailVC {
    fileprivate func setupUI() {
        title = "\(scence?.sceneName ?? "")-编号: \(scence?.sceneSn ?? "")"
        tableView.register(ReplenishHistoryDetailCell.self, forCellReuseIdentifier: "ReplenishHistoryDetailCell")
        tableView.register(ReplenishHistoryDetailTableHeader.self, forHeaderFooterViewReuseIdentifier: "ReplenishHistoryDetailTableHeader")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
    }
    
    fileprivate func setupRX() {

        detailVM
            .responseType
            .asObservable()
            .map {$0 == StatusType.networkUnavailable ? false: true}
            .bind(to: emptyContainerView.rx.isHidden)
            .disposed(by: disposeBag)
        
        detailVM
            .responseType
            .asObservable()
            .map {$0 == StatusType.success ? false: true}
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        emptyContainerView.reloadBtn.onTap {[weak self] in
            let param = ContainerSessionParam()
            param.sceneSn = self?.scence?.sceneSn
            self?.detailVM.requestSupplementRecordDetails(param)
        }
        
        detailVM
            .supplyRecordDetailGroups
            .asObservable()
            .subscribe(onNext: { [weak self](_) in
              HUD.hideLoading()
              self?.tableView.reloadData()
        })
            .disposed(by: disposeBag)
        
        tableView.dataSource = self
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension ReplenishHistoryDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return detailVM.supplyRecordDetailGroups.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailVM.supplyRecordDetailGroups.value[section].cntrSupplementRecords?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReplenishHistoryDetailCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let model = detailVM.supplyRecordDetailGroups.value[indexPath.section].cntrSupplementRecords?[indexPath.row] {
            cell.config(model)
        }
        return cell
    }
}

extension ReplenishHistoryDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ReplenishHistoryDetailTableHeader = tableView.dequeueReusableHeaderFooter()
         let model = detailVM.supplyRecordDetailGroups.value[section]
        headerView.config(model)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
}
