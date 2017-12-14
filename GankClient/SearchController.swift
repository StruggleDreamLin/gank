//
//  SearchControllerViewController.swift
//  BeautyClient
//
//  Created by DreamLin on 2017/12/13.
//  Copyright © 2017年 YunDong. All rights reserved.
//

import UIKit
import ESPullToRefresh

class SearchController: UIViewController {
    
    let MAX_PAGE = 20
    var currentPage = 1
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var results:[SearchSoul] = []{
        didSet{
            tableView.reloadData()
        }
    }
    private var searchStr:String?{
        willSet{
            currentSearchStr = newValue!
        }
    }
    private var currentSearchStr:String?
    private var detail:DetailBase?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 560  //预估高度
        tableView.rowHeight = UITableViewAutomaticDimension //开启高度预估
        tableView.separatorColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "TechCell", bundle: nil), forCellReuseIdentifier: "techCell")
        tableView.register(UINib.init(nibName: "GirlTableCell", bundle: nil), forCellReuseIdentifier: "girlsTabCell")
        searchBar.delegate = self
        tableView.es.addPullToRefresh { [weak self] in
            self?.onSearch()
        }
        
        tableView.es.addInfiniteScrolling { [weak self] in
            self?.onLoadmore()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchController : UITableViewDataSource{
    
    func onSearch(){
        if self.searchStr != nil {
            
            if searchStr!.isEmpty{
                tableView.es.stopPullToRefresh()
                return
            }
            
            if !(self.searchStr?.isEmpty)!{
                //start searching
                NetManager.shared.searchData(searchStr: self.searchStr!, category: "all", count: 10, page: 1, completion: { (souls) in
                    
                    if souls != nil{
                        if souls!.count > 0{
                            self.results = souls!
                            self.currentPage = 1
                        }else{
                            //提示无搜索结果
                            self.tipsNoResults()
                        }
                    }
                    
                    self.tableView.es.stopPullToRefresh()
                })
            }
        }
        tableView.es.stopPullToRefresh()
    }
    
    func onLoadmore(){
        
        if currentSearchStr == nil{
            self.tableView.es.stopLoadingMore()
            return
        }
        if currentSearchStr!.isEmpty{
            self.tableView.es.stopLoadingMore()
            return
        }
        
        if currentPage < MAX_PAGE{
            
            NetManager.shared.searchData(searchStr: currentSearchStr!, category: "all", count: 10, page: currentPage + 1, completion: { (souls) in
                
                if souls != nil{
                    if souls!.count > 0{
                        self.results += souls!
                        self.currentPage += 1
                    }else{
                        self.tableView.es.noticeNoMoreData()
                    }
                }
                self.tableView.es.stopLoadingMore()
                
            })
            
        }else{
            self.tableView.es.noticeNoMoreData()
        }
    }
    
    func showGirl(image:UIImage){
        if detail == nil{
            let frame = self.view.frame
            //        frame.origin.y = searchBar.frame.maxY
            detail = DetailBase.init(frame: frame, vc: self)
            self.view.addSubview(detail!)
        }
        detail?.showDetail(image: image)
    }
    
    func tipsNoResults(){
        
        let alertController = UIAlertController.init(title: "未搜索到结果", message: nil, preferredStyle: .actionSheet)
        let okAction = UIAlertAction.init(title: "好吧!", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

extension SearchController : UITableViewDelegate, UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.canResignFirstResponder {
            searchBar.resignFirstResponder()
        }
        
        searchStr = searchBar.text
        self.onSearch()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let soul = self.results[indexPath.row]
        if soul.type == GankCategory.福利.rawValue {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "girlsTabCell") as! GirlTableCell
            cell.setSoul(soul: soul)
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "techCell") as! TechCell
            let commonCell = CommanSoul.init(desc: soul.desc, type: soul.type, url: soul.url, who: soul.who)
            cell.setSoul(soul: commonCell)
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let cell = tableView.cellForRow(at: indexPath)
        if cell is GirlTableCell{
            self.showGirl(image: (cell as! GirlTableCell).girlImage.image!)
        }else{
            let soul = self.results[indexPath.row]
            let commonSoul = CommanSoul.init(desc: soul.desc, type: soul.type, url: soul.url, who: soul.who)
            self.navigationController?.pushViewController(WebViewController.init(soul: commonSoul), animated: true)
        }
    }
    
    
}








