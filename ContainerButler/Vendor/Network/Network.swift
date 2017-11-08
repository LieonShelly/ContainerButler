//
//  Network.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/13.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

public class Header: Model {
    public var token: String {
        get { return  CoreDataManager.sharedInstance.getSessionInfo()?.token ?? "" }
        set { }
    }
    public var contentType: String = "application/json"
    
    public override func mapping(map: Map) {
        token <- map["X-Auth-Token"]
        contentType <- map["Content-Type"]
    }
}

enum UserSession: UserEndPointProtocol {
    
    /// 忘记密码身份验证
    case forgetPwd
    ///  获取公钥
    case getPublicKey
    /// 获取验证码
    case getVerificationCode
    ///  用户密码登录
    case loginByPwd
    /// 用户验证码登录
    case loginByVft
    /// 重置密码
    case resetPwd
    /// 修改密码
    case updatePwd
    /// 忘记密码时验证码验证
    case verifyForgetPwdCaptchCode
    
    var endpoint: String {
        switch self {
        case .forgetPwd:
            return "/forgetPwd"
        case .getPublicKey:
            return "/getPublicKey"
        case .getVerificationCode:
            return "/getVerificationCode"
        case .loginByPwd:
            return "/loginByPwd"
        case .loginByVft:
            return "/loginByVft"
        case .resetPwd:
            return "/resetPwd"
        case .updatePwd:
            return "/updatePwd"
        case .verifyForgetPwdCaptchCode:
            return "/forgetPwd"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPublicKey:
            return .get
        default:
            return .post
        }
    }
}

enum ContainerSession: UserEndPointProtocol {
    // 获取货柜待补情况
    case getWaitSupplyState
    // 获取待补优享空间
    case getWaitSupplySceneList
    // 获取待补商品类别列表
    case getWaitSupplyGoodsCategoryList
    // 获取待补商品清单
    case getWaitSupplyGoodsList
    // 获取待补商品详情
    case getWaitSupplyGoodsDetails
    // 获取货柜待补商品
    case getWaitSupplyContainerGoodsList
    // 提交补货记录
    case commitSupplementRecord
    // 上传补货照片
    case uploadSupplementPic
    // 开始补货
    case startSupplyGoods
    // 完成补货
    case finishSupplyGoods
    // 查看总补货记录
    case getSupplementSumRecord
    // 补货记录详情
    case getSupplementRecordDetails
    // 获取货柜待补商品清单
    case getContainerGoodsList
    
    var endpoint: String {
        switch self {
        case .getWaitSupplyState:
            return "/getWaitSupplyState"
        case .getWaitSupplySceneList:
            return "/getWaitSupplySceneList"
        case .getWaitSupplyGoodsCategoryList:
            return "/getWaitSupplyGoodsCategoryList"
        case .getWaitSupplyGoodsList:
            return "/getWaitSupplyGoodsList"
        case .getWaitSupplyGoodsDetails:
            return "/getWaitSupplyGoodsDetails"
        case .getWaitSupplyContainerGoodsList:
            return "/getWaitSupplyContainerGoodsList"
        case .commitSupplementRecord:
            return "/commitSupplementRecord"
        case .uploadSupplementPic:
            return "/uploadSupplementPic"
        case .startSupplyGoods:
            return "/startSupplyGoods"
        case .finishSupplyGoods:
            return "/finishSupplyGoods"
        case .getSupplementSumRecord:
            return "/getSupplementSumRecord"
        case .getSupplementRecordDetails:
            return "/getSupplementRecordDetails"
        case .getContainerGoodsList:
            return "/getContainerGoodsList"
        }
    }
}

enum MessageSession: UserEndPointProtocol {
    // 查看消息
    case getMessage
    // 查看消息详情
    case getMessageDetails
    
    var endpoint: String {
        switch self {
        case .getMessage:
            return "/getMsg"
        case .getMessageDetails:
            return "/getMsgDetails"
        }
    }

}

enum CentralSession: UserEndPointProtocol {
    // 重启设备
    case rebootSystem
    // 测试出货接口
    case salesOutTest
    // 调节音量大小
    case updateAudioVolume
    // 获取当前设备音量
    case getCurrentVolume
    
    var path: String {
        return "/cmd"
    }
    
    var endpoint: String {
        switch self {
        case .rebootSystem:
            return "/rebootSystem"
        case .salesOutTest:
            return "/salesOutTest"
        case .updateAudioVolume:
            return "/updateAudioVolume"
        case .getCurrentVolume:
            return "/getCurrentVolume"
        }
    }
}
class UserSessionParam: Model {
    var phoneNum: String?
    var newPwd: String?
    var oldPwd: String?
    var password: String?
    var userName: String?
    var verificationCode: String?
    var verifyCodeType: CaptchaCodeType?
    var oldPassword: String?
    var newPassword: String?
    var userId: Int64?
    
    override func mapping(map: Map) {
        phoneNum <- map["cellPhoneNum"]
        oldPwd <- map["oldPwd"]
        password <- map["password"]
        userName <- map["userName"]
        verificationCode <- map["verificationCode"]
        verifyCodeType <- map["type"]
        oldPassword <- map["oldePwd"]
        newPassword <- map["newPwd"]
        userId <- map["userId"]
    }
}

class ContainerSessionParam: Model {
    var userId: Int64?
    var pageNo: Int?
    var pageSize: Int?
    var sceneSn: String?
    var cateId: Int?
    var goodsSn: String?
    var cntrId: Int?
    var suplementRecords: [SuplementRecordParam]?
    var deviceNo: String?
    var volume: String?
    var channelId: String?
    
    override func mapping(map: Map) {
        userId <- map["userId"]
        pageNo <- map["pageNo"]
        pageSize <- map["pageSize"]
        sceneSn <- map["sceneSn"]
        cateId <- map["cateId"]
        goodsSn <- map["goodsSn"]
        cntrId <- map["cntrId"]
        suplementRecords <- map["supplementRecords"]
        deviceNo <- map["deviceNo"]
        volume <- map["volume"]
        channelId <- map["channelId"]
    }
}

class SuplementRecordParam: Model {
    var supplementId: Int = 0
    var supplyCount: Int = 0
    
    override func mapping(map: Map) {
        supplementId <- map["supplementId"]
        supplyCount <- map["supplyCount"]
    }
}

class MessageSessionParam: Model {
    var userId: Int64?
    var type: MessageType = .none
    
    override func mapping(map: Map) {
         userId <- map["userId"]
         type <- map["msgType"]
    }
}
