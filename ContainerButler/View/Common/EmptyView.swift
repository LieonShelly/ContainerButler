//
//  EmptyView.swift
//  ContainerButler
//
//  Created by lieon on 2017/11/6.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    var textLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "网络不给力哦..."
        descLabel.font = UIFont.systemFont(ofSize: 18)
        descLabel.textColor = UIColor(hex: 0xbababa)
        descLabel.numberOfLines = 0
        return descLabel
    }()
    lazy  var reloadBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.backgroundColor = .white
        loginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        loginBtn.setTitle("重试", for: .normal)
        loginBtn.setTitleColor(UIColor.mainGreen, for: .normal)
        loginBtn.setTitleColor(UIColor.gray, for: .highlighted)
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.masksToBounds = true
        return loginBtn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageView = UIImageView(image: UIImage(named: "Networkerror"))
         addSubview(textLabel)
           addSubview(imageView)
           addSubview(reloadBtn)
        imageView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.snp.centerX)
            maker.top.equalTo(180.0.fitHeight)
        }
        textLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.snp.centerX)
            maker.top.equalTo(imageView.snp.bottom).offset(30)
        }
        reloadBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.snp.centerX)
            maker.top.equalTo(textLabel.snp.bottom).offset(30)
            maker.size.equalTo(CGSize(width: 233.0.fitWidth, height: 44))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
