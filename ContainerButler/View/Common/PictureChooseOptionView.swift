//
//  PictureChooseOptionView.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/18.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import UIKit

class PictureChooseOptionView: UIView {
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: CustomKey.Color.dividerLineColor)
        return view
    }()

    fileprivate lazy  var line1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: CustomKey.Color.dividerLineColor)
        return view
    }()

  lazy  var cameraBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.5)
        loginBtn.backgroundColor = .white
        loginBtn.setTitle("拍照", for: .normal)
        loginBtn.setTitleColor(UIColor(hex: 0x333333), for: .normal)
         loginBtn.setTitleColor(UIColor.gray, for: .highlighted)
        return loginBtn
    }()
  lazy  var photoBtn: UIButton = {
        let loginBtn = UIButton()
          loginBtn.backgroundColor = .white
        loginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.5)
        loginBtn.setTitle("从手机相册选择", for: .normal)
        loginBtn.setTitleColor(UIColor(hex: 0x333333), for: .normal)
        loginBtn.setTitleColor(UIColor.gray, for: .highlighted)
        return loginBtn
    }()
  lazy  var cancleBtn: UIButton = {
        let loginBtn = UIButton()
       loginBtn.backgroundColor = .white
        loginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        loginBtn.setTitle("取消", for: .normal)
        loginBtn.setTitleColor(UIColor.red, for: .normal)
        loginBtn.setTitleColor(UIColor.gray, for: .highlighted)
        return loginBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(cameraBtn)
         addSubview(photoBtn)
         addSubview(cancleBtn)
         addSubview(line0)
         addSubview(line1)
       
        cancleBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
            maker.height.equalTo(50)
        }
        line1.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(cancleBtn.snp.top)
            maker.height.equalTo(12)
        }
        photoBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(line1.snp.top).offset(0)
            maker.height.equalTo(50)
        }
        line0.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(photoBtn.snp.top)
            maker.height.equalTo(0.5)
        }
        cameraBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(line0.snp.top)
            maker.height.equalTo(50)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
