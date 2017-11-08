//
//  Message.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/30.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import ObjectMapper

class MessageGroup: Model {
    var groups: [Message]?
    
    override func mapping(map: Map) {
        groups <- map ["groups"]
    }
}

class MessageDetailGroup: Model {
    var groups: [MessageDetail]?
    
    override func mapping(map: Map) {
        groups <- map ["groups"]
    }
}

class Message: Model {
    var sceneSn: String?
    var type: MessageType = .none
    var noticeCount: String?
    var noticeTime: String?
    var content: String?
    
    override func mapping(map: Map) {
        sceneSn <- map["sceneSn"]
        type <- map["type"]
        noticeCount <- map["noticeCount"]
        noticeTime <- map["noticeTime"]
        content <- map["content"]
    }
}

class MessageDetail: Model {
    var sceneSn: String?
    var title: String?
    var content: String?
    var sendDate: String?
    
    override func mapping(map: Map) {
        sceneSn <- map["sceneSn"]
        title <- map["title"]
        content <- map["content"]
        sendDate <- map["sendDate"]
    }
}
