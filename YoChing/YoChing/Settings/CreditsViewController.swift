//
//  CreditsViewController.swift
//  YoChing
//
//  Created by Juan Wellington Moreno on 4/15/16.
//  Copyright © 2016 YoChing.com. All rights reserved.
//

import Foundation
import LTMorphingLabel
import UIKit


class CreditsViewController : UITableViewController {
    
    @IBOutlet weak var truePlayerLabel: LTMorphingLabel!
    @IBOutlet weak var hughLabel: LTMorphingLabel!
    @IBOutlet weak var marcLabel: LTMorphingLabel!
    @IBOutlet weak var wellingtonLabel: LTMorphingLabel!
    @IBOutlet weak var brendanLabel: LTMorphingLabel!
    @IBOutlet weak var mayaLabel: LTMorphingLabel!
    
    
    
    private let truePlayerPath = NSIndexPath(forRow: 0, inSection: 0)
    private let hughPath = NSIndexPath(forRow: 1, inSection: 0)
    private let marcPath = NSIndexPath(forRow: 2, inSection: 0)
    private let wellingtonPath = NSIndexPath(forRow: 3, inSection: 0)
    private let brendanPath = NSIndexPath(forRow: 4, inSection: 0)
    private let mayaPath = NSIndexPath(forRow: 5, inSection: 0)
    
    
    private lazy var links: [NSIndexPath : String] = [
        self.truePlayerPath : "http://yoching.net",
        self.hughPath : "http://hughgallagher.net/",
        self.marcPath : "http://Github.com/mrisney",
        self.wellingtonPath : "http://sirwellington.tech/",
        self.brendanPath : "",
        self.mayaPath : ""
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSprayForBlackBackground()
        
        setLabel(truePlayerLabel, hughLabel, marcLabel, wellingtonLabel, brendanLabel, mayaLabel)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func setLabel(labels: LTMorphingLabel...) {
        
        let text : [String] = labels.map() { $0.text }
        labels.forEach() { $0.morphingEnabled = false ; $0.text = nil }
        
        labels.enumerate()
            .forEach() { i , label in
                label.morphingEnabled = true
                label.morphingEffect = .Anvil
                
                label.text = text[i]
        }
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