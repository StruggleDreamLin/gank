//
//  WebViewController.swift
//  BeautyClient
//
//  Created by DreamLin on 2017/12/12.
//  Copyright © 2017年 YunDong. All rights reserved.
//

import UIKit
import ESPullToRefresh

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var noNetBtn: UIButton!
    @IBOutlet weak var webView: UIWebView!
    var sfWebView:UIWebView?
    var sfSoul:CommanSoul?
    
    init(soul:CommanSoul) {
        self.sfSoul = soul
        super.init(nibName: "WebViewController", bundle: nil)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Logger.info(object: "deinit:\(WebViewController.classForCoder())")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.noNetBtn.isHidden = true
        if let _ = self.webView {
            self.sfWebView = self.webView
        }else{
            self.sfWebView = UIWebView.init(frame: self.view.frame)
            self.view.addSubview(sfWebView!)
        }
        
        self.sfWebView?.delegate = self
        
        self.title = sfSoul?.desc
        let urlRequest = URLRequest.init(url: URL.init(string: (sfSoul?.url)!)!)
        
        self.sfWebView?.scrollView.es.addPullToRefresh {
            [weak self] in
            self?.sfWebView?.loadRequest(urlRequest)
        }
        self.sfWebView?.loadRequest(urlRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.sfWebView?.scrollView.es.stopPullToRefresh()
        self.sfWebView?.scrollView.bounces = true
        self.sfWebView?.scrollView.alwaysBounceVertical = true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        Logger.info(object: "error:\(error.localizedDescription)")
        self.sfWebView?.scrollView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
        if let er = error as? NSError {
            if er.code == 101{
                return
            }
            self.noNetBtn.isHidden = false
        }
        
    }

    @IBAction func onNetTipsPressed(_ sender: UIButton) {
        self.noNetBtn.isHidden = true
        UIView.performWithoutAnimation {
            self.sfWebView?.scrollView.es.startPullToRefresh()
        }
        
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
