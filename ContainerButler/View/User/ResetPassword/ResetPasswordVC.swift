//
//  ResetPasswordVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ResetPasswordVC: BaseViewController {
      var phoneNumber: String?
    fileprivate lazy  var descPwdLabel0: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: CGFloat(22.5))
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.text = "设置密码"
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        return descLabel
    }()
    fileprivate lazy  var phoneNumTF: UITextField = {[unowned self] in
        let textField = UITextField()
        textField.placeholder = "请输入您的手机号"
        textField.font = UIFont.sizeToFit(with: 14)
        textField.textColor = UIColor(hex: 0x222222)
        textField.keyboardType = .numberPad
        textField.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        textField.text = self.phoneNumber
        return textField
    }()
    fileprivate lazy   var pwdTF: UITextField = {
        let pwdTF = UITextField()
        pwdTF.isSecureTextEntry = true
        pwdTF.placeholder = "请输入新密码"
        pwdTF.textColor = UIColor(hex: 0x222222)
        pwdTF.font = UIFont.sizeToFit(with: 14)
        pwdTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .done
        return pwdTF
    }()
    fileprivate lazy   var pwdTFAgain: UITextField = {
        let pwdTF = UITextField()
        pwdTF.isSecureTextEntry = true
        pwdTF.placeholder = "请再次输入新密码"
        pwdTF.textColor = UIColor(hex: 0x222222)
        pwdTF.font = UIFont.sizeToFit(with: 14)
        pwdTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .done
        return pwdTF
    }()
    fileprivate lazy  var userIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "user_center_account"))
        imageView.contentMode = .center
        return imageView
    }()

    fileprivate lazy  var descPwdLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: CGFloat(13))
        descLabel.textColor = UIColor(hex: 0x808080)
        descLabel.text = "密码必须至少8个字符，而且同时包含字母和数字"
        descLabel.numberOfLines = 0
        return descLabel
    }()

    fileprivate lazy   var pwdIcon: UIImageView = {
        let pwdLog = UIImageView(image: UIImage(named: "user_center_pwd"))
        pwdLog.contentMode = .center
        return pwdLog
    }()
    
    fileprivate lazy   var pwdIconAgain: UIImageView = {
        let pwdLog = UIImageView(image: UIImage(named: "user_center_pwd"))
        pwdLog.contentMode = .center
        return pwdLog
    }()
    
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: CustomKey.Color.dividerLineColor)
        return view
    }()
    fileprivate lazy   var line1: UIView  = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: CustomKey.Color.dividerLineColor)
        return view
    }()
    fileprivate lazy  var line2: UIView  = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: CustomKey.Color.dividerLineColor)
        return view
    }()
    fileprivate lazy  var enterBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        loginBtn.setTitle("确 定", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .disabled)
        loginBtn.setTitleColor(UIColor.gray, for: .highlighted)
        loginBtn.isEnabled = false
        return loginBtn
    }()
    
    fileprivate lazy  var visiableBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setImage(UIImage(named: "eye"), for: .selected)
        loginBtn.setImage(UIImage(named: "eye_grey"), for: .normal)
        return loginBtn
    }()
    
    fileprivate lazy var newPwdError: YYLabel = {
        let label = YYLabel()
        let  text = NSMutableAttributedString()
        let image = UIImage(named: "error_warning")
        let attach = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .center, attachmentSize: CGSize(width: 16, height: 16), alignTo: UIFont.systemFont(ofSize: 12), alignment: .center)
        let padding = NSMutableAttributedString(string: "  ")
        let text1 = NSMutableAttributedString(string: "密码格式错误")
        text1.yy_font = UIFont.systemFont(ofSize: 12)
        text1.yy_color = UIColor(hex: 0xBB2C2B)
        text.append(attach)
        text.append(padding)
        text.append(text1)
        label.isHidden = true
        label.attributedText = text
        return label
    }()
    
    fileprivate lazy var againPwdError: YYLabel = {
        let label = YYLabel()
        let  text = NSMutableAttributedString()
        let image = UIImage(named: "error_warning")
        let attach = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .center, attachmentSize: CGSize(width: 16, height: 16), alignTo: UIFont.systemFont(ofSize: 12), alignment: .center)
        let padding = NSMutableAttributedString(string: "  ")
        let text1 = NSMutableAttributedString(string: "两次密码不一致")
        text1.yy_font = UIFont.systemFont(ofSize: 12)
        text1.yy_color = UIColor(hex: 0xBB2C2B)
        text.append(attach)
        text.append(padding)
        text.append(text1)
        label.isHidden = true
        label.attributedText = text
        label.backgroundColor = .white
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }

}

