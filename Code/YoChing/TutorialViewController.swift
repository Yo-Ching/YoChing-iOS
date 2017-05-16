//
//  TutorialViewController.swift
//  YoChing
//
//  Created by SirWellington on 6/11/16.
//  Copyright © 2016 YoChing.net. All rights reserved.
//

//import AromaSwiftClient
import Foundation
import UIKit
import WebKit

class TutorialViewController : UIViewController {

    @IBOutlet var containerView: UIView!
    
    fileprivate var webView: WKWebView!
    
    let url = "https://www.youtube.com/embed/mCqsTEY-XVY?list=PLJfSQOoheuTsiV13Ozk0lgOSL4qUaE3x2".toURL()
    
    
    deinit {
        self.webView = nil
    }
    
    override func viewDidLoad() {
        
        guard let url = url
        else { return }
        
        let request = URLRequest(url: url as URL)
        
        self.webView.navigationDelegate = self
        self.webView.load(request)
        
     //   AromaClient.sendMediumPriorityMessage(withTitle: "Tutorial Opened")
    }
    
    override func loadView() {
        super.loadView()
        
        let webView = WKWebView()
        self.webView = webView
        self.view = webView
        
        app.isNetworkActivityIndicatorVisible = true
    }
}


extension TutorialViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        app.isNetworkActivityIndicatorVisible = false
    }
}
