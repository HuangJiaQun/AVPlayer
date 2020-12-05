//
//  WkWebViewVC.swift
//  AVPlayer
//
//  Created by 黄嘉群 on 2020/11/30.
//  Copyright © 2020 黄嘉群. All rights reserved.
//

import UIKit
import WebKit
class WkWebViewVC: UIViewController {
    var wkWebView : WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpWKwebView()
        // Do any additional setup after loading the view.
    }
    
    func setUpWKwebView(){
        self.title = "WebView播放视频"
        self.view.backgroundColor = UIColor.white
        let url = NSURL(string: urlString)
        let request = NSURLRequest.init(url: url! as URL)
        self.wkWebView = WKWebView(frame: self.view.bounds)
        self.wkWebView.load(request as URLRequest)
        self.wkWebView.navigationDelegate = self as? WKNavigationDelegate
        self.wkWebView.uiDelegate = self as? WKUIDelegate
        self.view.addSubview(self.wkWebView!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
