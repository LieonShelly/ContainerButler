//
//  UserHeaderCell.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class UserHeaderCell: UITableViewCell, ViewNameReusable {
     lazy  var userLog: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 16)
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        descLabel.text = "用户：1234567890"
        return descLabel
    }()
    
    fileprivate lazy  var bgView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4.0
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.backgroundColor = UIColor.white
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        let line = UIView()
        line.backgroundColor = UIColor(hex: CustomKey.Color.dividerLineColor)
        contentView.addSubview(line)
        contentView.addSubview(bgView)
        bgView.addSubview(userLog)
        bgView.addSubview(titleLabel)
        
        bgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.height.equalTo(80)
            maker.right.equalTo(0)
            maker.top.equalTo(0)
        }
        userLog.snp.makeConstraints {
            $0.left.equalTo(12)
            $0.centerY.equalTo(bgView.snp.centerY)
            $0.width.equalTo(70)
            $0.height.equalTo(70)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(userLog.snp.right).offset(13)
            $0.centerY.equalTo(bgView.snp.centerY)
        }
        
        line.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.height.equalTo(0.5)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
