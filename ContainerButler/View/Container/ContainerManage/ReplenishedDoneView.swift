//
//  ReplenishedDoneView.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/18.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ReplenishedDoneView: UIView {
    
  lazy  var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "juic.jpg"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
     lazy  var doneBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 13)
        loginBtn.setTitle("完成补货", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.setTitleColor(UIColor.gray, for: .highlighted)
        loginBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainGreenColor)
        loginBtn.layer.cornerRadius = 18
        loginBtn.layer.masksToBounds = true
        return loginBtn
    }()
    
     lazy  var closeBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "delete"), for: .normal)
        return loginBtn
    }()
    
     lazy  var rechooseBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 13)
        loginBtn.setTitle("重新拍照", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
         loginBtn.setTitleColor(UIColor.gray, for: .highlighted)
        loginBtn.layer.cornerRadius = 18
        loginBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainOrangeColor)
        return loginBtn
    }()
    
  fileprivate  lazy  var bgView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "dashed"))
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReplenishedDoneView {
    fileprivate func setupUI() {
        let contanierView = UIView()
        contanierView.layer.cornerRadius = 12.5
        contanierView.layer.masksToBounds = true
        contanierView.layer.borderWidth = 2
        contanierView.layer.borderColor = UIColor.gray.cgColor
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        contanierView.backgroundColor = .white
        contanierView.addSubview(imageView)
         contanierView.addSubview(bgView)
        contanierView.addSubview(doneBtn)
        
        addSubview(closeBtn)
        contanierView.addSubview(rechooseBtn)
        addSubview(contanierView)
        contanierView.snp.makeConstraints { (maker) in
            maker.left.equalTo(40.0.fitWidth)
            maker.right.equalTo(-40.0.fitWidth)
            maker.top.equalTo(109.0.fitHeight)
            maker.bottom.equalTo(-172.0.fitHeight)
        }
        
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(25)
            maker.left.equalTo(25)
            maker.right.equalTo(-25)
            maker.height.equalTo(243.0.fitHeight)
        }
        
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageView.snp.top)
            maker.left.equalTo(imageView.snp.left)
            maker.right.equalTo(imageView.snp.right)
            maker.height.equalTo(imageView.snp.height)
        }
        
        rechooseBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageView.snp.bottom).offset(46.0.fitHeight)
            maker.left.equalTo(30)
            maker.width.equalTo(100.0.fitWidth)
            maker.height.equalTo(36)
        }
        doneBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(rechooseBtn.snp.top)
            maker.right.equalTo(-30)
            maker.width.equalTo(100.0.fitWidth)
            maker.height.equalTo(36)
        }
       
        closeBtn.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(contanierView.snp.top).offset(-20)
            maker.right.equalTo(contanierView.snp.right).offset(-5)
            maker.height.equalTo(40)
            maker.width.equalTo(40)
        }
    }
}
