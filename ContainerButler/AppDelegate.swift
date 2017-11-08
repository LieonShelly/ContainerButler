//
//  AppDelegate.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/11.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
// swiftlint:disable force_unwrapping

import UIKit
import CoreData
import IQKeyboardManagerSwift
import RxCocoa
import RxSwift
import ObjectMapper
import NotificationCenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var rsaPublickey: String?
    fileprivate let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupUI()
        chooseRootVC()
        startLocate()
        addNotification() 
        setupJPush(option: launchOptions ?? [:])
        checkPush(with: launchOptions)
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenStr = deviceToken.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
         NSLog("=====DeviceToken:%@", deviceTokenStr)
         JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
          NSLog("did Fail To Register For Remote Notifications With Error: %@", error.localizedDescription)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.sharedInstance.saveContext()
    }
}

extension AppDelegate {
    fileprivate func setupUI() {
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(hex: CustomKey.Color.tabBackgroundColor)
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = UIColor(hex: CustomKey.Color.mainOrangeColor)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        if let font = UIFont(name: "PingFangSC-Medium", size: 17) {
            UINavigationBar.appearance().titleTextAttributes =
                [NSAttributedStringKey.foregroundColor: UIColor.black,
                 NSAttributedStringKey.font: font]
        }
        let keyboardManager = IQKeyboardManager.sharedManager()
        keyboardManager.enableAutoToolbar = true
        keyboardManager.enable = true
        keyboardManager.shouldResignOnTouchOutside = true
        keyboardManager.shouldShowToolbarPlaceholder = false
    }
    
    fileprivate func chooseRootVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        var rootVC: UIViewController?
        if let token = CoreDataManager.sharedInstance.getSessionInfo()?.token, !token.isEmpty {
            rootVC = TabBarController()
        } else {/// 没有token进行登录
            rootVC = NavigationController(rootViewController: LoginViewController())
        }
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    fileprivate func startLocate() {
        Location.share.startLocate()
    }
    
    fileprivate func addNotification() {
        NotificationCenter.default.rx
            .notification(CustomKey.NotificationName.loginInvalid)
            .subscribe(onNext: { _ in
                guard let view = self.window else { return }
                let rootVC = NavigationController(rootViewController: LoginViewController())
                UIView.transition(with: view, duration: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    self.window?.rootViewController?.view.removeFromSuperview()
                }, completion: { (_) in
                    UIApplication.shared.keyWindow?.rootViewController = rootVC
                })
                
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func  setupJPush(option: [UIApplicationLaunchOptionsKey: Any]) {
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue |  JPAuthorizationOptions.sound.rawValue |  JPAuthorizationOptions.badge.rawValue)
        let isProduction = CustomKey.ThirdPartyKey.isJPushProdution
         NSLog("=====Prodution_Flag:%@", (Bundle.main.infoDictionary?["Prodution_Flag"] as? String ?? ""))
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
         JPUSHService.setup(withOption: option, appKey: CustomKey.ThirdPartyKey.JPushAppKey, channel: CustomKey.ThirdPartyKey.JPushChanel, apsForProduction: isProduction)
        JPUSHService.registrationIDCompletionHandler { (_, registrationID) in
            if let registrationID = registrationID, !registrationID.isEmpty {
                 NSLog("=====registrationID:%@", registrationID)
            }
        }
    }
    
    fileprivate func checkPush(with option: [UIApplicationLaunchOptionsKey: Any]?) {
        if let option = option, let userInfo = option[UIApplicationLaunchOptionsKey.remoteNotification] {
            print(userInfo)
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}

extension AppDelegate: JPUSHRegisterDelegate {
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if let trigger = response.notification.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.self) {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
         let userInfo = notification.request.content.userInfo
        if let trigger = notification.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.self) {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
     // Required, iOS 7 Support
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
     // Required,For systems with less than or equal to iOS6
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }

}
