//
//  MessageDetailVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/22.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//  消息详情

import UIKit
import UIKit
import RxSwift
import RxCocoa

class MessageDetailVC: BaseViewController {
    var messageType: MessageType = .none
    fileprivate lazy var messageVM: MessageViewModel = {[unowned self] in
        let messageVM = MessageViewModel()
        return messageVM
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }
    
}

extension MessageDetailVC {
    fileprivate func setupUI() {
        title = messageType.title
        tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
    }
    
    fileprivate func setupRX() {
        let param = MessageSessionParam()
        param.type = messageType
        messageVM.requestMessageDetail(param)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        let items = messageVM.messageDetails.asObservable()
        items
            .bind(to: tableView.rx.items(cellIdentifier: "MessageCell", cellType: MessageCell.self)) { (row, element, cell) in
                cell.config(element)
            }
            .disposed(by: disposeBag)
        
        messageVM
            .responseType
            .asObservable()
            .map {$0 == StatusType.networkUnavailable ? false: true}
            .bind(to: emptyContainerView.rx.isHidden)
            .disposed(by: disposeBag)
        
        messageVM
            .responseType
            .asObservable()
            .map {$0 == StatusType.success ? false: true}
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        emptyContainerView.reloadBtn.onTap {[weak self] in
            self?.messageVM.requestMessageDetail(param)
        }
        
    }
}

extension MessageDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.row < messageVM.messageDetails.value.count {
            let vcc = NotReplenishedGoodsListVC()
            vcc.supplyMessage = messageVM.messageDetails.value[indexPath.row]
            navigationController?.pushViewController(vcc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
}
