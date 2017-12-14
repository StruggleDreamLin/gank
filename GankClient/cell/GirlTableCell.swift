//
//  GirlTableCell.swift
//  BeautyClient
//
//  Created by DreamLin on 2017/12/13.
//  Copyright © 2017年 YunDong. All rights reserved.
//

import UIKit
import Kingfisher

class GirlTableCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var girlImage: UIImageView!
    var searchSoul:SearchSoul?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.girlImage.contentMode = .scaleToFill
        self.girlImage.layer.borderWidth = 15
        self.girlImage.layer.borderColor = UIColor.white.cgColor
        self.girlImage.layer.shadowOffset = CGSize.init(width: 5, height: 8)
        self.girlImage.layer.shadowOpacity = 0.5
        self.girlImage.layer.shadowColor = UIColor.lightGray.cgColor
        self.girlImage.alpha = 0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSoul(soul: SearchSoul){
        
        self.searchSoul = soul
        self.title.text = soul.type
        //        Logger.info(object: "\(soul.desc.count):\(soul.desc)")
        if soul.desc.count >= 50{
            let index = soul.desc.index(soul.desc.startIndex, offsetBy: String.IndexDistance.init(40))
            self.desc.text = soul.desc.prefix(upTo: index).appending("...")
        }else{
            self.desc.text = soul.desc
        }
        
        self.icon.image = UIImage.init(named: "lulu")
        self.girlImage.kf.setImage(with: URL.init(string: soul.url), placeholder: nil, options: nil, progressBlock: nil) { (image, error, cacheType, url) in
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.girlImage.alpha = 1.0
            }, completion: nil)
            
        }
        
    }
    
}
