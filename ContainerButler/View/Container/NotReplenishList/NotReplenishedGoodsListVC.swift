//
//  NotReplenishedGoodsListVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//  待补清单

import UIKit
import RxCocoa
import RxSwift
import pop
import MJRefresh
import MGSwipeTableCell

class NotReplenishedGoodsListVC: BaseViewController {
    var supplyMessage: MessageDetail?
    fileprivate lazy  var optionChooseView = UIView()
    fileprivate lazy var listVM: ContainerManageViewModel = {
        let viewModel =  ContainerManageViewModel()
        viewModel.requestWaitSupplyGoodsCategoryList()
        viewModel.reuestWaitSuppltScencelist()
        viewModel.requestWaitSupplyGoodsList()
        return viewModel
    }()
    fileprivate lazy  var addressLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.sizeToFit(with: 14)
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        descLabel.text = "全部"
        return descLabel
    }()
    
    fileprivate lazy  var chooseBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 12)
        loginBtn.setTitle("选择优享空间", for: .normal)
        loginBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        loginBtn.setTitleColor(UIColor(hex: 0x666666), for: .normal)
        loginBtn.setTitleColor(UIColor(hex: CustomKey.Color.mainOrangeColor), for: .highlighted)
        return loginBtn
    }()
    
    fileprivate lazy   var triangleIcon: UIImageView = {
        let pwdLog = UIImageView(image: UIImage(named: "triangle"))
        pwdLog.contentMode = .center
        return pwdLog
    }()
    
    lazy var notreplenishmentView: NotReplenishView = {
        let animator = NotReplenishView()
        return animator
    }()
    
    fileprivate lazy var pageTitleView: PageTitleView = {
        let pvc = PageTitleView(frame: CGRect(x: 0, y: 45, width: UIScreen.main.bounds.width, height: 44), titles: nil)
        pvc.labelCountPerPage =  5
        return pvc
    }()
    
    fileprivate lazy var optiontableView: UITableView = {
        let taleView = UITableView()
        taleView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 65, right: 0)
        taleView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        taleView.separatorInset = UIEdgeInsets(top: 0, left: 1000000, bottom: 0, right: 0)
        taleView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return taleView
    }()
    fileprivate lazy  var doneBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.isHidden = true
        loginBtn.setImage(UIImage(named: "complete_goods"), for: .normal)
        return loginBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }
}

extension NotReplenishedGoodsListVC {
  
