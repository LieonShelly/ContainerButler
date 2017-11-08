//
//  ReplenishHistoryDetailCell.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MGSwipeTableCell

class ReplenishHistoryDetailCell: MGSwipeTableCell, ViewNameReusable {
    let disposeBag: DisposeBag = DisposeBag()
    var rightPanAction: (() -> Void)?
    var itemdidSelected: PublishSubject<String> = PublishSubject<String> ()
    fileprivate lazy  var notReplenishLabel: YYLabel = {
        let descLabel = YYLabel()
        var text = NSMutableAttributedString()
        let text0 = NSMutableAttributedString(string: "补货数量: ")
        text0.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text0.yy_color = UIColor(hex: 0x666666)
        let text1 = NSMutableAttributedString(string: "22")
        text1.yy_font = UIFont.boldSystemFont(ofSize: 16)
        text1.yy_color = UIColor(hex: CustomKey.Color.mainOrangeColor)
        text.append(text0)
        text.append(text1)
        descLabel.attributedText = text
        return descLabel
    }()
    fileprivate lazy  var remainReplenishLabel: YYLabel = {
        let descLabel = YYLabel()
        var text = NSMutableAttributedString()
        let text0 = NSMutableAttributedString(string: "应补数量: ")
        text0.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text0.yy_color = UIColor(hex: 0x666666)
        let text1 = NSMutableAttributedString(string: "22")
        text1.yy_font = UIFont.boldSystemFont(ofSize: 16)
        text1.yy_color = UIColor(hex: 0x30C7AC)
        text.append(text0)
        text.append(text1)
        descLabel.attributedText = text
        return descLabel
    }()
    fileprivate lazy  var nameLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.black
        descLabel.numberOfLines = 1
        descLabel.text = "统一康师傅冰红绿茶统一康师傅冰红绿... "
        return descLabel
    }()
    fileprivate lazy  var numberLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.black
        descLabel.numberOfLines = 1
        descLabel.text = "A01"
        return descLabel
    }()
    
    fileprivate lazy  var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    fileprivate lazy  var icon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "user_center_paizza@3x"))
        imageView.contentMode = .center
        return imageView
    }()
    
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xcccccc)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        contentView.addSubview(bgView)
        bgView.addSubview(notReplenishLabel)
        bgView.addSubview(remainReplenishLabel)
        bgView.addSubview(nameLabel)
        bgView.addSubview(icon)
        bgView.addSubview(numberLabel)
        bgView.addSubview(line0)

        bgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        icon.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView.snp.centerY)
            maker.left.equalTo(bgView.snp.left).offset(12)
            maker.size.equalTo(CGSize(width: 40, height: 60))
        }
        
        nameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(bgView.snp.top).offset(15)
            maker.right.equalTo(bgView.snp.right).offset(-12)
            maker.left.equalTo(icon.snp.right).offset(20)
        }
        numberLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(nameLabel.snp.bottom).offset(10)
            maker.left.equalTo(nameLabel.snp.left)
        }
        
        remainReplenishLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(numberLabel.snp.bottom).offset(12)
            maker.left.equalTo(nameLabel.snp.left)
            maker.bottom.equalTo(bgView.snp.bottom).offset(-10)
        }
        
        notReplenishLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(remainReplenishLabel.snp.centerY)
            maker.right.equalTo(-12)
            
        }
        
        line0.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
            maker.height.equalTo(0.5)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(_ model: SuplementRecordDetail) {
        nameLabel.text = model.goodsName
        numberLabel.text = model.channelSn
        icon.kf.setImage(with: URL(string: CustomKey.URLKey.baseImageUrl + (model.goodsPic ?? "")), placeholder: UIImage(named: "drink"))
        let text2 = NSMutableAttributedString()
        let text3 = NSMutableAttributedString(string: "应补数量:  ")
        text3.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text3.yy_color = UIColor(hex: 0x666666)
        let text4 = NSMutableAttributedString(string: "\(model.waitSupplyCount)")
        text4.yy_font = UIFont.boldSystemFont(ofSize: 16)
        text4.yy_color = UIColor(hex: 0x30C7AC)
        text2.append(text3)
        text2.append(text4)
        remainReplenishLabel.attributedText = text2
        
        let text = NSMutableAttributedString()
        let text0 = NSMutableAttributedString(string: "补货数量:  ")
        text0.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text0.yy_color = UIColor(hex: 0x666666)
        let text1 = NSMutableAttributedString(string: "\(model.supplyCount)")
        text1.yy_font = UIFont.boldSystemFont(ofSize: 16)
        text1.yy_color = UIColor(hex: CustomKey.Color.mainOrangeColor)
        text.append(text0)
        text.append(text1)
        notReplenishLabel.attributedText = text
    }
}
