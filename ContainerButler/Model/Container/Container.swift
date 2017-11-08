//
//  Container.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/20.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import ObjectMapper

class ContainerHome: Model {
    var totalCount: Int = 0
    var scences: [Scence]?
    override func mapping(map: Map) {
        totalCount <- map["waitSupplySumCount"]
        scences <- map["scenes"]
    }
}

class Scence: Model {
    var number: String?
    var name: String?
    var groups: [ScenceGroup]?
    
    override func mapping(map: Map) {
        number <- map["sceneSn"]
        name <- map["sceneName"]
        groups <- map["vendingContainerGroups"]
    }

}

class ScenceGroup: Model {
    var containers: [Container]?
    
    override func mapping(map: Map) {
        containers <- map["vendingContainers"]
    }
}

class Container: Model {
    var containerId: Int = 0
    var name: String?
    var number: String?
    var isCentralContainer: Bool = false
    var waitSupplyCount: Int = 0
    
    override func mapping(map: Map) {
        containerId <- map["id"]
        name <- map["vendingContainerName"]
        number <- map["cntrSn"]
        isCentralContainer <- (map["central"], BoolNumberTransform())
        waitSupplyCount <- map["waitSupplyCount"]
    }
}

class Command: Model {
    var volume: String?
    
    override func mapping(map: Map) {
         volume <- map["volume"]
    }
}
