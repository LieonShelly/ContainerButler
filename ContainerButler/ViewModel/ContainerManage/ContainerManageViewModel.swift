//
//  ContainerManage.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/24.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ContainerManageViewModel {
    var responseType = Variable<StatusType>(StatusType.none)
    var selectedContainerModels = Variable<[Goods]>([])
    var selectedSenceModels = Variable<[Goods]>([])
    var models = Variable<[Goods]>([])
    var goodsCategory = Variable([GoodsCategory]())
    var scenceList = Variable([Scence]())
    var requestCommand: PublishSubject<Bool> = PublishSubject<Bool>()
    var refreshStatus = Variable<RefreshStatus>(.none)
    lazy var param: ContainerSessionParam = {
        let param = ContainerSessionParam()
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId ?? -1
        param.pageNo = 1
        param.pageSize = 20
        return param
    }()
    var supplyRecords =  Variable<[SuplementRecord]>([])
    fileprivate var moreSupplyRecords: [SuplementRecord] = []
    fileprivate let disposeBag = DisposeBag()
    fileprivate  var moreData: [Goods] = []
    fileprivate  var orginalGoodsArray: [Goods] = []
    
   func reuestWaitSuppltScencelist() {
        let param = ContainerSessionParam()
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let listObverable: Observable<BaseResponseObject<ScenceList>> = RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplySceneList, param: param))
        listObverable
            .map { response -> [Scence] in
                let whole = Scence()
                whole.name = "全部"
                whole.number = ""
                if var groups = response.object?.groups {
                      groups.insert(whole, at: 0)
                    return groups
                }
               return []
            }
            .subscribe(onNext: {[weak self] (messages) in
                self?.scenceList.value.append(contentsOf: messages)
                }, onError: { (error) in
                    if let error = error as? AppError {
                        HUD.showError(error.message)
                    }
            }).disposed(by: disposeBag)
    
    }
    
    func requestWaitSupplyGoodsCategoryList() {
        let param = ContainerSessionParam()
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let listObverable: Observable<BaseResponseObject<WaitSupplyGoodsCategoryList>> = RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplyGoodsCategoryList, param: param))
        listObverable
            .map { response -> [GoodsCategory] in
                let whole = GoodsCategory()
                whole.cateName = "全部"
                whole.cateId = 0
                if var groups = response.object?.groups {
                    groups.insert(whole, at: 0)
                    return groups
                }
                return []
            }
            .subscribe(onNext: {[weak self] (messages) in
                self?.goodsCategory.value.append(contentsOf: messages)
                }, onError: { (error) in
                    if let error = error as? AppError {
                        HUD.showError(error.message)
                    }
            }).disposed(by: disposeBag)
    }
    
    func requestWaitSupplyGoodsList() {
        requestWaitSupplyGoods(.getWaitSupplyGoodsList)
    }
    
    func requestWaitSupplyGoodsDetail( _ param: ContainerSessionParam) -> Observable<GoodsDetail> {
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let listObverable: Observable<BaseResponseObject<GoodsDetail>> = RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplyGoodsDetails, param: param))
        return listObverable.map {$0.object ?? GoodsDetail()}
    }
    
    func requestWaitSupplyContainerGoodsList() {
         requestWaitSupplyGoods(.getWaitSupplyContainerGoodsList)
    }
    
    func requestSupplementRecord(_ param: ContainerSessionParam) -> Observable<NullDataResponse> {
          param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let repsonseObserable: Observable<NullDataResponse> = RequestManager.reqeust(.endpoint(ContainerSession.commitSupplementRecord, param: param))
        return repsonseObserable
    }
    
    func uploadSupplementPicture(_ param: ContainerSessionParam, file: Data) -> Observable<NullDataResponse> {
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
      let  repsonseObserable: Observable<NullDataResponse> =  RequestManager.upload(Router.upload(endpoint: ContainerSession.uploadSupplementPic), param: param,
                              fileData: [file])
        return repsonseObserable
    }
 
    func requestAllGoods() {
         requestWaitSupplyGoods(.getContainerGoodsList)
    }
    
    func cacheSelectedContainerGoods(_ goods: Goods) {
        CoreDataManager.sharedInstance.save(goods: goods, containerId: param.cntrId ?? 0)
        selectedContainerModels.value = (CoreDataManager.sharedInstance.getGoodsList(containerId: param.cntrId ?? 0)) ?? [Goods]()
    }
    
    func loadSelectedContainerGoods() {
         selectedContainerModels.value = (CoreDataManager.sharedInstance.getGoodsList(containerId: param.cntrId ?? 0)) ?? [Goods]()
    }
    
    func resetData(_ model: Goods, index: Int) {
        CoreDataManager.sharedInstance.deleteGoods(containerId: param.cntrId ?? 0, supplementId: model.supplementId)
        loadSelectedContainerGoods()
        for orginalGoods in orginalGoodsArray {
            if orginalGoods.supplementId == model.supplementId,
                let copyGoods = orginalGoods.copy() as? Goods {
                model.supplyCount = copyGoods.supplyCount
                model.remainCount = copyGoods.remainCount
                model.waitSupplyCount = copyGoods.waitSupplyCount
                model.isSupplied = false
                break
//                models.value.append(copyGoods)
            }
        }
    }
    
    func clearCachedGoods() {
        CoreDataManager.sharedInstance.deleteGoods(containerId: param.cntrId ?? 0, supplementId: nil)
    }
    
    func requestSalesOutTest(_ param: ContainerSessionParam) -> Observable<NullDataResponse> {
        let repsonseObserable: Observable<NullDataResponse> = RequestManager.reqeust(.endpoint(CentralSession.salesOutTest, param: param))
        return repsonseObserable
    }
}

