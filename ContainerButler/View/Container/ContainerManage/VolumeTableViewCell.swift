//
//  VolumeTableViewCell.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/26.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class VolumeTableViewCell: UITableViewCell, ViewNameReusable {
    lazy var slider: UISlider = {
        let view = UISlider()
        view.setThumbImage(UIImage(named: "round"), for: .normal)
        view.setThumbImage(UIImage(named: "round"), for: .highlighted)
        view.minimumTrackTintColor = UIColor(hex: 0x30C7AC)
        view.maximumTrackTintColor = UIColor(hex: 0xcccccc)
        view.minimumValue = 0
        view.maximumValue = 100
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let smallImage = UIImageView(image: UIImage(named: "volume_small"))
        let rightImage = UIImageView(image: UIImage(named: "volume_big"))
        contentView.addSubview(smallImage)
        contentView.addSubview(rightImage)
        contentView.addSubview(slider)
        smallImage.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        
        rightImage.snp.makeConstraints { (maker) in
            maker.right.equalTo(-15)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        
        slider.snp.makeConstraints { (maker) in
            maker.left.equalTo(smallImage.snp.right).offset(15)
            maker.centerY.equalTo(contentView.snp.centerY)
            maker.right.equalTo(rightImage.snp.left).offset(-15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
