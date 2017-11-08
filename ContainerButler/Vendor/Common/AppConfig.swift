//
//  AppConfig.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/11.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation

struct CustomKey {
    struct NotificationName {
        static let loginSuccess = NSNotification.Name.init("LoginSuccess")
        static let loginInvalid = NSNotification.Name.init("loginInvalid")
        static let fastRegisterSuccess = NSNotification.Name(rawValue: "fastRegisterVCHandle")
        static let weiboDidLoginNotification = NSNotification.Name(rawValue: "weiboDidLoginNotification")
        static let wechatDidLoginNotification = NSNotification.Name.init(rawValue: "WechatLoginHandle")
    }
    struct CacheKey {
        static let baseDataKey = "baseDataKey"
        static let regionKey = "regionKey"
    }
    struct URLKey {
        static let baseURL = (Bundle.main.infoDictionary?["BASE_URL"] as? String) ?? ""
        static let webBaseURL = (Bundle.main.infoDictionary?["WEB_BASE_URL"] as? String) ?? ""
        static let baseImageUrl = (Bundle.main.infoDictionary?["BASE_IMAGE_URL"] as? String) ?? ""
    }
    struct Color {
        static let mainBackgroundColor: UInt32 = 0xf3f3f3
        static let mainColor: UInt32 = 0xffab33
        static let mainBlueColor: UInt32 = 0x00a8fe
        static let tabBackgroundColor: UInt32 = 0xffffff
        static let viewBackgroundColor: UInt32 = 0xf2f2f2
        static let redDotColor: UInt32 = 0xFF3824
        static let lineColor: UInt32 = 0xe5e5e5
        static let greyColor: UInt32 = 0xa0a0a0
        static let mainBlackColor: UInt32 = 0x000000
        static let mainOrangeColor: UInt32 = 0xFBC205
        static let mainGreenColor: UInt32 = 0x30C7AC
        static let dividerLineColor: UInt32 = 0xcccccc
    }
    struct UserDefaultsKey {
        static let session = "sessionInfo"
        static let uuid = "uuid"
        static let userInfo =  "userinfo.archiver"
        static let searchHistory = "searchHistory"
    }
    struct ThirdPartyKey {
        static let qqAppID = "1106254696"
        static let qqAppSecret = "kDKjz1p9jMeQlX9G"
        static let sinaWeiboAppKey = "3825789199"
        static let sinaWeiboAppSecret = "b47aa01fd825551fdb5763d8b4920f75"
        static let sinaWeiboRedirectURI = "https://live.hlhdj.cn/api/oauth/weibo"
        static let sinaWeiboCancelRedirectURI = "https://live.hlhdj.cn/api/oauth/weibo/cannel"
        static let weChatAppID = "wxf0c4e542eb81c4cd"
        static let weChatAppSecret = "155a8487f2b9afe587543863d7ca8a44"
        static let shareSDKKey = "1f056b48347c8"
        static let shareSDKSecret = "09a428ab441589b0df80abe112371b73"
        static let alipayAppID = "2017070507648660"
        static let TIMAPPID = "1253899389"
        static let TIMSdkAppId: Int32 = 1400033866
        static let TIMAccountType: String = "13870"
        static let JPushAppKey = "3bc3c88cb49b6a7add6356a5"
        static let JPushSecret = "39f7e00ab5782c8302213b28"
        static let JPushChanel = "App Store"
        static let isJPushProdution: Bool = ((Bundle.main.infoDictionary?["Prodution_Flag"] as? String) ?? "true") == "true" ? true: false
    }
    struct Description {
        static let wechatDescription = "Description"
    }
}
