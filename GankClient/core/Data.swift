//
//  Data.swift
//  BeautyClient
//
//  Created by DreamLin on 2017/12/8.
//  Copyright © 2017年 YunDong. All rights reserved.
//

import Foundation

enum GankCategory : String {
    case 福利
    case iOS
    case Android
    case App
    case 扩展资源
    case 前端
    case 瞎推荐
    case 休息视频
}

struct Gank : Decodable{
    let category:[String]!
    let error:Bool!
    let results: GankData
}

struct GankData : Decodable{
    
    let Android:[Soul]?
    let iOS:[Soul]?
    let App:[Soul]?
    let 休息视频:[Soul]?
    let 扩展资源:[Soul]?
    let 前端:[Soul]?
    let 瞎推荐:[Soul]?
    let 福利:[Girl]?
}

struct SoulData : Decodable {
    let error: Bool
    let results: [Soul]
}

struct Soul : Decodable{
    
    let _id:String
    let createdAt:String
    let desc:String
    let publishedAt:String
    let images:[String]?
    let type:String
    let source:String?
    let url:String
    let used:Bool?
    let who:String?
    
}

struct Girls : Decodable {
    
    let error: Bool
    let results: [Girl]
    
}

struct Girl : Decodable{
    
    let _id:String
    let createdAt:String?
    let desc:String?
    let publishedAt:String?
    let type:String!
    let source:String?
    let url:String?
    let used:Bool?
    let who:String?
    
}

struct HistoryDate : Decodable {
    let error: Bool
    let results: [String]
}

struct Search : Decodable {
    
    let count:Int
    let error:Bool
    let results:[SearchSoul]
    
}

struct SearchSoul : Decodable {
    let desc:String
    let ganhuo_id:String
    let publishedAt:String
    let readability:String?
    let type:String
    let url:String
    let who:String?
}

struct CommanSoul {
    var desc:String
    var type:String
    var url:String
    var who:String?
}