extension ContainerManageViewModel {
    fileprivate func requestWaitSupplyGoods(_ path: ContainerSession) {
        HUD.showLoading()
        requestCommand
            .subscribe(onNext: {  [weak self](isReloadData) in
                guard let weakSelf = self else { return }
                weakSelf.param.pageNo = isReloadData ? 1: (weakSelf.param.pageNo ?? 1) + 1
                let listObverable: Observable<BaseResponseObject<WaitSupplyGoodsList>> = RequestManager.reqeust(.endpoint(path, param: weakSelf.param))
                listObverable
                    .subscribe {[weak self] (event) in
                        guard let weakSelf = self else { return }
                        switch event {
                        case .next(let response):
                            guard let group = response.object?.groups else { return }
                            weakSelf.responseType.value = response.status
                            if isReloadData {
                                weakSelf.models.value = group
                            } else {
                                if !group.isEmpty {
                                    weakSelf.models.value =  weakSelf.models.value + group
                                    weakSelf.moreData.removeAll()
                                    weakSelf.moreData.append(contentsOf: group)
                                } else {
                                    weakSelf.param.pageNo = (weakSelf.param.pageNo ?? 2) - 1
                                    weakSelf.moreData.removeAll()
                                }
                            }
                            if path == .getWaitSupplyContainerGoodsList {
                                weakSelf.orginalGoodsArray = weakSelf.models.value.map {($0.copy() as? Goods) ?? Goods() }
                                weakSelf.filterSelectedGoods()
                            }
                            break
                        case .error( let error):
                            if let error = error as? AppError {
                                weakSelf.responseType.value = error.status
                                HUD.showError(error.message)
                                if isReloadData {
                                    weakSelf.refreshStatus.value =  .endHeaderRefresh
                                     weakSelf.param.pageNo = 0
                                } else {
                                     weakSelf.refreshStatus.value =  .endFooterRefresh
                                     weakSelf.param.pageNo = (weakSelf.param.pageNo ?? 2) - 1
                                }
                            }
                            break
                        case .completed:
                            HUD.hideLoading()
                            if isReloadData {
                                if weakSelf.models.value.count < 20 {
                                     weakSelf.refreshStatus.value = .noMoreData
                                } else {
                                    weakSelf.refreshStatus.value =  .endHeaderRefresh
                                } 
                            } else {
                                if weakSelf.moreData.isEmpty {
                                    weakSelf.refreshStatus.value = .noMoreData
                                } else {
                                    weakSelf.refreshStatus.value =  .endFooterRefresh
                                }
                            }
                            break
                        }
                    }.disposed(by: weakSelf.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    fileprivate func filterSelectedGoods() {
        for currentGoods in models.value {
            if  let cacheGoods = CoreDataManager.sharedInstance.getGoods(containerId: self.param.cntrId ?? 0, supplementId: currentGoods.supplementId),
                 let _ = self.models.value.index(where: {$0.supplementId == cacheGoods.supplementId}) {
//                models.value.remove(at: index)
                currentGoods.isSupplied = true
                currentGoods.supplyCount = cacheGoods.supplyCount
            }
        }
        print(models.value)
        print(orginalGoodsArray)
    }
    
}

extension ContainerManageViewModel {
    
}
