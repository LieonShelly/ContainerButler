//
//  HUD.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/12.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
// swiftlint:disable function_parameter_count
// swiftlint:disable legacy_constructor

import UIKit
import SVProgressHUD

class HUD {
    static func showAlert(from currentVC: UIViewController,
                              title: String?,
                              message: String?,
                              enterTitle: String?,
                              isHiddenCancleTitle: Bool = false,
                              cancleTitle: String? = "取消",
                              enterAction: (() -> Void)?,
                              cancleAction: (() -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let title = title {
            let titleText = NSMutableAttributedString(string: title )
            titleText.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.5)], range: NSMakeRange(0, title.count))
            alertVC.setValue(titleText, forKey: "attributedTitle")
        }
        if let message = message {
            let messageText = NSMutableAttributedString(string: message )
            messageText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor(hex: 0x333333)], range: NSMakeRange(0, message.count))
            alertVC.setValue(messageText, forKey: "attributedMessage")
        }
        if let enter = enterTitle, !enter.isEmpty {
            let enterAction = UIAlertAction(title: enter, style: .default, handler: { (_) in
                enterAction?()
            })
            alertVC.addAction(enterAction)
            enterAction.setValue(UIColor(hex: 0x333333), forKey: "titleTextColor")
        }
        
        if !isHiddenCancleTitle {
            let cancleAction = UIAlertAction(title: cancleTitle, style: .default, handler: { (_) in
                cancleAction?()
            })
            cancleAction.setValue(UIColor(hex: 0x333333), forKey: "titleTextColor")
            alertVC.addAction(cancleAction)
        }
        currentVC.present(alertVC, animated: true, completion: nil)
    }
    
    static func showLoading() {
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
        SVProgressHUD.setRingNoTextRadius(10)
        SVProgressHUD.show()
    }
    
    static func hideLoading() {
         UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
        SVProgressHUD.dismiss()
    }
    
    static func showError(_ meessage: String) {
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
        SVProgressHUD.setMaximumDismissTimeInterval(2)
        SVProgressHUD.showError(withStatus: meessage)
    }
    
    static func showSuccess(_ message: String, completed: @escaping (() -> Void)) {
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
        SVProgressHUD.setMaximumDismissTimeInterval(2)
        SVProgressHUD.showSuccess(withStatus: message)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: completed)
    }
    
    static func showSuccess(_ message: String) {
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
        SVProgressHUD.setMaximumDismissTimeInterval(2)
        SVProgressHUD.showSuccess(withStatus: message)
        
    }
    
}
