//
//  ContainerTableViewCell.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ContainerTableViewCell: UITableViewCell, ViewNameReusable {
    let disposeBag: DisposeBag = DisposeBag()
    var itemdidSelected: ((Container) -> Void)?
    fileprivate  var items = Variable([Container]())
    fileprivate lazy  var numberLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        descLabel.text = "一组"
        return descLabel
    }()
    
    fileprivate lazy var collectionView: UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ContainerCollectionCell.self, forCellWithReuseIdentifier: "ContainerCollectionCell")
        return collectionView
        }()
    
    fileprivate lazy  var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
         contentView.addSubview(bgView)
         bgView.addSubview(numberLabel)
         bgView.addSubview(collectionView)
        
        bgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(0)
            maker.right.equalTo(-12)
            maker.bottom.equalTo(-12)
        }
        
        numberLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(bgView.snp.left).offset(12)
            maker.top.equalTo(bgView.snp.top).offset(12)
        }
        collectionView.snp.makeConstraints { (maker) in
            maker.left.equalTo(bgView.snp.left).offset(0)
            maker.top.equalTo(numberLabel.snp.bottom).offset(20)
            maker.right.equalTo(bgView.snp.right)
            maker.bottom.equalTo(bgView.snp.bottom)
        }

        items.asObservable()
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell: ContainerCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                cell.config( (element.number ?? "0") + "货柜")
                cell.badgeView.badgeValue = element.waitSupplyCount
                if element.isCentralContainer {
                     cell.config("中控货", backgroundColor: UIColor(hex: 0xfbc205))
                }
                return cell
            }
            .disposed(by: disposeBag)
        
           collectionView.rx.modelSelected(Container.self)
            .subscribe(onNext: { [weak self] (model) in
                self?.itemdidSelected?(model)
            })
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bgViewInset: CGFloat = 12
        let minimumInteritemSpacing: CGFloat = 30.0.fitWidth
        let minimumLineSpacing: CGFloat = 12.0.fitHeight
        let leftInset: CGFloat = 12.0.fitWidth
        let rightInset: CGFloat = 12.0.fitWidth
        let topInset: CGFloat = 12.0.fitHeight
        let bottomInset: CGFloat = 22.0.fitHeight
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = minimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: topInset,
                                                          left: leftInset,
                                                          bottom: bottomInset,
                                                          right: rightInset)
        layout.itemSize = CGSize(
            width: (bounds.width - bgViewInset * 2 - minimumInteritemSpacing * 2 - leftInset * 2) / 3,
            height: 45.0.fitHeight
        )
        collectionView.collectionViewLayout = layout
    }
    
    func config(_ containers: [Container], index: Int) {
        items.value = containers
        numberLabel.text = "\(index)" + "组"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ContainerCollectionCell: UICollectionViewCell, ViewNameReusable {
    
    fileprivate lazy  var numberLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.white
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        descLabel.backgroundColor = UIColor(hex: 0x30c7ac)
        descLabel.layer.cornerRadius = 5
        descLabel.layer.masksToBounds = true
        return descLabel
    }()
    fileprivate lazy var badgeView: GIBadgeView = {
        let badgeView = GIBadgeView()
        badgeView.badgeValue = 50
        badgeView.rightOffset = 10
        return badgeView
    }()
    fileprivate lazy  var coverLabel: UILabel = {
        let descLabel = UILabel()
        return descLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(numberLabel)
        contentView.addSubview(coverLabel)
        coverLabel.addSubview(badgeView)
        numberLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
            maker.top.equalTo(0)
        }
        coverLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
            maker.top.equalTo(0)
        }
    }
    
    func config(_ text: String, backgroundColor: UIColor? = UIColor(hex: 0x30c7ac)) {
        numberLabel.text = text
        numberLabel.backgroundColor = backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
