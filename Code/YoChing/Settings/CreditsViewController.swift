//
//  CreditsViewController.swift
//  YoChing
//
//  Created by SirWellington on 4/15/16.
//  Copyright © 2016 YoChing.net. All rights reserved.
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
    
    
    fileprivate let truePlayerPath = IndexPath(row: 0, section: 0)
    fileprivate let hughPath = IndexPath(row: 1, section: 0)
    fileprivate let marcPath = IndexPath(row: 2, section: 0)
    fileprivate let wellingtonPath = IndexPath(row: 3, section: 0)
    fileprivate let brendanPath = IndexPath(row: 4, section: 0)
    fileprivate let mayaPath = IndexPath(row: 5, section: 0)
    
    
    fileprivate lazy var links: [IndexPath : String] = [
        self.truePlayerPath : "http://www.yoching.net/about/",
        self.hughPath : "http://hugh-gallagher.com",
        self.marcPath : "http://github.com/mrisney",
        self.wellingtonPath : "http://sirwellington.tech/",
        self.brendanPath : "https://www.linkedin.com/in/brendankmiller/",
        self.mayaPath : "https://www.behance.net/mayasghr/"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSprayForBlackBackground()
        
        setLabel(truePlayerLabel, hughLabel, marcLabel, wellingtonLabel, brendanLabel, mayaLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    fileprivate func setLabel(_ labels: LTMorphingLabel...) {
        
        let text : [String] = labels.map() { $0.text }
        labels.forEach() { $0.morphingEnabled = false ; $0.text = nil }
        
        labels.enumerate()
            .reverse()
            .forEach() { i , label in
                label.morphingEnabled = true
                label.morphingEffect = .Anvil
                label.text = text[i]
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
}

//MARK : Table View Delegate Methods
extension CreditsViewController {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = cell.contentView.backgroundColor
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let link = links[indexPath] else { return }
        self.openLink(link)
    }
    
}
