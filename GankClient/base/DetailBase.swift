//
//  DetailBase.swift
//  BeautyClient
//
//  Created by DreamLin on 2017/12/13.
//  Copyright © 2017年 YunDong. All rights reserved.
//

import UIKit

class DetailBase: UIView {

    private let MAX_SCALE:CGFloat = 2 //最大缩放比例
    private var currentDetailWidth:CGFloat!
    var viewController:UIViewController!
    var detail:UIImageView!
    var parentView:UIView?
    var currentOrientation = UIDevice.current.orientation
    var currentImage:UIImage?
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    init(frame: CGRect, vc:UIViewController) {
        super.init(frame: frame)
        viewController = vc
        NotificationCenter.default.addObserver(self, selector: #selector(onOrientationChanged(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        self.initView()
        screenWidth = UIScreen.main.bounds.width
        screenHeight = UIScreen.main.bounds.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onOrientationChanged(_ notifitation: Notification){
        
        let orientation = UIDevice.current.orientation
        if orientation == currentOrientation{
            return
        }
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            
            if parentView != nil {
                parentView?.removeFromSuperview()
                self.frame = (self.superview?.frame)!
                self.initView()
            }
            
            break
        case .portrait:
            if parentView != nil {
                parentView?.removeFromSuperview()
                self.frame = (self.superview?.frame)!
                self.initView()
            }
            break
        default:
            
            break
        }
        currentOrientation = orientation
    }
    
    func initView(){
        
        parentView = UIView.init(frame: self.frame)
        parentView?.backgroundColor = UIColor.lightGray
        detail = UIImageView.init(frame: self.frame)
        detail.clipsToBounds = true
        detail.contentMode = .scaleAspectFit
        detail.isUserInteractionEnabled = true
        detail.isMultipleTouchEnabled = true
        if self.currentImage != nil {
            detail.image = currentImage
        }
        
        //单击手势
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(onSingleTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        detail.addGestureRecognizer(tap)
        //双击手势
        let tapDouble = UITapGestureRecognizer.init(target: self, action: #selector(onDoubleTap(_:)))
        tapDouble.numberOfTapsRequired = 2
        tapDouble.numberOfTouchesRequired = 1
        detail.addGestureRecognizer(tapDouble)
        tap.require(toFail: tapDouble)
        //长按手势
        let long = UILongPressGestureRecognizer.init(target: self, action: #selector(onLongPressed(_:)))
        detail.addGestureRecognizer(long)
        //缩放手势
        let scale = UIPinchGestureRecognizer.init(target: self, action: #selector(onScale(_:)))
        detail.addGestureRecognizer(scale)
        parentView?.addSubview(detail)
        //拖拽手势
        let translate = UIPanGestureRecognizer.init(target: self, action: #selector(onMove(_:)))
        translate.delegate = self
        detail.addGestureRecognizer(translate)
        /**
         *  这里 使用代理开启同时多手势检测,避免滑动和移动手势的冲突
         **/
        
        self.addSubview(parentView!)
        
    }
    
    func showDetail(image:UIImage?){
        self.detail.image = image
        self.currentImage = image
    }
    
    func removeSelfView(){
        
        self.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
        
    }
    
}

extension DetailBase : UIGestureRecognizerDelegate{
    
    //开启同时多手势检测
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func onSingleTap(_ tap:UITapGestureRecognizer){
        self.removeSelfView()
    }
    
    @objc func onDoubleTap(_ tap:UITapGestureRecognizer){
        
        if detail != nil{
            detail.frame = self.frame
        }
        
    }
    
    @objc func onLongPressed(_ sender: UILongPressGestureRecognizer){
        self.showOptions()
    }
    
    @objc func onScale(_ scale:UIPinchGestureRecognizer){
        let scaleView = scale.view
        currentDetailWidth = scaleView?.frame.width
        if scale.state == .began || scale.state == .changed{
            
            if scale.scale < 1 {
                scaleView?.frame = self.frame
                scale.scale = 1
            }
            
            if scale.scale > MAX_SCALE {
                scale.scale = MAX_SCALE
            }
            
            scaleView?.transform = CGAffineTransform.init(scaleX: scale.scale, y: scale.scale)
            
        }
    }
    
    @objc func onMove(_ translate:UIPanGestureRecognizer){
        
        let translateView = translate.view
        if translate.state == .began || translate.state == .changed{
            
            let point = translate.translation(in: translateView?.superview)
            /**
             *限制滑动范围
             **/
            let newX = (translateView?.center.x)! + point.x
            let newY = (translateView?.center.y)! + point.y
            let maxX = (translateView?.frame.width)! / 2
            let minX = self.frame.width - maxX
            let maxY = (translateView?.frame.height)! / 2
            let minY = self.frame.height - maxY
            if newX < maxX && newX > minX && newY > minY && newY < maxY{
                translateView?.center = CGPoint.init(x: newX, y: newY)
                translate.setTranslation(CGPoint.zero, in: translateView?.superview)
            }
            
        }
        
    }
    
    //检测是否缩放
    func checkScale() -> Bool{
        
        currentDetailWidth = detail.frame.width
        if currentDetailWidth > self.frame.width{
            return true
        }
        return false
    }
    
    //检测是否处于边界位置
    func checkIsEnd() -> Bool{
        let reach = CGFloat(30)
        if detail.center.x > self.frame.width / 2{
            
            if detail.frame.minX + reach >= self.frame.minX{
                return true
            }else{
                return false
            }
            
        }else{
            
            if detail.frame.maxX - reach <= self.frame.maxX{
                return true
            }else{
                return false
            }
        }
    }
    
}

extension DetailBase {
    
    func showOptions(){
        
        let alertVC = UIAlertController.init(title: "想对妹子做些什么呢", message: "有钱才可以为所欲为", preferredStyle: .alert)
        
        let saveAction = UIAlertAction.init(title: "保存", style: .default) { (save) in
            self.saveGirl()
        }
        alertVC.addAction(saveAction)
        
        let shareAction = UIAlertAction.init(title: "分享", style: .default) { (share) in
            self.shareGirl()
        }
        alertVC.addAction(shareAction)
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        viewController.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func saveGirl(){
        if let image = self.detail.image{
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveFinished(image:error:contentInfo:)), nil)
        }
    }
    
    @objc func shareGirl(){
        if let image = self.detail.image{
            let text = "分享漂亮妹纸一枚!"
            let activityController = UIActivityViewController.init(activityItems: [text, image], applicationActivities: nil)
            viewController.present(activityController, animated: true, completion: nil)
        }
    }
    
    @objc func saveFinished(image: UIImage, error: NSErrorPointer, contentInfo: UnsafeRawPointer){
        
        var message = "保存成功!"
        var okTitle = "好滴"
        if error != nil{
            Logger.info(object: error?.debugDescription ?? "")
            message = "保存失败"
            okTitle = "好吧"
        }
        let alertController = UIAlertController.init(title: "保存结果", message: message, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction.init(title: okTitle, style: .cancel, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}

