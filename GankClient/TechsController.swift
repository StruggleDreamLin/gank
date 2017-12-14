//
//  TechsController.swift
//  BeautyClient
//
//  Created by DreamLin on 2017/12/12.
//  Copyright © 2017年 YunDong. All rights reserved.
//

import UIKit
import ESPullToRefresh

public enum ESRefreshExampleType {
    case defaulttype, meituan, wechat
}

class TechsController: UITableViewController {
    public var type: ESRefreshExampleType = .defaulttype
    var techs:[Soul] = []{
        didSet{
            tableView.reloadData()
        }
    }
    var dates:[String] = []
    var currentDateIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.register(UINib.init(nibName: "TechCell", bundle: nil), forCellReuseIdentifier: "techCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 560
        self.tableView.separatorStyle = .none
        self.tableView.separatorColor = UIColor.clear
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        self.getHistroy()
        tableView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.onRefresh()
        }
        
        tableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.onLoadmore()
        }
        
        self.tableView.refreshIdentifier = String.init(describing: type)
        self.tableView.expiredTimeInterval = 20.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension TechsController {
    
    func getHistroy(){
        
        NetManager.shared.getHistoryDate { (histroy) in
            
            self.dates = (histroy?.results)!
            self.onRefresh()
        }
        
//        //test
//        NetManager.shared.getCategoryData(category: "Android", count: 10, page: 1) { (souls) in
//            self.techs = (souls?.results)!
//        }
    }
    
    func onRefresh(){
        
        if dates.count > 0{
            NetManager.shared.getDataByDate(date: dates[0], completion: { (souls) in
                
                if souls != nil{
                    if souls!.count > 0{
                        self.techs = souls!
                        self.currentDateIndex = 1
                    }else{
                        //tips:未找到结果
                    }
                }
                self.tableView.es.stopPullToRefresh()
                
            })
        }
        
    }
    
    func onLoadmore(){
        
        if dates.count > currentDateIndex {
            
            NetManager.shared.getDataByDate(date: dates[currentDateIndex], completion: { (souls) in
                self.techs += souls!
                self.currentDateIndex += 1
                self.tableView.es.stopLoadingMore()
            })
            
        }else{
            //已经没有更多了
             self.tableView.es.noticeNoMoreData()
        }
    }
    
}

extension TechsController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return techs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "techCell", for: indexPath) as! TechCell
        
        // Configure the cell...
        let soul = techs[indexPath.row]
        let commonSoul = CommanSoul.init(desc: soul.desc, type: soul.type, url: soul.url, who: soul.who)
        cell.setSoul(soul: commonSoul)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let soul = self.techs[indexPath.row]
        let commonSoul = CommanSoul.init(desc: soul.desc, type: soul.type, url: soul.url, who: soul.who)
        self.navigationController?.pushViewController(WebViewController.init(soul: commonSoul), animated: true)
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
