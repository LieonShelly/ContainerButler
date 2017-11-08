//
//  ContainerManage.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/24.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import ObjectMapper

class ScenceList: Model {
    var groups: [Scence]?
    
    override func mapping(map: Map) {
        groups <- map["groups"]
    }
}

class WaitSupplyGoodsCategoryList: Model {
    var groups: [GoodsCategory]?
    
    override func mapping(map: Map) {
        groups <- map["groups"]
    }
}

class WaitSupplyGoodsList: Model {
    var groups: [Goods]?
    
    override func mapping(map: Map) {
        groups <- map["groups"]
    }
}

class GoodsCategory: Model {
    var cateId: Int?
    var cateName: String?
    
    override func mapping(map: Map) {
        cateId <- map["cateId"]
        cateName <- map["cateName"]
    }
}

class Goods: Model, NSCopying {
    var goodsSn: String?
    var goodsName: String?
    var goodsPic: String?
    var waitSupplyCount: Int = 1000
    var channelSn: String?
    var remainCount: Int = 0
    var supplyCount: Int = 0
    var supplementId: Int = 0
    var isSaleOutTest: Bool = false
    var isSupplied: Bool = false
    
    override func mapping(map: Map) {
        goodsSn <- map["goodsSn"]
        goodsName <- map["goodsName"]
        goodsPic <- map["goodsPic"]
        waitSupplyCount <- map["waitSupplyCount"]
        channelSn <- map["channelSn"]
        remainCount <- map["remainCount"]
        supplementId <- map["id"]
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let goods = Goods()
        goods.goodsSn = self.goodsSn
        goods.goodsName = self.goodsName
        goods.goodsPic = self.goodsPic
        goods.waitSupplyCount = self.waitSupplyCount
        goods.channelSn = self.channelSn
        goods.remainCount = self.remainCount
        goods.supplyCount = self.supplyCount
        goods.supplementId = self.supplementId
        return goods
    }
    
}

class GoodsDetail: Model {
    var goodsSn: String?
    var goodsName: String?
    var sceneCountList: [WaitSupplySence]?
    var sumCount: Int = 0
    
    override func mapping(map: Map) {
        goodsSn <- map["goodsSn"]
        goodsName <- map["goodsName"]
        sceneCountList <- map["sceneCountList"]
        sumCount <- map["sumCount"]
    }
}

class WaitSupplySence: Model {
    var waitSupplyCount: Int = 0
    var sceneName: String?
    
    override func mapping(map: Map) {
        waitSupplyCount <- map["waitSupplyCount"]
        sceneName <- map["sceneName"]
    }
}
