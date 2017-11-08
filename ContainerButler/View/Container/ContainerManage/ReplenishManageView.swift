//
//  ReplenishManageView.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/22.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher
import Closures

class ReplenishManageView: UIView {
    var replenishAction: ((Int) -> Void)?
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    fileprivate lazy  var goodsIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "juic.jpg"))
        imageView.contentMode = .center
        return imageView
    }()
    
    fileprivate lazy  var totalNotReplenishLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.boldSystemFont(ofSize: 13)
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        descLabel.text = "总待补数：2"
        return descLabel
    }()
    
    fileprivate lazy  var realDeliveryGoodsLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.boldSystemFont(ofSize: 13)
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        descLabel.text = "实际补货数:"
        return descLabel
    }()
    
    fileprivate lazy  var nameLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.boldSystemFont(ofSize: 13)
        descLabel.textColor =  UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        descLabel.text = "统一冰红茶"
        return descLabel
    }()
    
    fileprivate lazy  var numberLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor(hex: 0x999999)
        descLabel.numberOfLines = 0
        descLabel.text = "商品编号：23231231"
        return descLabel
    }()
    
    lazy   var  realDeliveryGoodsInputTF: UITextField = {
        let pwdTF = UITextField()
        pwdTF.placeholder = "00"
        pwdTF.textColor = UIColor(hex: 0x30C7AC)
        pwdTF.font = UIFont.sizeToFit(with: 14)
        pwdTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .done
        pwdTF.textAlignment = .center
        return pwdTF
    }()
    
    fileprivate lazy  var replenishBtn: UIButton = {[weak self] in
        let loginBtn = UIButton()
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 15)
        loginBtn.setTitle("确定", for: .normal)
         loginBtn.backgroundColor = UIColor(hex: 0x30c7ac)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.setTitleColor(UIColor.gray, for: .highlighted)
        loginBtn.layer.cornerRadius = 20
        
        loginBtn.layer.masksToBounds = true
        if let disposeBag = self?.disposeBag {
            loginBtn.rx.tap.subscribe({ (_) in
                self?.dismiss()
                self?.replenishAction?(Int(self?.realDeliveryGoodsInputTF.text ?? "0") ?? 0)
            }).disposed(by: disposeBag)
        }
        return loginBtn
        }()
    
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0x30C7AC)
        return view
    }()
    
    fileprivate  lazy  var bgView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "dashed"))
        return imageView
    }()
    
    fileprivate lazy  var closeBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "delete"), for: .normal)
        return loginBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReplenishManageView {
    fileprivate func setupUI() {
        let contanierView = UIView()
        contanierView.layer.cornerRadius = 12.5
        contanierView.layer.masksToBounds = true
        contanierView.layer.borderWidth = 2
        contanierView.layer.borderColor = UIColor.gray.cgColor
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        contanierView.backgroundColor = .white
        contanierView.addSubview(goodsIcon)
        contanierView.addSubview(nameLabel)
        contanierView.addSubview(numberLabel)
        contanierView.addSubview(totalNotReplenishLabel)
        contanierView.addSubview(realDeliveryGoodsLabel)
        contanierView.addSubview(realDeliveryGoodsInputTF)
        contanierView.addSubview(line0)
        contanierView.addSubview(bgView)
        addSubview(replenishBtn)
        addSubview(contanierView)
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(contanierView.snp.right)
            maker.bottom.equalTo(contanierView.snp.top).offset(-5)
        }
        contanierView.snp.makeConstraints { (maker) in
            maker.left.equalTo(40.0.fitWidth)
            maker.right.equalTo(-40.0.fitWidth)
            maker.top.equalTo(109.0.fitHeight)
            maker.bottom.equalTo(-172.0.fitHeight)
        }
        
        goodsIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(25)
            maker.left.equalTo(25)
            maker.right.equalTo(-25)
            maker.height.equalTo(243.0.fitHeight)
        }
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(goodsIcon.snp.top)
            maker.left.equalTo(goodsIcon.snp.left)
            maker.right.equalTo(goodsIcon.snp.right)
            maker.height.equalTo(goodsIcon.snp.height)
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(goodsIcon.snp.left).offset(25.0.fitWidth)
            maker.top.equalTo(goodsIcon.snp.bottom).offset(12)
        }
        numberLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameLabel.snp.left)
            maker.top.equalTo(nameLabel.snp.bottom).offset(7)
        }
        totalNotReplenishLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameLabel.snp.left)
            maker.top.equalTo(numberLabel.snp.bottom).offset(7)
        }
        realDeliveryGoodsLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(totalNotReplenishLabel.snp.centerY)
            maker.left.equalTo(totalNotReplenishLabel.snp.right).offset(15.0.fitWidth)
        }
        realDeliveryGoodsInputTF.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(realDeliveryGoodsLabel.snp.centerY)
            maker.left.equalTo(realDeliveryGoodsLabel.snp.right)
            maker.size.equalTo(CGSize(width: 30, height: 30))
        }
        line0.snp.makeConstraints { (maker) in
            maker.left.equalTo(realDeliveryGoodsInputTF.snp.left).offset(-5)
            maker.width.equalTo(40)
            maker.height.equalTo(2)
            maker.top.equalTo(realDeliveryGoodsInputTF.snp.bottom)
        }
        replenishBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(contanierView.snp.bottom).offset(30.0.fitHeight)
            maker.centerX.equalTo(contanierView.snp.centerX)
            maker.height.equalTo(40)
            maker.width.equalTo(200.0.fitWidth)
        }
        closeBtn.onTap {[unowned self] in
            self.dismiss()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     
    }
}

extension ReplenishManageView {
    func config(_ goods: Goods) {
        nameLabel.text = goods.goodsName
        numberLabel.text = "商品条码: " + (goods.goodsSn ?? "000")
        realDeliveryGoodsInputTF.text = "\(goods.waitSupplyCount)"
        totalNotReplenishLabel.text = "总待补数: " + "\(goods.waitSupplyCount)"
        goodsIcon.kf.setImage(with: URL(string: CustomKey.URLKey.baseImageUrl + (goods.goodsPic ?? "")), placeholder: UIImage(named: "juic.jpg"))
    }
}
