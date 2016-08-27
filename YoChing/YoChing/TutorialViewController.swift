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
    
    private var webView: WKWebView!
    
    let url = "https://www.youtube.com/embed/mCqsTEY-XVY?list=PLJfSQOoheuTsiV13Ozk0lgOSL4qUaE3x2".toURL()
    
    
    deinit {
        self.webView = nil
    }
    
    override func viewDidLoad() {
        
        guard let url = url
        else { return }
        
        let request = NSURLRequest(URL: url)
        
        self.webView.navigationDelegate = self
        self.webView.loadRequest(request)
        
     //   AromaClient.sendMediumPriorityMessage(withTitle: "Tutorial Opened")
    }
    
    override func loadView() {
        super.loadView()
        
        let webView = WKWebView()
        self.webView = webView
        self.view = webView
        
        app.networkActivityIndicatorVisible = true
    }
}


extension TutorialViewController : WKNavigationDelegate {
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        app.networkActivityIndicatorVisible = false
    }
}