//
//  NotReplenishView.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NotReplenishView: UIView {
    var replenishAction: ((Int) -> Void)?
    
    fileprivate  var items = Variable([WaitSupplySence]())
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    fileprivate lazy var pageControl: UIPageControl = {
        let view = UIPageControl()
        view.currentPageIndicatorTintColor =  UIColor(hex: 0x989898)
        view.pageIndicatorTintColor = UIColor(hex: CustomKey.Color.mainOrangeColor)
        view.numberOfPages = 1
        return view
    }()
    fileprivate lazy var collectionView: UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = UIColor.white
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AddressCollectionCell.self, forCellWithReuseIdentifier: "AddressCollectionCell")
        return collectionView
        }()
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
        descLabel.text = "实际取货数："
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
        descLabel.text = "商品条码:1234567899999"
        return descLabel
    }()
    
    fileprivate lazy   var  realDeliveryGoodsInputTF: UITextField = {
        let pwdTF = UITextField()
        pwdTF.placeholder = "00"
        pwdTF.textColor = UIColor(hex: 0x30C7AC)
        pwdTF.font = UIFont.sizeToFit(with: 14)
        pwdTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .done
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func config(_ detail: GoodsDetail) {
        items.value = detail.sceneCountList ?? [WaitSupplySence]()
        nameLabel.text = detail.goodsName
        numberLabel.text = "商品条码: " + (detail.goodsSn ?? "000")
        realDeliveryGoodsInputTF.text = "\(detail.sumCount)"
        totalNotReplenishLabel.text = "总待补数: " + "\(detail.sumCount)"
        if items.value.count % 4 == 0 {
            pageControl.numberOfPages = items.value.count / 4
        } else {
            pageControl.numberOfPages = items.value.count / 4 + 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotReplenishView {
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
        contanierView.addSubview(collectionView)
        contanierView.addSubview(totalNotReplenishLabel)
        contanierView.addSubview(realDeliveryGoodsLabel)
        contanierView.addSubview(realDeliveryGoodsInputTF)
        contanierView.addSubview(line0)
        contanierView.addSubview(bgView)
        addSubview(replenishBtn)
        addSubview(contanierView)
        addSubview(pageControl)
        contanierView.snp.makeConstraints { (maker) in
            maker.left.equalTo(40.0.fitWidth)
            maker.right.equalTo(-40.0.fitWidth)
            maker.top.equalTo(80.0.fitHeight)
            maker.bottom.equalTo(-136.0.fitHeight)
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
            maker.left.equalTo(goodsIcon.snp.left).offset(25)
            maker.top.equalTo(goodsIcon.snp.bottom).offset(12)
        }
        numberLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameLabel.snp.left)
            maker.top.equalTo(nameLabel.snp.bottom).offset(7)
            maker.right.equalTo(-40)
        }
        collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(numberLabel.snp.bottom)
            maker.left.equalTo(numberLabel.snp.left)
            maker.right.equalTo(goodsIcon.snp.right).offset(-25)
            maker.height.equalTo(70)
        }
        pageControl.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(collectionView.snp.centerX)
            maker.bottom.equalTo(collectionView.snp.bottom)
        }
        totalNotReplenishLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(contanierView.snp.centerX).offset(-4)
            maker.top.equalTo(collectionView.snp.bottom).offset(0)
        }
        realDeliveryGoodsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(contanierView.snp.centerX).offset(4)
            maker.centerY.equalTo(totalNotReplenishLabel.snp.centerY)
        }
        realDeliveryGoodsInputTF.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(realDeliveryGoodsLabel.snp.centerY)
            maker.left.equalTo(realDeliveryGoodsLabel.snp.right).offset(2)
            maker.size.equalTo(CGSize(width: 40, height: 30))
        }
        line0.snp.makeConstraints { (maker) in
            maker.left.equalTo(realDeliveryGoodsInputTF.snp.left).offset(-5)
            maker.width.equalTo(30)
            maker.height.equalTo(2)
            maker.top.equalTo(realDeliveryGoodsInputTF.snp.bottom)
        }
        replenishBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(contanierView.snp.bottom).offset(30)
            maker.centerX.equalTo(contanierView.snp.centerX)
            maker.height.equalTo(40)
            maker.width.equalTo(200.0.fitWidth)
        }
        
        items.asObservable()
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell: AddressCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                  cell.config((element.sceneName ?? "") + ": " + "\((element.waitSupplyCount))" + "个")
               return cell
            }
            .disposed(by: disposeBag)
        
        replenishBtn.rx.tap.subscribe({[weak self] (_) in
            self?.dismiss()
            self?.replenishAction?(Int(self?.realDeliveryGoodsInputTF.text ?? "0") ?? 0)
        }).disposed(by: disposeBag)
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let minimumInteritemSpacing: CGFloat = 12
        let minimumLineSpacing: CGFloat = 12
        let leftInset: CGFloat = 0
        let rightInset: CGFloat = 0
        let topInset: CGFloat = 12.0
        let bottomInset: CGFloat = 24
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = minimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: topInset,
                                           left: leftInset,
                                           bottom: bottomInset,
                                           right: rightInset)
        layout.itemSize = CGSize(width: 100, height: (70 - topInset - minimumLineSpacing - bottomInset) / 2)
        collectionView.collectionViewLayout = layout
    }
}

extension NotReplenishView: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        let contentOffsetX = offSetX + self.collectionView.bounds.width * 0.5
        let currentPage = Int(contentOffsetX / self.collectionView.bounds.width)
        pageControl.currentPage = Int(currentPage)
    }
}

class AddressCollectionCell: UICollectionViewCell, ViewNameReusable {
    
    fileprivate lazy  var nameLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.backgroundColor = UIColor(hex: 0xcccccc)
        descLabel.font = UIFont.systemFont(ofSize: 11)
        descLabel.textColor =  UIColor(hex: 0x1a1a1a)
        descLabel.numberOfLines = 1
        descLabel.text = "香年广场T1: 10个"
        return descLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
            maker.top.equalTo(0)
        }
    }
    
    func config(_ text: String) {
        nameLabel.text = text
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
