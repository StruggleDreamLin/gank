//
//  Logger.swift
//  BeautyClient
//
//  Created by DreamLin on 2017/12/9.
//  Copyright © 2017年 YunDong. All rights reserved.
//

import Foundation

class Logger {
    
    
    static func info(object:Any){
    
        if BuildConfig.debug{
            debugPrint(object)
        }
    }
    
    static func error(error:Any){
        
        if BuildConfig.debug{
            
        }
    }
    
}
