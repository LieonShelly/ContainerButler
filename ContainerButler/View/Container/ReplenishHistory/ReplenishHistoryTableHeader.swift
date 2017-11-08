//
//  ReplenishHistoryTableHeader.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class ReplenishHistoryTableHeader: UITableViewHeaderFooterView, ViewNameReusable {
    fileprivate lazy  var dateLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.boldSystemFont(ofSize: 17)
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        descLabel.text = "10.11"
        return descLabel
    }()
    
    fileprivate lazy  var goodsCountLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        descLabel.text = "总待补数：50  总补货数：4"
        return descLabel
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        contentView.addSubview(dateLabel)
        contentView.addSubview(goodsCountLabel)
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15.5)
            maker.centerY.equalTo(contentView.snp.centerY).offset(8)
        }
        goodsCountLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(dateLabel.snp.right).offset(18)
            maker.centerY.equalTo(contentView.snp.centerY).offset(8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(_ model: SuplementRecordGroup) {
        if let date = model.date, date.count >= 5 {
            let text = NSMutableAttributedString()
            let index = date.index(of: ".") ?? date.endIndex
            let beginning = date[..<index]
            let monthText = NSMutableAttributedString(string:  String(beginning) + ".")
            monthText.yy_font = UIFont.boldSystemFont(ofSize: 10)
            monthText.yy_color = UIColor(hex: 0x333333)
            let dayText = NSMutableAttributedString(string:  String(date[index..<date.endIndex]) + " ")
            dayText.yy_font = UIFont.boldSystemFont(ofSize: 18)
            dayText.yy_color = UIColor(hex: 0x333333)
            text.append(monthText)
            text.append(dayText)
            dateLabel.attributedText = text
        }
      
        let text2 = NSMutableAttributedString()
        let text3 = NSMutableAttributedString(string: "总待补数: ")
        text3.yy_font = UIFont.systemFont(ofSize: 14)
        text3.yy_color = UIColor(hex: 0x333333)
        let text4 = NSMutableAttributedString(string: "\(model.sumWaitSupplyCount)")
        text4.yy_font = UIFont.boldSystemFont(ofSize: 14)
        text4.yy_color = UIColor(hex: 0x333333)
        text2.append(text3)
        text2.append(text4)
        goodsCountLabel.attributedText = text2
        
        let text5 = NSMutableAttributedString(string: "      ")
        let text6 = NSMutableAttributedString(string: "总补货数: ")
        text6.yy_font = UIFont.systemFont(ofSize: 14)
        text6.yy_color = UIColor(hex: 0x333333)
        let text7 = NSMutableAttributedString(string: "\(model.sumSupplyCount)")
        text7.yy_font = UIFont.boldSystemFont(ofSize: 14)
        text7.yy_color = UIColor(hex: 0x333333)
        text2.append(text5)
        text2.append(text6)
        text2.append(text7)
        goodsCountLabel.attributedText = text2
        
    }
}