    fileprivate func setupUI() {
        title = "待补清单"
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        tableView.register(GoodListCell.self, forCellReuseIdentifier: "GoodListCell")
       
        optionChooseView.backgroundColor = .white
        optionChooseView.layer.borderWidth = 0.5
        optionChooseView.layer.borderColor = UIColor(hex: 0xcccccc).cgColor
        view.addSubview(optionChooseView)
        optionChooseView.addSubview(addressLabel)
        optionChooseView.addSubview(chooseBtn)
        optionChooseView.addSubview(triangleIcon)
        view.addSubview(pageTitleView)
        view.addSubview(tableView)
        view.addSubview(doneBtn)
    
         pageTitleView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        notreplenishmentView.frame = CGRect(x: 0, y: -UIScreen.height, width: UIScreen.width, height: UIScreen.height)
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(notreplenishmentView)
        optiontableView.frame = CGRect(x: 0, y: -(view.bounds.height - 45), width: UIScreen.width, height: view.bounds.height - 45)
        view.insertSubview(optiontableView, aboveSubview: doneBtn)
        
        optionChooseView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.top.equalTo(0)
            maker.height.equalTo(45)
        }
        addressLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(27)
            maker.centerY.equalTo(optionChooseView.snp.centerY)
        }
        triangleIcon.snp.makeConstraints { (maker) in
            maker.right.equalTo(chooseBtn.snp.right)
            maker.centerY.equalTo(optionChooseView.snp.centerY)
        }
        chooseBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-27)
            maker.centerY.equalTo(optionChooseView.snp.centerY)
            maker.height.equalTo(36)
            maker.width.equalTo(100)
        }
        doneBtn.snp.makeConstraints {
            $0.right.equalTo(-15)
            $0.width.equalTo(48)
            $0.height.equalTo(48)
            $0.bottom.equalTo(-15)
        }
        tableView.snp.makeConstraints { (maker) in
             maker.top.equalTo(pageTitleView.snp.bottom)
             maker.left.right.equalTo(0)
             maker.bottom.equalTo(0)
        }
    }
    
    fileprivate func setupRX() {

        chooseBtn.onTap { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.chooseBtn.isSelected = !weakSelf.chooseBtn.isSelected
            if weakSelf.chooseBtn.isSelected {
                weakSelf.showOptionChooseView()
            } else {
                weakSelf.hideOptionChooseView()
            }
        }
        let items =  listVM.scenceList.asObservable()
        items
            .bind(to: optiontableView.rx.items(cellIdentifier: "UITableViewCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.font = UIFont.sizeToFit(with: 13.5)
                cell.textLabel?.textColor = UIColor(hex: 0x333333)
                cell.textLabel?.text = element.name
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            .disposed(by: disposeBag)
        
        listVM
            .responseType
            .asObservable()
            .map {$0 == StatusType.networkUnavailable ? false: true}
            .bind(to: emptyContainerView.rx.isHidden)
            .disposed(by: disposeBag)
        
        listVM
            .responseType
            .asObservable()
            .map {$0 == StatusType.success ? false: true}
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        listVM
            .responseType
            .asObservable()
            .map {$0 == StatusType.success ? false: true}
            .bind(to: optionChooseView.rx.isHidden)
            .disposed(by: disposeBag)
        
        listVM
            .responseType
            .asObservable()
            .map {$0 == StatusType.success ? false: true}
            .bind(to: pageTitleView.rx.isHidden)
            .disposed(by: disposeBag)
        
        emptyContainerView.reloadBtn.onTap {[weak self] in
            HUD.showLoading()
            self?.listVM.requestWaitSupplyGoodsCategoryList()
            self?.listVM.reuestWaitSuppltScencelist()
            self?.listVM.requestCommand.onNext(true)
        }
        
        listVM
            .models
            .asObservable()
            .subscribe(onNext: { [weak self](_) in
                HUD.hideLoading()
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        optiontableView.rx
            .modelSelected(Scence.self)
            .subscribe(onNext: {[weak self] value in
                self?.addressLabel.text = value.name
                self?.hideOptionChooseView()
                guard let weakSelf = self else {
                    return
                }
                let selectedScence = value
                weakSelf.listVM.param.sceneSn = selectedScence.number
                weakSelf.listVM.requestCommand.onNext(true)
                weakSelf.listVM.refreshStatus.value = .endFooterRefresh
                weakSelf.chooseBtn.isSelected = false
            })
            .disposed(by: disposeBag)
        
        listVM.goodsCategory.asObservable()
            .subscribe(onNext: {[weak self] (list) in
                var titles = [String]()
                for cate in list {
                    if let title = cate.cateName {
                        titles.append(title)
                    }
                }
                self?.pageTitleView.setTitles(titles)
                let line0 = UIView()
                line0.backgroundColor = UIColor(hex: 0xcccccc)
                line0.frame = CGRect(x: 0, y: 44 - 0.5, width: UIScreen.main.bounds.width, height: 0.5)
                if let weakSelf = self {
                    weakSelf.pageTitleView.addSubview(line0)
                }
            }).disposed(by: disposeBag)

        listVM.refreshStatus.asObservable().subscribe(onNext: {[weak self] (status) in
            switch status {
            case .beingFooterRefresh:
                self?.tableView.mj_footer.beginRefreshing()
            case .endFooterRefresh:
                self?.tableView.mj_footer.endRefreshing()
            case .noMoreData:
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            default:
                break
            }
        }).disposed(by: disposeBag)

        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            if let weakSelf = self {
                weakSelf.listVM.requestCommand.onNext(false)
            }
        })
        pageTitleView.titleTapAction = {[weak self]index in
            guard let weakSelf = self else {
                return
            }
            let selectedCate = weakSelf.listVM.goodsCategory.value[index]
            weakSelf.listVM.param.cateId = selectedCate.cateId
            weakSelf.listVM.requestCommand.onNext(true)
             weakSelf.listVM.refreshStatus.value = .endFooterRefresh
        }
         HUD.showLoading()
        if let selectedMessage = supplyMessage {
            addressLabel.text = selectedMessage.title
            listVM.param.sceneSn = selectedMessage.sceneSn
        } else {
            listVM.param.sceneSn = ""
        }
         listVM.param.cateId = 0
        listVM.requestCommand.onNext(true)
    }
    
    private func showOptionChooseView() {
        UIView.animate(withDuration: 0.25, animations: {   [unowned self] in
            let transform = CATransform3DMakeRotation(CGFloat(CFloat.pi), 0, 0, 1)
            self.triangleIcon.layer.transform = transform
            self.optiontableView.transform = CGAffineTransform(translationX: 0, y: (self.view.bounds.height + 45 + 20))
        })
    }
    
    fileprivate func hideOptionChooseView() {
        UIView.animate(withDuration: 0.25, animations: {   [unowned self] in
            self.triangleIcon.layer.transform = CATransform3DIdentity
            self.optiontableView.transform = .identity
            })
    }
}

extension NotReplenishedGoodsListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let param = ContainerSessionParam()
        param.goodsSn = listVM.models.value[indexPath.row].goodsSn
        HUD.showLoading()
        listVM.requestWaitSupplyGoodsDetail(param)
            .subscribe(onNext: {[weak self] (detail) in
               self?.notreplenishmentView.config(detail)
               self?.notreplenishmentView.show()
            }, onError: { (error) in
                if let error = error as? AppError {
                    HUD.hideLoading()
                    HUD.showError(error.message)
                }
            }, onCompleted: {
                 HUD.hideLoading()
            })
        .disposed(by: disposeBag)
        notreplenishmentView.replenishAction = { [weak self] count in
            guard let weakSelf = self else {
                return
            }
            let selectedGoods = weakSelf.listVM.models.value[indexPath.row]
            selectedGoods.waitSupplyCount =  selectedGoods.waitSupplyCount - count
            weakSelf.listVM.models.value.remove(at: indexPath.row)
            weakSelf.listVM.models.value.append(selectedGoods)
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
}

extension NotReplenishedGoodsListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listVM.models.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoodListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if indexPath.row < listVM.models.value.count {
            cell.configWaitSupplyGoods(listVM.models.value[indexPath.row])
        }
        cell.hiddenCover()
        return cell
    }
}
