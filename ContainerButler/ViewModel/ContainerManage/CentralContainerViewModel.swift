//
//  CentralContainerViewModel.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/26.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class CentralContainerViewModel {
    var currentVolume = Variable("0")
    var updatedVolume = Variable("0")
    
    func getCurrentVolume(_ param: ContainerSessionParam) -> Observable<BaseResponseObject<Command>> {
        let resp: Observable<BaseResponseObject<Command>> = RequestManager.reqeust(.endpoint(CentralSession.getCurrentVolume, param: param))
       return resp.map {[weak self] (response) -> BaseResponseObject<Command>  in
            self?.currentVolume.value = response.object?.volume ?? "0"
            return response
        }
    }
    
    func updateAduionVolume(_ param: ContainerSessionParam) -> Observable<NullDataResponse> {
        let resp: Observable<NullDataResponse> = RequestManager.reqeust(.endpoint(CentralSession.updateAudioVolume, param: param))
        return resp
    }
    
    func rebootDevice(_ param: ContainerSessionParam) -> Observable<NullDataResponse> {
        let resp: Observable<NullDataResponse> = RequestManager.reqeust(.endpoint(CentralSession.rebootSystem, param: param))
        return resp
    }
}
