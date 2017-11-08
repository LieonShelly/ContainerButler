//
//  UserSessionViewModel.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/17.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import ObjectMapper

class UserSessionViewModel {
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    
    func handle(with type: UserSessionHandleType) -> Observable<NullDataResponse> {
        var needToken: NeedToken = .false
        switch type {
        case .updatePasswod(_):
              needToken = .true
        default:
            needToken = .false
        }
        let loginObserable: Observable<NullDataResponse> = RequestManager.reqeust(type.router, needToken: needToken)
        return loginObserable.map {(response) -> NullDataResponse in
            if  response.status == .success, let token = response.token, !token.isEmpty {
                let session = UserSessionInfo()
                session.token = token
                CoreDataManager.sharedInstance.save(userSession: session)
            }
              return response
        }
    }
    
    func handleUserInfoResponse(with type: UserSessionHandleType) -> Observable<BaseResponseObject<UserInfo>> {
        let loginObserable: Observable<BaseResponseObject<UserInfo>> = RequestManager.reqeust(type.router, needToken: .false)
        return loginObserable.map { (response) -> BaseResponseObject<UserInfo> in
            if  let token = response.token, !token.isEmpty, let userInfo = response.object {
                let session = UserSessionInfo()
                session.token = token
                CoreDataManager.sharedInstance.save(userSession: session)
                CoreDataManager.sharedInstance.save(userInfo: userInfo, phoneNum: type.param.phoneNum ?? "")
            }
            return response
        }
    }
    
    func getVerificationCode(_ param: UserSessionParam) -> Observable<NullDataResponse> {
        let codeObserable: Observable<NullDataResponse> = RequestManager.reqeust(.endpoint(UserSession.getVerificationCode, param: param), needToken: .true)
        return codeObserable
    }
    
      func loadRSAPublickey() -> Observable<String> {
        let keyOberable: Observable<BaseResponseObject<RSAKey>> = RequestManager.reqeust(.endpoint(UserSession.getPublicKey, param: nil), needToken: .false)
        return   keyOberable
                .retry(10)
                .map { response -> String in
                     if let obj = response.object, let key = obj.key {
                        return key
                     }
                    return ""
                 }
              .share(replay: 1)
    }
    
}
