//
//  ReplenishHistory.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/30.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import ObjectMapper

class SuplementRecord: Model {
    var sceneSn: String?
    var sceneName: String?
    var waitSupplyCount: Int = 0
    var supplyCount: Int = 0
    var lackCount: Int = 0
    var supplyTime: String?
    
    override func mapping(map: Map) {
        sceneSn <- map["sceneSn"]
        sceneName <- map["sceneName"]
        waitSupplyCount <- map["waitSupplyCount"]
        supplyCount <- map["supplyCount"]
        lackCount <- map["lackCount"]
        supplyTime <- map["supplyTime"]
    }
}

class SuplementRecordGroup: Model {
    var supplementList: [SuplementRecord]?
    var sumWaitSupplyCount: Int = 0
    var sumSupplyCount: Int = 0
    var date: String?
    
    override func mapping(map: Map) {
        supplementList <- map["supplementList"]
        sumWaitSupplyCount <- map["sumWaitSupplyCount"]
        sumSupplyCount <- map["sumSupplyCount"]
        date <- map["date"]
    }
}

class RecordGroup: Model {
    var groups: [SuplementRecordGroup]?
    
    override func mapping(map: Map) {
        groups <- map["groups"]
    }
}

class SuplementRecordDetail: Model {
    var channelSn: String?
    var goodsName: String?
    var goodsPic: String?
    var waitSupplyCount: Int = 0
    var supplyCount: Int = 0
    
    override func mapping(map: Map) {
        channelSn <- map["channelSn"]
        goodsName <- map["goodsName"]
        goodsPic <- map["goodsPic"]
        waitSupplyCount <- map["waitSupplyCount"]
        supplyCount <- map["supplyCount"]
    }
}

class ContainerSupplyRecord: Model {
    var cntrSn: String?
    var cntrSupplementRecords: [SuplementRecordDetail]?
    
    override func mapping(map: Map) {
        cntrSn <- map["cntrSn"]
        cntrSupplementRecords <- map["cntrSupplementRecords"]
    }
}

class ContainerSupplyRecordGroup: Model {
    var groups: [ContainerSupplyRecord]?
    
    override func mapping(map: Map) {
        groups <- map["groups"]
    }
}
