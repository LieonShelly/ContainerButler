//
//  CenterLabelTableViewCell.swift
//  ContainerButler
//
//  Created by lieon on 2017/11/2.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class CenterLabelTableViewCell: UITableViewCell, ViewNameReusable {

    var centerLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = .red
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        descLabel.backgroundColor = UIColor.white
        return descLabel
    }()
    
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xcccccc)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        contentView.addSubview(centerLabel)
        contentView.addSubview(line0)
        
        line0.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.height.equalTo(0.5)
            maker.bottom.equalTo(centerLabel.snp.top)
        }
        
        centerLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
            maker.top.equalTo(8)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = centerLabel.backgroundColor
        let textColor = centerLabel.textColor
        
        super.setSelected(selected, animated: animated)
        if selected {
            centerLabel.textColor = textColor
            centerLabel.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = centerLabel.backgroundColor
        let textColor = centerLabel.textColor
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            centerLabel.textColor = textColor
            centerLabel.backgroundColor = color
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
