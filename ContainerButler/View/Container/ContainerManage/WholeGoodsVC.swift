//
//  WholeGoodsVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//  全部商品

import UIKit
import RxSwift
import RxCocoa
import MGSwipeTableCell
import MJRefresh

class WholeGoodsVC: BaseViewController {
      var containerId: Int = 0
     fileprivate lazy var listVM: ContainerManageViewModel = {[unowned self] in
        let viewModel =  ContainerManageViewModel()
        viewModel.param.cntrId = self.containerId
        viewModel.requestAllGoods()
        return viewModel
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }
    
}

extension WholeGoodsVC {
    fileprivate func setupUI() {
         tableView.register(GoodListCell.self, forCellReuseIdentifier: "GoodListCell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
         tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupRX() {
        let items = listVM.models.asObservable()
        items
            .bind(to: tableView.rx.items(cellIdentifier: "GoodListCell", cellType: GoodListCell.self)) {[weak self] (row, element, cell) in
                if let weakSelf = self {
                    cell.delegate = weakSelf
                    cell.configContainerWholeGoods(element)
                    cell.hiddenCover()
                    cell.loadingView.isHidden = !element.isSaleOutTest
                }
            }
            .disposed(by: disposeBag)
        
        listVM.refreshStatus.asObservable().subscribe(onNext: {[weak self] (status) in
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
        }).disposed(by: disposeBag)
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            if let weakSelf = self {
                weakSelf.listVM.requestCommand.onNext(false)
            }
        })
        listVM.requestCommand.onNext(true)
        listVM
            .responseType
            .asObservable()
            .map {$0 == StatusType.networkUnavailable ? false: true}
            .bind(to: emptyContainerView.rx.isHidden)
            .disposed(by: disposeBag)
        
        listVM
            .responseType
            .asObservable()
            .map {$0 == StatusType.success ? false: true}
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        emptyContainerView.reloadBtn.onTap {[weak self] in
            HUD.showLoading()
            self?.listVM.requestCommand.onNext(true)
        }
    }
}

extension WholeGoodsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
}
extension WholeGoodsVC: MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        if direction == .rightToLeft {
            swipeSettings.transition = .border
            return  UIButton.createButtons(with: ["出货测试"], backgroudColors: [UIColor(hex: CustomKey.Color.mainOrangeColor)])
        }
          return nil
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        if let cell = cell as? GoodListCell, let indexPath = tableView.indexPath(for: cell), direction == .rightToLeft, index == 0 {
            cell.loadingView.isHidden = false
            listVM.models.value[indexPath.row].isSaleOutTest = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0, execute: { [weak self] in
                guard let weakSelf = self else { return }
                let param = ContainerSessionParam()
                param.channelId = "\(weakSelf.listVM.models.value[indexPath.row].supplementId)"
                weakSelf.listVM.requestSalesOutTest(param)
                    .subscribe(onNext: { (response) in
                        cell.loadingView.isHidden = true
                        weakSelf.listVM.models.value[indexPath.row].isSaleOutTest = false
                        weakSelf.tableView.reloadData()
                        HUD.showAlert(from: weakSelf, title: "测试完成", message: "\((weakSelf.parent as? ContainerManageVC)?.container?.name ?? "")货柜 货道号：\(weakSelf.listVM.models.value[indexPath.row].channelSn ?? "")\n \(weakSelf.listVM.models.value[indexPath.row].goodsName ?? "")", enterTitle: "确定", isHiddenCancleTitle: true, cancleTitle: nil, enterAction: nil, cancleAction: nil)
                    }, onError: { (error) in
                        cell.loadingView.isHidden = true
                        weakSelf.listVM.models.value[indexPath.row].isSaleOutTest = false
                        weakSelf.tableView.reloadData()
                        if let error = error as? AppError {
                            HUD.showError(error.message)
                        }
                    }, onCompleted: {
                        
                    }).disposed(by: weakSelf.disposeBag)
            })
       
        }
        return true
    }
}
