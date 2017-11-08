//
//  UserInfo.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/20.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import ObjectMapper

class UserInfo: Model {
    var userId: Int64 = 0
    var phoneNum: String?
    
    override func mapping(map: Map) {
        userId <- map["id"]
    }
}
