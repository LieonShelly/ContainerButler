//
//  ContainerViewModel.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ContainerViewModel {
    var totalCount = Variable(0)
    var responseType = Variable<StatusType>(StatusType.none)
    var models = Variable<[Scence]>([])
    var requestCommand: PublishSubject<Bool> = PublishSubject<Bool>()
    var refreshStatus = Variable<RefreshStatus>(.none)
    var cellHeights: [[CGFloat]] = [[]]
    fileprivate  let disposeBag: DisposeBag = DisposeBag()
    fileprivate  var moreData: [Scence] = []
    fileprivate lazy var param: ContainerSessionParam = {
        let param = ContainerSessionParam()
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId ?? -1
        param.pageNo = 1
        param.pageSize = 20
        return param
    }()
    
    init() {
        requestList()
    }
    
    func startSupplyGoods(_ param: ContainerSessionParam) -> Observable<BaseResponseObject<Scence>> {
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let repsonseObserable: Observable<BaseResponseObject<Scence>> = RequestManager.reqeust(.endpoint(ContainerSession.startSupplyGoods, param: param))
        return repsonseObserable
    }
  
    func finishSupplyGoods(_ param: ContainerSessionParam) -> Observable<NullDataResponse> {
         param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let repsonseObserable: Observable<NullDataResponse> = RequestManager.reqeust(.endpoint(ContainerSession.finishSupplyGoods, param: param))
        return repsonseObserable
    }
}

extension ContainerViewModel {
    
    fileprivate func requestList() {
          HUD.showLoading()
        requestCommand.subscribe(onNext: { [unowned self](isReloadData) in
            self.param.pageNo = isReloadData ? 1: (self.param.pageNo ?? 1) + 1
            let homerObservable: Observable< BaseResponseObject<ContainerHome>> =  RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplyState, param: self.param), needToken: .true)
            homerObservable.retry(3).subscribe({ (event) in
                switch event {
                case  .next( let response):
                     self.responseType.value = response.status
                    if let scences =  response.object?.scences, let totalCount = response.object?.totalCount {
                         self.totalCount.value = totalCount
                        if isReloadData {
                            self.models.value = scences
                        } else {
                            if !scences.isEmpty {
                                self.models.value =  self.models.value + scences
                                self.moreData.removeAll()
                                self.moreData.append(contentsOf: scences)
                            } else {
                                self.param.pageNo = (self.param.pageNo ?? 2) - 1
                                self.moreData.removeAll()
                            }
                        }
                    }
                    self.cellHeights = self.caculateCellHeights()
                    break
                case .error( let error):
                    if let error = error as? AppError {
                       self.responseType.value = error.status
                        HUD.showError(error.message)
                        if isReloadData {
                            self.refreshStatus.value =  .endHeaderRefresh
                            self.param.pageNo = 0
                        } else {
                            self.refreshStatus.value =  .endFooterRefresh
                            self.param.pageNo = (self.param.pageNo ?? 2) - 1
                        }
                    }
                    break
                case .completed:
                     HUD.hideLoading()
                    if isReloadData {
                        self.refreshStatus.value =  .endHeaderRefresh
                        if self.models.value.count < 20 {
                            self.refreshStatus.value = .noMoreData
                        }
                    } else {
                        if self.moreData.isEmpty {
                            self.refreshStatus.value = .noMoreData
                        } else {
                            self.refreshStatus.value =  .endFooterRefresh
                        }
                    }
                    break
                }
            }).disposed(by: self.disposeBag)
            
        })
            .disposed(by: disposeBag)
    }
    
    fileprivate func caculateCellHeights() -> [[CGFloat]] {
        var scenceHeights: [[CGFloat]] = [[]]
        for scence in models.value { // 每个场景
            var sectionCellHeights: [CGFloat] = []
            if let groups = scence.groups {
                var cellHeight: CGFloat = 0.0
                for group in groups {
                    // 开始算cell的高度
                    if let containers = group.containers {
                        let rows: Int = Int(ceil(Double (containers.count) / 3.0 )) // 总行数
                        let minimumLineSpacing: CGFloat = 12.0.fitHeight
                        let itemHeight: CGFloat = 45.0.fitHeight
                        let bottomInset: CGFloat = 22.0.fitHeight
                        let topInset: CGFloat = 12.0.fitHeight
                        let bgViewBottomInset: CGFloat = 12
                        let labelTop: CGFloat = 12
                        let labelHeight: CGFloat = 16
                        let labelBottom: CGFloat = 20
                        cellHeight =  (itemHeight + minimumLineSpacing) * CGFloat(rows) + bottomInset + topInset + labelBottom + labelHeight + labelTop + bgViewBottomInset
                    }
                    sectionCellHeights.append(cellHeight)
                }
                if !sectionCellHeights.isEmpty {
                    scenceHeights.append(sectionCellHeights)
                }
            }
        }
        
        print("scenceHeights.count:\(scenceHeights.filter {!$0.isEmpty})")
        return scenceHeights.filter {!$0.isEmpty}
    }
}
