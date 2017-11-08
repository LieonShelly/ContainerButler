//
//  GoodListCell.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
// swiftlint:disable empty_count

import UIKit
import RxCocoa
import RxSwift
import MGSwipeTableCell
import Kingfisher

class GoodListCell: MGSwipeTableCell, ViewNameReusable {
    let disposeBag: DisposeBag = DisposeBag()
    var rightPanAction: (() -> Void)?
    var itemdidSelected: PublishSubject<String> = PublishSubject<String> ()
   lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.isHidden = true
        return view
    }()
    fileprivate lazy  var notReplenishLabel: YYLabel = {
        let descLabel = YYLabel()
        var text = NSMutableAttributedString()
        let text0 = NSMutableAttributedString(string: "待补货数:")
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
    fileprivate lazy  var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0x30c7ac, alpha: 0.1)
        return view
    }()
    
    fileprivate lazy  var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 11)
        descLabel.backgroundColor = UIColor(hex: 0x30c7ac, alpha: 1)
        descLabel.textColor = .white
        descLabel.numberOfLines = 1
        descLabel.text = "已补货  "
        descLabel.textAlignment = .center
        descLabel.layer.cornerRadius = 14
        descLabel.layer.masksToBounds = true
        return descLabel
    }()
    
    fileprivate lazy  var icon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "user_center_paizza"))
        imageView.contentMode = .center
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        let selectedView = UIView()
        selectedBackgroundView = selectedView
        contentView.addSubview(bgView)
        bgView.addSubview(notReplenishLabel)
        bgView.addSubview(remainReplenishLabel)
        bgView.addSubview(nameLabel)
        bgView.addSubview(icon)
        bgView.addSubview(numberLabel)
        bgView.addSubview(coverView)
        coverView.addSubview(descLabel)
        bgView.addSubview(loadingView)
      
        loadingView.snp.makeConstraints { (maker) in
            maker.left.equalTo(bgView.snp.left)
            maker.top.equalTo(bgView.snp.top)
            maker.right.equalTo(bgView.snp.right)
            maker.bottom.equalTo(bgView.snp.bottom)
        }
        
        bgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(5)
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
        
        notReplenishLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(numberLabel.snp.bottom).offset(10)
            maker.right.equalTo(-12)
            
        }
        
        remainReplenishLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(notReplenishLabel.snp.centerY)
            maker.left.equalTo(nameLabel.snp.left)
        }
        
        coverView.snp.makeConstraints {
            $0.left.equalTo(bgView.snp.left)
            $0.right.equalTo(bgView.snp.right)
            $0.top.equalTo(bgView.snp.top)
            $0.bottom.equalTo(bgView.snp.bottom)
        }
        descLabel.snp.makeConstraints {
            $0.right.equalTo(10)
            $0.centerY.equalTo(bgView.snp.centerY)
            $0.height.equalTo(28)
            $0.width.equalTo(64)
        }
         descLabel.sizeToFit()
         coverView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
            bgView.backgroundColor = UIColor.white
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
         contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
            bgView.backgroundColor = UIColor.white
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GoodListCell {
    func configWaitSupplyGoods(_ goods: Goods) {
        icon.kf.setImage(with: URL(string: CustomKey.URLKey.baseImageUrl + ( goods.goodsPic ?? "")), placeholder: UIImage(named: "drink"), options: nil, progressBlock: nil, completionHandler: nil)
        nameLabel.text = goods.goodsName
        numberLabel.textColor = UIColor(hex: 0x999999)
        numberLabel.font = UIFont.systemFont(ofSize: 12)
        numberLabel.text = "商品条码：" + (goods.goodsSn ?? "")
        let text2 = NSMutableAttributedString()
        let text3 = NSMutableAttributedString(string: "待补货数:  ")
        text3.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text3.yy_color = UIColor(hex: 0x666666)
        let text4 = NSMutableAttributedString(string: "\(goods.waitSupplyCount)")
        text4.yy_font = UIFont.boldSystemFont(ofSize: 16)
        text4.yy_color = UIColor(hex: CustomKey.Color.mainOrangeColor)
        text2.append(text3)
        text2.append(text4)
        remainReplenishLabel.attributedText = text2
        notReplenishLabel.isHidden = true
    }
    
    func configContainerWaitSupplyGoods(_ goods: Goods) {
        icon.kf.setImage(with: URL(string: CustomKey.URLKey.baseImageUrl + (goods.goodsPic ?? "")), placeholder: UIImage(named: "drink"), options: nil, progressBlock: nil, completionHandler: nil)
        nameLabel.text = goods.goodsName
        numberLabel.textColor = UIColor(hex: 0x000000)
        numberLabel.font = UIFont.systemFont(ofSize: 14)
        numberLabel.text = (goods.goodsSn ?? "")
        let text2 = NSMutableAttributedString()
        let text3 = NSMutableAttributedString(string: "剩余数量:  ")
        text3.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text3.yy_color = UIColor(hex: 0x666666)
        let text4 = NSMutableAttributedString(string: "\(goods.remainCount)")
        text4.yy_font = UIFont.boldSystemFont(ofSize: 16)
        text4.yy_color = UIColor(hex: 0x30C7AC)
        text2.append(text3)
        text2.append(text4)
        notReplenishLabel.attributedText = text2
        
        let text = NSMutableAttributedString()
        let text0 = NSMutableAttributedString(string: "待补货数:  ")
        text0.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text0.yy_color = UIColor(hex: 0x666666)
        let text1 = NSMutableAttributedString(string: "\(goods.waitSupplyCount)")
        text1.yy_font = UIFont.boldSystemFont(ofSize: 16)
        text1.yy_color = UIColor(hex: CustomKey.Color.mainOrangeColor)
        text.append(text0)
        text.append(text1)
        remainReplenishLabel.attributedText = text
    }
    
    func configContainerWholeGoods(_ goods: Goods) {
        icon.kf.setImage(with: URL(string:  CustomKey.URLKey.baseImageUrl + (goods.goodsPic ?? "")), placeholder: UIImage(named: "drink"), options: nil, progressBlock: nil, completionHandler: nil)
        nameLabel.text = goods.goodsName
        numberLabel.textColor = UIColor(hex: 0x000000)
        numberLabel.font = UIFont.systemFont(ofSize: 14)
        numberLabel.text = (goods.channelSn ?? "")
        let text2 = NSMutableAttributedString()
        let text3 = NSMutableAttributedString(string: "剩余数量:  ")
        text3.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text3.yy_color = UIColor(hex: 0x666666)
        let text4 = NSMutableAttributedString(string: "\(goods.remainCount)")
        text4.yy_font = UIFont.boldSystemFont(ofSize: 16)
        text4.yy_color = UIColor(hex: 0x30C7AC)
        text2.append(text3)
        text2.append(text4)
        notReplenishLabel.attributedText = text2
        
        let text = NSMutableAttributedString()
        let text0 = NSMutableAttributedString(string: "待补货数:  ")
        text0.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text0.yy_color = UIColor(hex: 0x666666)
        let text1 = NSMutableAttributedString(string: "\(goods.waitSupplyCount)")
        text1.yy_font = UIFont.boldSystemFont(ofSize: 16)
        text1.yy_color = UIColor(hex: CustomKey.Color.mainOrangeColor)
        text.append(text0)
        text.append(text1)
        remainReplenishLabel.attributedText = text
    }
    
    func showCover(_ count: Int, text: String? = "已补货") {
        descLabel.text = text
        coverView.isHidden = false
    }
    
    func hiddenCover() {
        coverView.isHidden = true
    }
}

class LoadingView: UIView {
    fileprivate lazy var progressViewHorizontal: M13ProgressViewSegmentedBar = {
        let view = M13ProgressViewSegmentedBar()
        view.primaryColor = UIColor.white
        view.secondaryColor = .clear
        view.segmentSeparation = 7
        view.indeterminate = true
        return view
    }()
    fileprivate lazy  var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.boldSystemFont(ofSize: 14)
        descLabel.textColor = UIColor.white
        descLabel.numberOfLines = 1
        descLabel.text = "正在出货"
        return descLabel
    }()
    
    fileprivate lazy  var coverView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "gradation"))
        imageView.contentMode = .center
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverView)
        addSubview(progressViewHorizontal)
        addSubview(descLabel)
        
        coverView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
        
        descLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.snp.centerY)
            maker.left.equalTo(30)
        }
        progressViewHorizontal.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(descLabel.snp.centerY)
            maker.left.equalTo(descLabel.snp.right).offset(8)
            maker.width.equalTo(50)
            maker.height.equalTo(2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