extension ResetPasswordVC {
    fileprivate func setupUI() {
        phoneNumTF.text = phoneNumber
        view.backgroundColor = .white
       whenHiddenNavigationBarSetupBackBtn()
        view.addSubview(descPwdLabel0)
        view.addSubview(userIcon)
        view.addSubview(phoneNumTF)
        view.addSubview(line0)
        view.addSubview(pwdIcon)
        view.addSubview(pwdTF)
         view.addSubview(pwdIconAgain)
        view.addSubview(pwdTFAgain)
        view.addSubview(line1)
        view.addSubview(line2)
        view.addSubview(descPwdLabel)
        view.addSubview(enterBtn)
        view.addSubview(newPwdError)
        view.addSubview(againPwdError)
        view.addSubview(visiableBtn)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: enterBtn)
        descPwdLabel0.snp.makeConstraints { (maker) in
            maker.top.equalTo(26 + 64)
            maker.centerX.equalTo(view.snp.centerX)
        }
        userIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(43)
            maker.top.equalTo(descPwdLabel0.snp.bottom).offset(82.0.fitHeight)
            maker.width.equalTo(20)
        }
        phoneNumTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.right).offset(20)
            maker.right.equalTo(view.snp.right).offset(-20)
            maker.height.equalTo(35)
            maker.centerY.equalTo(userIcon.snp.centerY)
        }
        line0.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.left).offset(-6)
            maker.top.equalTo(phoneNumTF.snp.bottom).offset(22)
            maker.right.equalTo(-20)
            maker.height.equalTo(1)
        }
        
        pwdIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.left)
            maker.top.equalTo(line0.snp.bottom).offset(22)
            maker.width.equalTo(20)
        }
        visiableBtn.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 25, height: 15))
            maker.right.equalTo(line0.snp.right)
            maker.centerY.equalTo(pwdIcon.snp.centerY)
        }
        newPwdError.snp.makeConstraints { (maker) in
            maker.right.equalTo(visiableBtn.snp.left)
            maker.centerY.equalTo(pwdIcon.snp.centerY)
            maker.width.equalTo(100.0.fitWidth)
        }
        pwdTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(phoneNumTF.snp.left)
            maker.right.equalTo(newPwdError.snp.left).offset(-8)
            maker.centerY.equalTo(pwdIcon.snp.centerY)
        }
        
        line1.snp.makeConstraints { (maker) in
            maker.top.equalTo(pwdIcon.snp.bottom).offset(20)
            maker.left.equalTo(line0.snp.left)
            maker.right.equalTo(line0.snp.right)
            maker.height.equalTo(1)
        }
 
        pwdIconAgain.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.left)
            maker.top.equalTo(line1.snp.bottom).offset(20)
            maker.width.equalTo(20)
        }
        
        againPwdError.snp.makeConstraints { (maker) in
            maker.left.equalTo(phoneNumTF.snp.left)
            maker.right.equalTo(-30)
            maker.centerY.equalTo(pwdIconAgain.snp.centerY)
        }
        
        pwdTFAgain.snp.makeConstraints { (maker) in
            maker.left.equalTo(phoneNumTF.snp.left)
            maker.right.equalTo(-30)
            maker.centerY.equalTo(pwdIconAgain.snp.centerY)
        }
        
        line2.snp.makeConstraints { (maker) in
            maker.top.equalTo(pwdIconAgain.snp.bottom).offset(20)
            maker.left.equalTo(line1.snp.left)
            maker.right.equalTo(line1.snp.right)
            maker.height.equalTo(1)
        }
        
        descPwdLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(line2.snp.left)
            maker.top.equalTo(line2.snp.top).offset(25)
            maker.right.equalTo(-20)
        }
        
        enterBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(descPwdLabel.snp.bottom).offset(46.5 .fitHeight)
            maker.left.equalTo(30)
            maker.right.equalTo(-30)
            maker.height.equalTo(50.0.fitHeight)
        }
    }
    
     fileprivate func setupRx() {
        let repeatPasswordValid = pwdTFAgain.rx.text.orEmpty
            .map { $0.count >= 8 }
            .share(replay: 1)
            .share(replay: 1)
        
        let passwordValid = pwdTF.rx.text.orEmpty
            .map { $0.validatePassword()}
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(repeatPasswordValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        
        everythingValid
            .bind(to: enterBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        visiableBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let weakSelf = self else {    return      }
                weakSelf.visiableBtn.isSelected = !weakSelf.visiableBtn.isSelected
                self?.pwdTF.isSecureTextEntry = !weakSelf.visiableBtn.isSelected
            })
            .disposed(by: disposeBag)
        
        enterBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let weakSelf = self else {    return      }
                if weakSelf.pwdTFAgain.text != weakSelf.pwdTF.text {
                    weakSelf.againPwdError.isHidden = false
                    weakSelf.againPwdError.shake(30, withDelta: 1, speed: 0.03, completion: {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                            guard let weakSelf = self else {    return  }
                             weakSelf.againPwdError.isHidden = true
                        })
                    })
                    return
                }
                HUD.showLoading()
                let restVM = UserSessionViewModel()
                restVM
                     .loadRSAPublickey()
                     .map {weakSelf.pwdTF.text?.rsaEncryptor(with: $0)}
                     .map({ (rsaPwd) -> UserSessionParam in
                        let param = UserSessionParam()
                        param.newPassword = rsaPwd
                        param.phoneNum = weakSelf.phoneNumber
                        return param
                    })
                    .subscribe(onNext: { (param) in
                        restVM.handleUserInfoResponse(with: UserSessionHandleType.resetPasswod(param))
                            .subscribe(onNext: {  _ in
                                HUD.showSuccess("密码设置成功", completed: {
                                    guard let view = weakSelf.view else { return }
                                    let rootVC = TabBarController()
                                    UIView.transition(with: view, duration: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                                        UIApplication.shared.keyWindow?.rootViewController?.view.removeFromSuperview()
                                    }, completion: { (_) in
                                        UIApplication.shared.keyWindow?.rootViewController = rootVC
                                    })
                                })
                            }, onError: { (error) in
                                if let error = error as? AppError {
                                    HUD.showError(error.message)
                                }
                            })
                            .disposed(by: weakSelf.disposeBag)
                    }).disposed(by: weakSelf.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
