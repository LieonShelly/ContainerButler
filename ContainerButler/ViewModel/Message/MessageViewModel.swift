//
//  MessageViewModel.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/30.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MessageViewModel {
    var responseType = Variable<StatusType>(StatusType.none)
    var messages = Variable<[Message]>([])
    var messageDetails = Variable<[MessageDetail]>([])
    fileprivate var disposeBag = DisposeBag()
    
    func requestMessages() {
        HUD.showLoading()
        let param = MessageSessionParam()
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let resposeeObj: Observable<BaseResponseObject<MessageGroup>> = RequestManager.reqeust(.endpoint(MessageSession.getMessage, param: param), needToken: .true)
       resposeeObj
            .subscribe(onNext: {[weak self] (response) in
                guard let messages = response.object?.groups else { return }
                self?.responseType.value = response.status
                self?.messages.value.append(contentsOf: messages)
            }, onError: { [weak self] (error) in
                if let error = error as? AppError {
                     self?.responseType.value = error.status
                     HUD.showError(error.message)
                }
                }, onCompleted: {
                    HUD.hideLoading()
            })
        .disposed(by: disposeBag)

    }
    
    func requestMessageDetail(_ param: MessageSessionParam) {
         HUD.showLoading()
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let resposeeObj: Observable<BaseResponseObject<MessageDetailGroup>> = RequestManager.reqeust(.endpoint(MessageSession.getMessageDetails, param: param))
        resposeeObj
            .subscribe(onNext: {[weak self] (response) in
                 guard let messageDetails = response.object?.groups else { return }
                self?.responseType.value = response.status
                 self?.messageDetails.value.append(contentsOf: messageDetails)
                }, onError: {[weak self] (error) in
                    if let error = error as? AppError {
                        self?.responseType.value = error.status
                        HUD.showError(error.message)
                    }
                }, onCompleted: {
                 HUD.hideLoading()
            })
            .disposed(by: disposeBag)
    }
}
