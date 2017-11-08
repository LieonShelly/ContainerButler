//
//  MessageCell.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/22.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, ViewNameReusable {
    fileprivate lazy  var messageIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "inform"))
        imageView.contentMode = .center
        return imageView
    }()
    fileprivate lazy  var arrowIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "arrow"))
        imageView.contentMode = .center
        return imageView
    }()
    fileprivate lazy  var messageTitleLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        descLabel.text = ""
        return descLabel
    }()
    
    fileprivate lazy  var timeLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.font = UIFont.systemFont(ofSize: 12)
        descLabel.textColor = UIColor(hex: 0x999999)
        descLabel.numberOfLines = 0
        descLabel.text = "2017-9-2 . 17:15"
        return descLabel
    }()
    
    fileprivate lazy  var messageBodyLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor(hex: 0x666666)
        descLabel.numberOfLines = 0
        descLabel.text = "花样年T3优享空间急需补货15件"
        return descLabel
    }()
    
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(messageIcon)
        contentView.addSubview(messageTitleLabel)
        contentView.addSubview(messageBodyLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(arrowIcon)
        contentView.addSubview(line0)
        
        messageIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.centerY.equalTo(contentView.snp.centerY)
            maker.width.equalTo(40)
            maker.height.equalTo(55)
        }
        
        messageTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(messageIcon.snp.right).offset(12)
            maker.top.equalTo(messageIcon.snp.top).offset(-8)
            maker.right.equalTo(-12)
            maker.height.equalTo(20)
        }
        messageBodyLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(messageTitleLabel.snp.left)
            maker.top.equalTo(messageTitleLabel.snp.bottom).offset(22)
        }
        arrowIcon.snp.makeConstraints { (maker) in
            maker.right.equalTo(-15)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        timeLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(-15)
            maker.top.equalTo(8.5)
        }
        line0.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.height.equalTo(5)
            maker.bottom.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func config(_ model: Message) {
        messageTitleLabel.text = model.type.title
        messageBodyLabel.text = model.content ?? ""
        timeLabel.text = model.noticeTime ?? ""
    }
    
    func config(_ model: MessageDetail) {
        messageTitleLabel.text = model.title ?? ""
        messageBodyLabel.text = model.content ?? ""
        timeLabel.text = model.sendDate ?? ""
    }
}
