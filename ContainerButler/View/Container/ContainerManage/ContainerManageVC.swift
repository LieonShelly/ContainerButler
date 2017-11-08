//
//  ContainerManageVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ContainerManageVC: BaseViewController {
    var container: Container?
   var currentScence: Scence?
    fileprivate lazy var pageTitleView: PageTitleView = {
        let pvc = PageTitleView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44), titles: ["待补商品", "全部商品"])
        pvc.backgroundColor = .white
        return pvc
    }()
    fileprivate lazy var pageContenView: PageContentView  = { [unowned self] in
        var childVCs = [UIViewController]()
        let notReplenishVC = NotReplenishedVC()
        let wholeGoodsVC = WholeGoodsVC()
        notReplenishVC.containerId = self.container?.containerId ?? 0
        notReplenishVC.currentScence = self.currentScence
        wholeGoodsVC.containerId = self.container?.containerId ?? 0
        childVCs.append(notReplenishVC)
        childVCs.append(wholeGoodsVC)
        let pageContenView = PageContentView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 44 - 64), childVCs: childVCs, parentVC: self)
        pageContenView.collectView.isScrollEnabled = false
        return pageContenView
        }()
    
    deinit {
        debugPrint("dsfa")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tapAction()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navi = navigationController as? NavigationController {
            navi.reomvePopbackGesture()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navi = navigationController as? NavigationController {
            navi.addPopbackGesture()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       
    }
}

extension ContainerManageVC {
    private  func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        title = "\(container?.name ?? "")" +  "管理"
        view.addSubview(pageTitleView)
        view.addSubview(pageContenView)
        let centerLine = UIView()
        centerLine.backgroundColor = UIColor(hex: 0xefefef)
        pageTitleView.addSubview(centerLine)
        centerLine.snp.makeConstraints {
            $0.top.equalTo(3)
            $0.bottom.equalTo(-3)
            $0.width.equalTo(1)
            $0.centerX.equalTo(pageTitleView.snp.centerX)
        }
    }
    
    private  func tapAction() {
        pageTitleView.titleTapAction = {[weak self] seletedIndex in
            self?.pageContenView.selected(index: seletedIndex)
        }
        pageContenView.tapAction = {[weak self] (progress, souceIndex, targetIndex) in
            self?.pageTitleView.setTitle(progress: progress, sourceIndex: souceIndex, targetIndex: targetIndex)
        }
    }
    
}

extension ContainerManageVC {
    fileprivate func complishAction() {
        let sheet = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        let camerAction = UIAlertAction(title: "拍照", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.getNewImg(type: UIImagePickerControllerSourceType.camera)
            }
        }
        let photoAction = UIAlertAction(title: "从手机相册中选择", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.getNewImg(type: UIImagePickerControllerSourceType.photoLibrary)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) -> Void in
        }
        sheet.addAction(camerAction)
        sheet.addAction(photoAction)
        sheet.addAction(cancelAction)
        present(sheet, animated: true, completion: nil)
    }
    
    private func getNewImg(type: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = type
        imagePicker.cropMode = DZNPhotoEditorViewControllerCropMode.circular
        imagePicker.finalizationBlock = {[weak self](picker, info) in
            if let image: UIImage = info?[UIImagePickerControllerEditedImage] as? UIImage {
                print("image: \(image)")
                if  let _: Data = UIImageJPEGRepresentation(image, 0.1) {
                  
                }
            }
            self?.dismiss(animated: true, completion: nil)
        }
        imagePicker.cancellationBlock = {[weak self] (picker) in
            self?.dismiss(animated: true, completion: nil)
        }
        present(imagePicker, animated: true, completion: nil)
    }
}
