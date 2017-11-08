//
//  LoginViewController.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class LoginViewController: BaseViewController {
    fileprivate lazy var loginVM: UserSessionViewModel = UserSessionViewModel()
    fileprivate lazy  var companyIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bg"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    fileprivate lazy var phoneError: YYLabel = {
        let label = YYLabel()
        let  text = NSMutableAttributedString()
        let image = UIImage(named: "error_warning")
       let attach = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .center, attachmentSize: CGSize(width: 16, height: 16), alignTo: UIFont.systemFont(ofSize: 12), alignment: .center)
        let padding = NSMutableAttributedString(string: "  ")
        let text1 = NSMutableAttributedString(string: "请输入正确的管家账号")
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
    fileprivate lazy var pwdError: YYLabel = {
        let label = YYLabel()
        let  text = NSMutableAttributedString()
        let image = UIImage(named: "error_warning")
        let attach = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .center, attachmentSize: CGSize(width: 16, height: 16), alignTo: UIFont.systemFont(ofSize: 12), alignment: .center)
        let padding = NSMutableAttributedString(string: "  ")
        let text1 = NSMutableAttributedString(string: "密码错误，请重新输入")
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
    fileprivate lazy  var phoneNumTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入您的手机号"
        textField.font = UIFont.sizeToFit(with: 14)
        textField.textColor = UIColor(hex: 0x222222)
        textField.keyboardType = .numberPad
        textField.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        textField.text = CoreDataManager.sharedInstance.getUserInfo()?.phoneNum
        return textField
    }()
    fileprivate lazy   var pwdTF: UITextField = {
        let pwdTF = UITextField()
        pwdTF.isSecureTextEntry = true
        pwdTF.placeholder = "请输入您的登录密码"
        pwdTF.textColor = UIColor(hex: 0x222222)
        pwdTF.font = UIFont.sizeToFit(with: 14)
        pwdTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .done
//        pwdTF.text = "111111"
        return pwdTF
    }()
    fileprivate lazy  var userIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "user_center_account"))
        imageView.contentMode = .center
        return imageView
    }()
    fileprivate lazy   var captchdBtn: UIButton = {
        let forgetPwdBtn = UIButton()
        forgetPwdBtn.sizeToFit()
        forgetPwdBtn.titleLabel?.font = UIFont.sizeToFit(with: 14)
        forgetPwdBtn.setTitle("短信验证码登录", for: .normal)
        forgetPwdBtn.setTitleColor(UIColor(hex: 0x999999), for: .normal)
         forgetPwdBtn.setTitleColor(UIColor(hex: 0xfbc205), for: .highlighted)
        return forgetPwdBtn
    }()
    fileprivate lazy   var forgetPwdBtn: UIButton = {
        let forgetPwdBtn = UIButton()
        forgetPwdBtn.sizeToFit()
        forgetPwdBtn.titleLabel?.font = UIFont.sizeToFit(with: 14)
        forgetPwdBtn.setTitle("忘记密码?", for: .normal)
        forgetPwdBtn.setTitleColor(UIColor(hex: 0xfbc205), for: .normal)
        forgetPwdBtn.setTitleColor(UIColor(hex: 0x999999), for: .highlighted)
        return forgetPwdBtn
    }()
    fileprivate lazy  var loginBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        loginBtn.setTitle("登 录", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        return loginBtn
    }()
    fileprivate lazy   var pwdIcon: UIImageView = {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension LoginViewController {
    fileprivate func setupUI() {
        navigationItem.title = "登录"
        view.backgroundColor = .white
        view.addSubview(companyIcon)
        view.addSubview(userIcon)
        view.addSubview(line0)
        view.addSubview(pwdIcon)
        view.addSubview(pwdTF)
        view.addSubview(forgetPwdBtn)
        view.addSubview(line2)
        view.addSubview(loginBtn)
        view.addSubview(captchdBtn)
        view.addSubview(phoneNumTF)
        view.addSubview(phoneError)
        view.addSubview(pwdError)
        companyIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
             maker.left.right.equalTo(0)
            maker.height.equalTo(185.5.fitHeight)
        }
        
        userIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(companyIcon.snp.bottom).offset(55)
            maker.left.equalTo(30.0.fitWidth)
            maker.width.equalTo(20)
        }
        phoneError.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.right).offset(15.0.fitWidth)
            maker.centerY.equalTo(userIcon.snp.centerY)
            maker.right.equalTo(-20)
        }
        phoneNumTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.right).offset(15.0.fitWidth)
            maker.centerY.equalTo(userIcon.snp.centerY)
            maker.right.equalTo(-20)
        }
        
        line0.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.top.equalTo(userIcon.snp.bottom).offset(20)
            maker.right.equalTo(-20)
            maker.height.equalTo(1)
        }
        pwdIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.left)
            maker.top.equalTo(line0.snp.bottom).offset(20)
            maker.width.equalTo(20)
        }
        pwdError.snp.makeConstraints { (maker) in
            maker.left.equalTo(phoneNumTF.snp.left)
            maker.right.equalTo(phoneNumTF.snp.right)
            maker.centerY.equalTo(pwdIcon.snp.centerY)
        }
        pwdTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(phoneNumTF.snp.left)
            maker.right.equalTo(phoneNumTF.snp.right)
            maker.centerY.equalTo(pwdIcon.snp.centerY)
        }
        line2.snp.makeConstraints { (maker) in
            maker.top.equalTo(pwdIcon.snp.bottom).offset(20)
            maker.left.equalTo(line0.snp.left)
            maker.right.equalTo(line0.snp.right)
            maker.height.equalTo(1)
        }
        loginBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(line2.snp.bottom).offset(50)
            maker.left.equalTo(30)
            maker.right.equalTo(-30)
            maker.height.equalTo(50.0.fitHeight)
        }
        captchdBtn.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(forgetPwdBtn.snp.top).offset(-32.0.fitHeight)
            maker.centerX.equalTo(loginBtn.snp.centerX)
            maker.height.equalTo(30)
        }
        forgetPwdBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(loginBtn.snp.centerX)
            maker.height.equalTo(30)
            maker.bottom.equalTo(-30.0.fitHeight)
        }
    }
    
    fileprivate func setupRx() {
        pwdTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.count < 20 ? text: String(text[..<text.index(text.startIndex, offsetBy: 20)])
            }
            .share(replay: 1)
            .bind(to: pwdTF.rx.text)
            .disposed(by: disposeBag)
        
        phoneNumTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.count <= 11 ? text: String(text[..<text.index(text.startIndex, offsetBy: 11)])
            }
            .share(replay: 1)
            .bind(to: phoneNumTF.rx.text)
            .disposed(by: disposeBag)
        
        captchdBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let vcc = CaptchaLoginVC()
                vcc.phoneNumber = self?.phoneNumTF.text
                self?.navigationController?.pushViewController(vcc, animated: true)
            })
            .disposed(by: disposeBag)
        
        forgetPwdBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let vcc = CaptchaResetVC()
                vcc.phoneNumber = self?.phoneNumTF.text
                self?.navigationController?.pushViewController(vcc, animated: true)
            })
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                 guard let weakSelf = self, let phoneText = weakSelf.phoneNumTF.text, let pwdText = weakSelf.pwdTF.text  else { return }
                if phoneText.isEmpty {
                    weakSelf.phoneNumTF.shake()
                    return
                }
                if pwdText.isEmpty {
                    weakSelf.pwdTF.shake()
                    return
                }
                HUD.showLoading()
                weakSelf
                    .loginVM
                    .loadRSAPublickey()
                    .map {weakSelf.pwdTF.text?.rsaEncryptor(with: $0)}
                    .map({ (rsaPwd) -> UserSessionParam in
                        let param = UserSessionParam()
                        param.password = rsaPwd
                        param.phoneNum = weakSelf.phoneNumTF.text
                        return param
                    })
                    .subscribe(onNext: { (param) in
                        weakSelf.loginVM.handleUserInfoResponse(with: .loginWithPassword(param))
                            .subscribe(onNext: { [weak self] (response) in
                                HUD.hideLoading()
                                let rootVC = TabBarController()
                                guard let weakSelf = self else { return }
                                UIView.transition(with: weakSelf.view, duration: 0.25, options: .curveEaseInOut, animations: {
                                    weakSelf.view.removeFromSuperview()
                                    UIApplication.shared.keyWindow?.addSubview(rootVC.view)
                                }, completion: { _ in
                                    UIApplication.shared.keyWindow?.rootViewController = rootVC
                                })
                                }, onError: { [weak self] error in
                                    HUD.hideLoading()
                                    if let error = error as? AppError {
                                        self?.showError(error.status)
                                    }
                            })
                            .disposed(by: weakSelf.disposeBag)
                    }).disposed(by: weakSelf.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    private func showError(_ status: StatusType) {
        switch status {
        case .phoneNumError:
            phoneError.isHidden = false
            pwdError.isHidden = true
            phoneError.shake(30, withDelta: 1, speed: 0.03, completion: {[weak self] in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                       guard let weakSelf = self else {    return  }
                       weakSelf.phoneError.isHidden = true
                })
            })
        case .passwordError:
            pwdError.isHidden = false
            phoneError.isHidden = true
            pwdError.shake(30, withDelta: 1, speed: 0.03, completion: {[weak self] in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    guard let weakSelf = self else {    return  }
                    weakSelf.pwdError.isHidden = true
                })
            })
        default:
            break
        }
    }
}
