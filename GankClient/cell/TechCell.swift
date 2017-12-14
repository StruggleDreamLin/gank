//
//  TechCell.swift
//  BeautyClient
//
//  Created by DreamLin on 2017/12/12.
//  Copyright © 2017年 YunDong. All rights reserved.
//

import UIKit

class TechCell : UITableViewCell {
    

    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TechCell {
    
    func initView(){
        
        self.contentView.backgroundColor = UIColor.white
        
        self.typeImage.layer.cornerRadius = typeImage.bounds.width / 2
        
        title.textColor = UIColor.black
        title.textAlignment = .left
        self.contentMode = .scaleAspectFit
    }
    
    func setSoul(soul:CommanSoul){
                
        self.title.text = soul.type
//        Logger.info(object: "\(soul.desc.count):\(soul.desc)")
        if soul.desc.count >= 50{
            let index = soul.desc.index(soul.desc.startIndex, offsetBy: String.IndexDistance.init(40))
            self.desc.text = soul.desc.prefix(upTo: index).appending("...")
        }else{
            self.desc.text = soul.desc
        }
        
        switch soul.type {
        case GankCategory.Android.rawValue:
            self.typeImage.image = UIImage.init(named: "android")
            break
        case GankCategory.iOS.rawValue:
            self.typeImage.image = UIImage.init(named: "ios")
            break
        case GankCategory.休息视频.rawValue:
            self.typeImage.image = UIImage.init(named: "tv")
            break
        case GankCategory.前端.rawValue:
            self.typeImage.image = UIImage.init(named: "web")
            break
        default:
            self.typeImage.image = UIImage.init(named: "def")
            break
        }
//        if soul.isHeader != nil{
//            title?.font = UIFont.systemFont(ofSize: 25)
//            title?.text = soul.type
//        }else{
//            title?.font = UIFont.systemFont(ofSize: 18)
//            if soul.who != nil{
//                let text = "\(soul.desc!)(via.\(soul.who!))"
//                let via = NSString.init(string: "via.\(soul.who!)")
//                let range = via.range(of: text)
//                let show = NSMutableAttributedString.init(string: "\(soul.desc!)(via.\(soul.who!))")
//                show.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: range)
//                title?.attributedText = show
//            }else{
//                title?.text = soul.desc
//            }
//
//        }
        
    }
    
}
