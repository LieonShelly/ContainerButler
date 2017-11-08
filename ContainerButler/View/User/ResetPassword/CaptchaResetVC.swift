//
//  CaptchaResetVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/9.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CaptchaResetVC: BaseViewController {
    var phoneNumber: String?
    
    fileprivate lazy  var descPwdLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: CGFloat(22.5))
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.text = "填写验证码"
        descLabel.numberOfLines = 0
        return descLabel
    }()
    fileprivate lazy  var phoneNumTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入手机号"
        textField.font = UIFont.sizeToFit(with: 14)
        textField.textColor = UIColor(hex: 0x222222)
        textField.keyboardType = .numberPad
        textField.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        return textField
    }()
    fileprivate lazy   var pwdTF: UITextField = {
        let pwdTF = UITextField()
        pwdTF.placeholder = "请输入验证码"
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
    fileprivate lazy   var forgetPwdBtn: UIButton = {
        let forgetPwdBtn = UIButton()
        forgetPwdBtn.sizeToFit()
        forgetPwdBtn.titleLabel?.font = UIFont.sizeToFit(with: 13)
        forgetPwdBtn.setTitle("发送验证码", for: .normal)
        forgetPwdBtn.titleLabel?.textAlignment = .center
        forgetPwdBtn.setTitleColor(UIColor(hex: 0x333333), for: .normal)
        forgetPwdBtn.setTitleColor(UIColor.gray, for: .highlighted)
        forgetPwdBtn.setTitleColor(UIColor.gray, for: .disabled)
        forgetPwdBtn.layer.borderColor = UIColor.gray.cgColor
        forgetPwdBtn.layer.borderWidth = 0.5
        forgetPwdBtn.layer.cornerRadius = 3
        return forgetPwdBtn
    }()
    fileprivate lazy  var loginBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        loginBtn.setTitle("下 一 步", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.layer.cornerRadius = 20
        loginBtn.layer.masksToBounds = true
        loginBtn.isEnabled = false
        return loginBtn
    }()
    fileprivate lazy   var pwdIcon: UIImageView = {
        let pwdLog = UIImageView(image: UIImage(named: "sms"))
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
    fileprivate lazy var pwdError: YYLabel = {
        let label = YYLabel()
        let  text = NSMutableAttributedString()
        let image = UIImage(named: "error_warning")
        let attach = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .center, attachmentSize: CGSize(width: 16, height: 16), alignTo: UIFont.systemFont(ofSize: 12), alignment: .center)
        let padding = NSMutableAttributedString(string: "  ")
        let text1 = NSMutableAttributedString(string: "验证码错误，请重新输入")
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
    fileprivate lazy var phoneError: YYLabel = {
        let label = YYLabel()
        let  text = NSMutableAttributedString()
        let image = UIImage(named: "error_warning")
        let attach = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .center, attachmentSize: CGSize(width: 16, height: 16), alignTo: UIFont.systemFont(ofSize: 12), alignment: .center)
        let padding = NSMutableAttributedString(string: "  ")
        let text1 = NSMutableAttributedString(string: "用户不存在")
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

extension CaptchaResetVC {
    fileprivate func setupUI() {
        phoneNumTF.text = phoneNumber
        view.backgroundColor = .white
        whenHiddenNavigationBarSetupBackBtn()
        view.addSubview(descPwdLabel)
        view.addSubview(userIcon)
        view.addSubview(phoneNumTF)
        view.addSubview(line0)
        view.addSubview(pwdIcon)
        view.addSubview(pwdTF)
        view.addSubview(line1)
        view.addSubview(forgetPwdBtn)
        view.addSubview(line2)
        view.addSubview(loginBtn)
        view.addSubview(pwdError)
         view.addSubview(phoneError)
        descPwdLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(26 + 64)
            maker.centerX.equalTo(view.snp.centerX)
        }
        
        userIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(descPwdLabel.snp.bottom).offset(86.0.fitHeight)
            maker.left.equalTo(30)
            maker.width.equalTo(20)
        }
        phoneNumTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.right).offset(20)
            maker.centerY.equalTo(userIcon.snp.centerY)
            maker.right.equalTo(-30)
        }
        line0.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.top.equalTo(userIcon.snp.bottom).offset(22)
            maker.right.equalTo(-20)
            maker.height.equalTo(1)
        }
        
        forgetPwdBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(phoneNumTF.snp.centerY)
            maker.right.equalTo(-30)
            maker.height.equalTo(30)
            maker.width.equalTo(90)
        }
        phoneError.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.right).offset(20)
            maker.centerY.equalTo(userIcon.snp.centerY)
            maker.right.equalTo(forgetPwdBtn.snp.left)
        }
        pwdIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.left)
            maker.top.equalTo(line0.snp.bottom).offset(22)
            maker.width.equalTo(20)
        }
        
        line2.snp.makeConstraints { (maker) in
            maker.top.equalTo(pwdIcon.snp.bottom).offset(20)
            maker.left.equalTo(line0.snp.left)
            maker.right.equalTo(line0.snp.right)
            maker.height.equalTo(1)
        }
        pwdError.snp.makeConstraints { (maker) in
            maker.left.equalTo(phoneNumTF.snp.left)
            maker.right.equalTo(-30)
            maker.centerY.equalTo(pwdIcon.snp.centerY)
        }
        pwdTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(phoneNumTF.snp.left)
            maker.right.equalTo(-30)
            maker.centerY.equalTo(pwdIcon.snp.centerY)
            
        }
        
        loginBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(line2.snp.bottom).offset(50)
            maker.left.equalTo(30)
            maker.right.equalTo(-30)
            maker.height.equalTo(50.0.fitHeight)
        }
    }
    
    fileprivate func setupRx() {
        let usernameValid = phoneNumTF.rx.text.orEmpty
            .map { $0.count >= 11}
            .share(replay: 1)
        
        let passwordValid = pwdTF.rx.text.orEmpty
            .map { $0.count >= 6 }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        
        everythingValid
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        pwdTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.count <= 6 ? text: (String(text[ ..<text.index(text.startIndex, offsetBy: 6)]))
            }
            .share(replay: 1)
            .bind(to: pwdTF.rx.text)
            .disposed(by: disposeBag)
        
        phoneNumTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.count <= 11 ? text: String(text[ ..<text.index(text.startIndex, offsetBy: 11)])
            }
            .share(replay: 1)
            .bind(to: phoneNumTF.rx.text)
            .disposed(by: disposeBag)
        
        usernameValid
            .bind(to: forgetPwdBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        forgetPwdBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let weakSelf = self else {    return      }
                HUD.showAlert(from: weakSelf, title: "确认手机号码",
                              message: "我们将发送验证码短信到这个号码：\n +86 \(weakSelf.phoneNumTF.text ?? "")",
                    enterTitle: "好",
                    enterAction: {
                        let param = UserSessionParam()
                        param.phoneNum = self?.phoneNumTF.text
                        param.verifyCodeType = .resetPassword
                        let chaptchVM = UserSessionViewModel()
                        chaptchVM.getVerificationCode(param).subscribe(onNext: {  _ in
                            weakSelf.forgetPwdBtn.start(withTime: 60, title: "发送验证码", countDownTitle: "S", normalColor: UIColor(hex: 0x333333), count: UIColor(hex: CustomKey.Color.mainOrangeColor))
                        }, onError: { (error) in
                            if let error = error as? AppError {
                                self?.showError(error)
                            }
                        }).disposed(by: weakSelf.disposeBag)
                }, cancleAction: nil)
            })
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                print("login:\(self.debugDescription)")
                guard let weakSelf = self, let pwdText = weakSelf.pwdTF.text  else { return }
                if pwdText.isEmpty {
                    weakSelf.pwdTF.shake()
                    return
                }
               
                let param = UserSessionParam()
                param.phoneNum = self?.phoneNumTF.text
                param.verificationCode = self?.pwdTF.text
                let chaptchVM = UserSessionViewModel()
                chaptchVM.handle(with: .verifyForgetPwdCaptchCode(param))
                    .subscribe(onNext: { [weak self](response) in
                        let vcc = ResetPasswordVC()
                        vcc.phoneNumber = self?.phoneNumTF.text
                        self?.navigationController?.pushViewController(vcc, animated: true)
                    }, onError: { [weak self](error) in
                        if let error = error as? AppError {
                            HUD.hideLoading()
                            self?.showError(error)
                        }
                    }).disposed(by: weakSelf.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
    private func showError(_ error: AppError) {
        if error.status == .capchaError {
            pwdError.isHidden = false
            phoneError.isHidden = true
            pwdError.shake(30, withDelta: 1, speed: 0.03, completion: {[weak self] in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    guard let weakSelf = self else {    return  }
                    weakSelf.pwdError.isHidden = true
                })
            })
        } else  if error.status == .phoneNumError {
            pwdError.isHidden = true
            phoneError.isHidden = false
            phoneError.shake(30, withDelta: 1, speed: 0.03, completion: {[weak self] in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    guard let weakSelf = self else {    return  }
                    weakSelf.phoneError.isHidden = true
                })
            })
        }
    }
}
