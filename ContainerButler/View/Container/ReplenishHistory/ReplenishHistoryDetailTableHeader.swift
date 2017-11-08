//
//  ReplenishHistoryDetailTableHeader.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class ReplenishHistoryDetailTableHeader: UITableViewHeaderFooterView, ViewNameReusable {

    fileprivate lazy  var dateLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.sizeToFit(with: 13)
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        descLabel.text = "A货柜"
        return descLabel
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15.5)
            maker.centerY.equalTo(contentView.snp.centerY).offset(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(_ model: ContainerSupplyRecord) {
        dateLabel.text = (model.cntrSn ?? "") + "货柜"
    }
}
