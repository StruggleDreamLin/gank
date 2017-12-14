//
//  GirlsController.swift
//  BeautyClient
//
//  Created by DreamLin on 2017/12/9.
//  Copyright © 2017年 YunDong. All rights reserved.
//

import UIKit
import ESPullToRefresh

class GirlsController: UICollectionViewController {
    private let MAX_PAGE_SIZE = 20
    var currentPage:Int = 1
    var girls: [Girl]?{
        didSet{
//            self.indexPaths = []
            collectionView?.reloadData()
        }
    }
    let padding = CGFloat(15)
    var detailView:DetailView!
    var indexPaths:[IndexPath]!{
        willSet{
//            Logger.info(object: "--------------------------------------")
//            for index in 0..<newValue.count{
//                Logger.info(object: "indexRow:\(newValue[index].row)")
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        indexPaths = []
        self.initView() 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
    
        self.view.backgroundColor = UIColor.darkGray
        self.automaticallyAdjustsScrollViewInsets = true
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let collectionViewLayout = UICollectionViewFlowLayout.init()
        collectionViewLayout.itemSize = CGSize(width:(self.view.bounds.width - 10 * 3) / 2, height:200)
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: (self.tabBarController?.tabBar.frame.height)! + statusBarHeight + 10, right: 10)
        
        var frame = self.view.bounds
        frame.origin.y += statusBarHeight
        collectionView = UICollectionView.init(frame: frame, collectionViewLayout: collectionViewLayout)        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.register(GirlCell.classForCoder(), forCellWithReuseIdentifier: "girlsCell")
        
        self.collectionView?.es.addPullToRefresh {
            self.onRefresh()
        }
        self.collectionView?.es.startPullToRefresh()
        self.collectionView?.es.addInfiniteScrolling {
            self.onLoadmore()
        }
    }

    func delay(time: TimeInterval, completionHandler: @escaping () -> Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            completionHandler()
        }
    }
    
    // MARK: - Table view data source
    
    func addDetailView(index:IndexPath){
        let frame = self.view.frame
        detailView = DetailView.init(frame: frame, vc: self)
        let cell = collectionView(collectionView!, cellForItemAt: index) as! GirlCell
        let image = cell.image.image
        detailView.showDetail(image: image, index: index)
        self.view.addSubview(detailView)
    }
    
}

extension GirlsController {
    
    func onRefresh(){
        
        NetManager.shared.getGirl(count: 20, page: 1) { (girlsData) in
            if girlsData != nil {
                if !(girlsData!.error){
                    self.girls = girlsData?.results
                    self.currentPage = 1
                     self.indexPaths = []
//                    self.collectionView?.reloadData()
                }
            }
            self.collectionView?.es.stopPullToRefresh()
        }
        
    }
    
    func onLoadmore(){
        
        if currentPage >= MAX_PAGE_SIZE {
            //tips:已经没有更多的妹子啦
            self.collectionView?.es.noticeNoMoreData()
            return
        }
        
        NetManager.shared.getGirl(count: 20, page: currentPage + 1) { (girlsData) in
            
            if girlsData != nil {
                if !(girlsData!.error){
                    self.girls = self.girls! + (girlsData?.results)!
                    self.currentPage += 1
                }
            }
            self.collectionView?.es.stopLoadingMore()
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        self.indexPaths = []
        var count = 0
        if girls != nil{
            count = (girls?.count)!
        }
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = "girlsCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? GirlCell
        cell?.loadImage(girl: self.girls![indexPath.row])
//        Logger.info(object: "row:\(indexPath.row)")
        if !indexPaths.contains(indexPath){
            self.indexPaths.append(indexPath)
        }
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.addDetailView(index: indexPath)
    }
    
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
}
