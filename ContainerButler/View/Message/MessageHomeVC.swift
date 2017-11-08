//
//  MessageHomeVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//  消息

import UIKit
import RxSwift
import RxCocoa

class MessageHomeVC: BaseViewController {
    fileprivate lazy var messageVM: MessageViewModel = {
        let messageVM = MessageViewModel()
        messageVM.requestMessages()
        return messageVM
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }

}

extension MessageHomeVC {
    fileprivate func setupUI() {
        title = "消息"
       tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
    }
    
    fileprivate func setupRX() {
        tableView.rx
            .setDelegate(self)
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
            self?.messageVM.requestMessages()
        }
        
         messageVM.messages
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "MessageCell", cellType: MessageCell.self)) {(row, element, cell) in
                cell.config(element)
            }
            .disposed(by: disposeBag)
    }
}

extension MessageHomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcc = MessageDetailVC()
        let messageType = messageVM.messages.value[indexPath.section].type
        vcc.messageType = messageType
        navigationController?.pushViewController(vcc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
}
