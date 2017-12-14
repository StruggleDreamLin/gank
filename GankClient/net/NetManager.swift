//
//  NetManager.swift
//  BeautyClient
//
//  Created by DreamLin on 2017/12/9.
//  Copyright © 2017年 YunDong. All rights reserved.
//

import Foundation
import Alamofire

class NetManager {
    
    static var shared:NetManager{
        struct Inner{
            static let shareInstance = NetManager.init()
        }
        return Inner.shareInstance
    }
    
    var baseApi:String = "http://gank.io/api/"
    //获取分类数据
    func getCategoryData(category:String, count:Int, page:Int, completion:@escaping (SoulData?)-> Void){
        
        let urlStr = "\(baseApi)data/\(category)/\(count)/\(page)"
//        let urlRequest = URLRequest.init(url: url!)
        Alamofire.request(urlStr).responseJSON { (response) in
            
            response.result.ifSuccess({
                                
                let decoder = JSONDecoder.init()
                let souls = try? decoder.decode(SoulData.self, from: response.data!)
                completion(souls!)
                return
            })
            response.result.ifFailure({
                completion(nil)
            })
            
        }
    }
    //获取妹子
    func getGirl(count:Int, page:Int, completion:@escaping (Girls?)-> Void){
        
        let urlStr = "\(baseApi)data/\(GankCategory.福利.rawValue)/\(count)/\(page)"
        let encodeUrlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)        
        let url = URL.init(string: encodeUrlStr!)
        var urlRequest = URLRequest.init(url: url!)
        urlRequest.httpMethod = "GET"
        Alamofire.request(urlRequest).responseJSON { (response) in
            
            response.result.ifSuccess({
                
                let decoder = JSONDecoder.init()
                let girls = try? decoder.decode(Girls.self, from: response.data!)
                completion(girls!)
                return
            })
            response.result.ifFailure({
                completion(nil)
            })
        }
    }
    
    //获取历史日期
    func getHistoryDate(completion:@escaping (HistoryDate?) -> Void){
        
        let url = "\(baseApi)day/history"
        Alamofire.request(url).responseJSON { (response) in
            
            if response.result.isSuccess{
                let decoder = JSONDecoder.init()
                let dates = try? decoder.decode(HistoryDate.self, from: response.data!)
                completion(dates!)
                
            }else{
                completion(nil)
            }
        }
    }
    
    //获取某日所有数据
    func getDataByDate(date:String, completion: @escaping ([Soul]?) -> Void){
        
        let url = "\(baseApi)day/\(date.replacingOccurrences(of: "-", with: "/"))"
        Alamofire.request(url).responseJSON { (response) in
            
            if response.result.isSuccess{
                
                let decoder = JSONDecoder.init()
                let ganks = try? decoder.decode(Gank.self, from: response.data!)
                if !(ganks?.error)!{
                    
                    let results = ganks?.results
                    var souls:[Soul] = []
                    if let android = results?.Android {
                        
                        if android.count > 0{
                            souls = souls + android
                        }
                    }
                    if let ios = results?.iOS {
                        if ios.count > 0{
                            souls = souls + ios
                        }
                    }
                    if let app = results?.App {
                        if app.count > 0{
                            souls = souls + app
                        }
                    }
                    if let 扩展资源 = results?.扩展资源 {
                        if 扩展资源.count > 0{
                            souls = souls + 扩展资源
                        }
                    }
                    if let 前端 = results?.前端 {
                        if 前端.count > 0{
                            souls = souls + 前端
                        }
                    }
                    if let 瞎推荐 = results?.瞎推荐 {
                        if 瞎推荐.count > 0{
                            souls = souls + 瞎推荐
                        }
                    }
                    if let 休息视频 = results?.休息视频 {
                        if 休息视频.count > 0{
                            souls = souls + 休息视频
                        }
                    }
                    completion(souls)
                    
                }else{
                    completion(nil)
                }
                
            }else{
                completion(nil)
            }
            
        }
        
    }
    
    func searchData(searchStr: String, category:String, count:Int, page:Int, completion:@escaping ([SearchSoul]?) -> Void){
        
        let urlStr = "\(baseApi)search/query/\(searchStr)/category/\(category)/count/\(count)/page/\(page)"
        let urlEncode = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL.init(string: urlEncode!)
        Alamofire.request(URLRequest.init(url: url!)).responseJSON { (response) in
            
            if response.result.isSuccess{
                
                let decoder = JSONDecoder.init()
                let searchResult = try? decoder.decode(Search.self, from: response.data!)
                completion(searchResult?.results)
                
            }else{
                completion(nil)
            }
            
        }
        
    }
    
}







