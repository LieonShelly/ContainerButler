//
//  UpdatePasswordVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UpdatePasswordVC: BaseViewController {
    fileprivate lazy  var  sessionVM = UserSessionViewModel()
    fileprivate lazy  var descPwdLabel0: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: CGFloat(22.5))
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.text = "设置密码"
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        return descLabel
    }()
    var phoneNumber: String?
    fileprivate lazy  var phoneNumTF: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.placeholder = "请输入旧密码"
        textField.font = UIFont.sizeToFit(with: 15)
        textField.textColor = UIColor(hex: 0x222222)
        textField.tintColor = UIColor(hex: CustomKey.Color.mainColor)
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
        let imageView = UIImageView(image: UIImage(named: "user_center_pwd"))
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
    fileprivate lazy  var forgetBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 12)
        loginBtn.setTitle("忘记旧密码？", for: .normal)
        loginBtn.setTitleColor(UIColor.mainOrange, for: .normal)
        loginBtn.setTitleColor(UIColor.gray, for: .highlighted)
        return loginBtn
    }()
    
    fileprivate lazy var againPwdError: YYLabel = {
        let label = YYLabel()
        label.backgroundColor = UIColor.white
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
        return label
    }()
    
    fileprivate lazy  var visiableBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setImage(UIImage(named: "eye"), for: .selected)
        loginBtn.setImage(UIImage(named: "eye_grey"), for: .normal)
        return loginBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
}

extension UpdatePasswordVC {
    fileprivate func setupUI() {
        title = "密码"
        view.backgroundColor = .white
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
        view.addSubview(forgetBtn)
        view.addSubview(againPwdError)
        view.addSubview(visiableBtn)
        
        userIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(40)
            maker.top.equalTo(98.5.fitHeight)
            maker.width.equalTo(20)
        }
        phoneNumTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.right).offset(20)
            maker.right.equalTo(view.snp.right).offset(-20)
            maker.height.equalTo(35)
            maker.centerY.equalTo(userIcon.snp.centerY)
        }
        line0.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.left)
            maker.top.equalTo(phoneNumTF.snp.bottom).offset(12)
            maker.right.equalTo(-20)
            maker.height.equalTo(1)
        }
        
        pwdIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.left)
            maker.top.equalTo(line0.snp.bottom).offset(22)
            maker.width.equalTo(20)
        }
        
        pwdTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(phoneNumTF.snp.left)
            maker.right.equalTo(phoneNumTF.snp.right)
            maker.centerY.equalTo(pwdIcon.snp.centerY)
            maker.height.equalTo(35)
        }
        visiableBtn.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 25, height: 15))
            maker.right.equalTo(line0.snp.right)
            maker.centerY.equalTo(pwdIcon.snp.centerY)
        }
        
        line1.snp.makeConstraints { (maker) in
            maker.top.equalTo(pwdIcon.snp.bottom).offset(22)
            maker.left.equalTo(line0.snp.left)
            maker.right.equalTo(line0.snp.right)
            maker.height.equalTo(1)
        }
        
        pwdIconAgain.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.left)
            maker.top.equalTo(line1.snp.bottom).offset(22)
            maker.width.equalTo(20)
        }
        againPwdError.snp.makeConstraints { (maker) in
            maker.left.equalTo(pwdTFAgain.snp.left)
            maker.right.equalTo(pwdTFAgain.snp.right)
            maker.top.equalTo(pwdTFAgain.snp.top)
            maker.bottom.equalTo(pwdTFAgain.snp.bottom)
        }
        pwdTFAgain.snp.makeConstraints { (maker) in
            maker.left.equalTo(phoneNumTF.snp.left)
            maker.right.equalTo(-20)
            maker.centerY.equalTo(pwdIconAgain.snp.centerY)
            maker.height.equalTo(35)
        }
        
        line2.snp.makeConstraints { (maker) in
            maker.top.equalTo(pwdIconAgain.snp.bottom).offset(22)
            maker.left.equalTo(line1.snp.left)
            maker.right.equalTo(line1.snp.right)
            maker.height.equalTo(1)
        }
        
        descPwdLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(line2.snp.left)
            maker.top.equalTo(line2.snp.top).offset(25)
            maker.right.equalTo(-20)
        }
        forgetBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(line2.snp.left)
            maker.top.equalTo(descPwdLabel.snp.bottom).offset(17)
        }
        
        enterBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(forgetBtn.snp.bottom).offset(46.5 .fitHeight)
            maker.left.equalTo(32)
            maker.right.equalTo(-32)
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
                            weakSelf.againPwdError.isHidden = true
                        })
                    })
                    return
                }
                weakSelf
                    .sessionVM
                    .loadRSAPublickey()
                    .map { (key) -> (String?, String?) in
                        let oldRsaPwd = weakSelf.phoneNumTF.text?.rsaEncryptor(with: key)
                        let newRsaPwd = weakSelf.pwdTF.text?.rsaEncryptor(with: key)
                        return (oldRsaPwd, newRsaPwd)
                    }
                    .map({ (oldRsaPwd, newRsaPwd) -> UserSessionParam in
                        let param = UserSessionParam()
                        param.phoneNum = CoreDataManager.sharedInstance.getUserInfo()?.phoneNum
                        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
                        param.oldPwd = oldRsaPwd
                        param.newPassword = newRsaPwd
                        return param
                    })
                    .subscribe(onNext: { (param) in
                        weakSelf.sessionVM.handle(with: UserSessionHandleType.updatePasswod(param))
                            .subscribe(onNext: {response in
                                weakSelf.navigationController?.popToRootViewController(animated: true)
                            }, onError: { (error) in
                                if let error = error as? AppError {
                                    HUD.showError(error.message)
                                }
                            }).disposed(by: weakSelf.disposeBag)
                    })
                .disposed(by: weakSelf.disposeBag)
            })
            .disposed(by: disposeBag)
        
        forgetBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let weakSelf = self else {    return      }
                weakSelf.navigationController?.pushViewController(CaptchaResetVC(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
