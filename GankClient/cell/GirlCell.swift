//
//  GirlCellCollectionViewCell.swift
//  BeautyClient
//
//  Created by DreamLin on 2017/12/9.
//  Copyright © 2017年 YunDong. All rights reserved.
//

import UIKit
import Kingfisher
import Foundation

class GirlCell: UICollectionViewCell {
    
    var image:UIImageView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        self.image.alpha = 0
    }
    
    func initView(){
        
        self.clipsToBounds = false
        self.layer.borderWidth = 10
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.init(width: 2, height: 6)
        
        image = UIImageView.init(frame: self.frame)
        image.clipsToBounds = true
        image.frame = self.bounds
        image.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        image.contentMode = .scaleToFill
        self.addSubview(image)
    }
    
    func loadImage(girl: Girl){
        
        if let url = URL.init(string: girl.url!) {
            image.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { [weak self] (image, error, cacheType, url) in
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    self?.image.alpha = 1.0
                }, completion: nil)
            })
        }
    }
    
}
















