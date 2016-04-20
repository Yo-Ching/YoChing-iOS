//
//  CreditsViewController.swift
//  YoChing
//
//  Created by Juan Wellington Moreno on 4/15/16.
//  Copyright © 2016 YoChing.com. All rights reserved.
//

import Foundation
import UIKit


class CreditsViewController : UITableViewController {
    
    private let truePlayerPath = NSIndexPath(forRow: 0, inSection: 0)
    private let hughPath = NSIndexPath(forRow: 1, inSection: 0)
    private let marcPath = NSIndexPath(forRow: 2, inSection: 0)
    private let wellingtonPath = NSIndexPath(forRow: 3, inSection: 0)
    private let brendanPath = NSIndexPath(forRow: 4, inSection: 0)
    private let mayaPath = NSIndexPath(forRow: 5, inSection: 0)
    
    
    private lazy var links: [NSIndexPath : String] = [
        self.truePlayerPath : "http://yoching.net",
        self.hughPath : "hugh.com",
        self.marcPath : "http://Github.com/marcrisney",
        self.wellingtonPath : "http://sirwellington.tech/",
        self.brendanPath : "",
        self.mayaPath : ""
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSprayForBlackBackground()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}

//MARK : Table View Delegate Methods
extension CreditsViewController {
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = cell.contentView.backgroundColor
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let link = links[indexPath] else { return }
        self.openLink(link)
    }
}