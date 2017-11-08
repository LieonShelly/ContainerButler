//
//  LabelButtonCell.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/26.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class LabelButtonCell: UITableViewCell, ViewNameReusable {

    var leftLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        return descLabel
    }()
    
  lazy  var rightBtn: UIButton = {[weak self] in
        let loginBtn = UIButton()
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 14)
        loginBtn.setTitleColor(UIColor(hex: 0x30C7AC), for: .normal)
         loginBtn.setTitleColor(UIColor.gray, for: .highlighted)
        return loginBtn
        }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightBtn)
        leftLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        rightBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-15)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
