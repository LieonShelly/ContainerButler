//
//  ResponseObject.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/13.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponseObject<T: Mappable>: Mappable {
    var status: StatusType = .none
    var description: String?
    var token: String?
    var object: T?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- (map["code"])
        description <- map["desc"]
        token <- map["token"]
        object <- map["msg"]
    }
}

class NullDataResponse: BaseResponseObject<Model> {}
