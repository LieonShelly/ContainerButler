//
// ContainerSectionHeaderView
//  ContainerButler
//
//  Created by lieon on 2017/9/20.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ContainerSectionHeaderView: UITableViewHeaderFooterView, ViewNameReusable {
    var listTapAction: ((Scence) -> Void)?
    let disposeBag: DisposeBag = DisposeBag()
    fileprivate var model: Scence?
    fileprivate lazy  var numberLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 11)
        descLabel.textColor = UIColor(hex: 0x666666)
        descLabel.numberOfLines = 0
        descLabel.text = "编号1000000001"
        return descLabel
    }()
    
    fileprivate lazy  var nameLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 14.5)
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        descLabel.text = "花样年华T3优享空间"
        return descLabel
    }()
    
    fileprivate lazy  var listLabel: UILabel = {[weak self] in
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor(hex: 0x30C7AC)
        descLabel.numberOfLines = 0
        descLabel.text = "完成补货"
        descLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        descLabel.addGestureRecognizer(tap)
        tap.rx.event
            .subscribe(onNext: { [weak self](_) in
                if let model = self?.model {
                    self?.listTapAction?(model)
                }
            }).disposed(by: disposeBag)
        return descLabel
    }()
    
    fileprivate lazy  var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
         contentView.addSubview(bgView)
        bgView.addSubview(numberLabel)
        bgView.addSubview(nameLabel)
        bgView.addSubview(listLabel)
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(12)
            maker.right.equalTo(-12)
            maker.bottom.equalTo(-12)
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(12)
        }
       numberLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(nameLabel.snp.bottom).offset(6)
        }
        listLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(-12)
            maker.centerY.equalTo(bgView.snp.centerY)
        }
        
    }
    
    func config(_ model: Scence) {
        numberLabel.text = "编号" + (model.number ?? "")
        nameLabel.text = model.name ?? ""
        self.model = model
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
