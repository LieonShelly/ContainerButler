//
//  TitleLabelTableViewCell.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class TitleLabelTableViewCell: UITableViewCell, ViewNameReusable {
    var titleLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 15)
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        descLabel.text = "补货通知"
        return descLabel
    }()
    
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xcccccc)
        return view
    }()
    
    lazy  var icon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "password"))
        imageView.contentMode = .center
        return imageView
    }()
    
     lazy  var arrowIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "arrow"))
        imageView.contentMode = .center
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(titleLabel)
        contentView.addSubview(line0)
        contentView.addSubview(arrowIcon)
        contentView.addSubview(icon)
        
        icon.snp.makeConstraints { (maker) in
            maker.left.equalTo(14.5)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(icon.snp.right).offset(14.5)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        arrowIcon.snp.makeConstraints { (maker) in
            maker.right.equalTo(-15.4)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        line0.snp.makeConstraints { (maker) in
            maker.right.equalTo(0)
            maker.left.equalTo(0)
             maker.bottom.equalTo(0)
             maker.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
