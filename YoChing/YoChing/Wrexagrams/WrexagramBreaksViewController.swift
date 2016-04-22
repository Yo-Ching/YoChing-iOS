//
//  WrexegramBreaksViewController.swift
//  YoChing
//
//  Created by SirWellington on 11/11/15.
//  Copyright © 2015 Gary.com. All rights reserved.
//

import Foundation
import UIKit

class WrexagramBreaksViewController : UIViewController {
    
    @IBOutlet weak var wrexegramImage: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var textView: UITextView!
    
    var outcome: Int = -1
    
    override func viewDidLoad() {
        if outcome < 0 {

            return
        }
        
    }
    
    @IBAction func popBackToBeginning(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}