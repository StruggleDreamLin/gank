//
//  DetailView.swift
//  BeautyClient
//
//  Created by DreamLin on 2017/12/11.
//  Copyright © 2017年 YunDong. All rights reserved.
//

import UIKit

class DetailView: DetailBase {

    var cvc:GirlsController
    var currentIndex:Int
    
    init(frame: CGRect, vc:GirlsController) {
        self.cvc = vc
        currentIndex = 0
        super.init(frame: frame, vc: vc)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        
        super.initView()
        let leftSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(onSwipe(_:)))
        leftSwipe.direction = .left
        leftSwipe.delegate = self
        detail.addGestureRecognizer(leftSwipe)

        //右滑
        let rightSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(onSwipe(_:)))
        rightSwipe.direction = .right
        rightSwipe.delegate = self
        detail.addGestureRecognizer(rightSwipe)

    }
    
    func showDetail(image:UIImage?, index: IndexPath){
        super.showDetail(image: image)
        self.currentIndex = index.row
    }
    
}

extension DetailView {
    

    
    @objc func onSwipe(_ swipe:UISwipeGestureRecognizer){
//        let swipeView = swipe.view
        
        if super.checkScale(){
            if !super.checkIsEnd(){
                return
            }
        }
        
        let direction = swipe.direction
        switch direction {
        case UISwipeGestureRecognizerDirection.left:
            
            currentIndex += 1
            
            break
            
        case UISwipeGestureRecognizerDirection.right:
            currentIndex -= 1
            
            break
        default:
            break
            
        }
        
        if currentIndex > cvc.indexPaths.count - 1{
            currentIndex = cvc.indexPaths.count - 1
            return
        }
        if currentIndex < 0 {
            currentIndex = 0
            return
        }
        switchImage(index: cvc.indexPaths[currentIndex])
        
    }
    
    //滑动切换图片
    func switchImage(index: IndexPath){
        detail.center = self.center
        let girl = cvc.collectionView(cvc.collectionView!, cellForItemAt: index) as! GirlCell
        detail.image = girl.image.image
    }
   
}










