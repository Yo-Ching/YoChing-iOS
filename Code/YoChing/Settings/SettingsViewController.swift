//
//  SettingsViewController.swift
//  YoChing
//
//  Created by SirWellington on 4/11/16.
//  Copyright © 2016 Yo Ching. All rights reserved.
//

import Archeota
import AromaSwiftClient
import Foundation

class Settings {
    
    //MARK: User Preferences
    fileprivate static let defaults = UserDefaults.standard
    fileprivate static let CLASSIC_KEY = "YoChing.Classic"
    fileprivate static let QUICK_KEY = "YoChing.Quick"
    
    fileprivate static let COINS_STREET = "YoChing.Street"
    fileprivate static let COINS_SLICK = "YoChing.Slick"
    
    
    fileprivate(set) static var isQuickEnabled: Bool {
        get {
            return defaults.object(forKey: QUICK_KEY) as? Bool ?? false
        }
        set(newValue) {
            defaults.set(newValue, forKey: QUICK_KEY)
        }
    }
    
     static var isClassicEnabled: Bool {
        return !isQuickEnabled
    }
    
    fileprivate(set) static var isSlickEnabled: Bool {
        get {
            return defaults.object(forKey: COINS_SLICK) as? Bool ?? false
        }
        set(newValue) {
            defaults.set(newValue, forKey: COINS_SLICK)
        }
    }
    
    static var isStreetEnabled: Bool {
        return !isSlickEnabled
    }
    
    //MARK: Determines if this is the first time the App has launched
    fileprivate static let firstTimeKey = "YoChing.FirstTime"
    
    static var isFirstTimeRunning: Bool {
        get {
            let defaults = UserDefaults()
            return defaults.object(forKey: firstTimeKey) as? Bool ?? true
        }
        set {
            let defaults = UserDefaults()
            defaults.set(newValue, forKey: firstTimeKey)
        }
    }
    
}

class SettingsViewController : UITableViewController {

    //MARK: Cell Outlets
    @IBOutlet weak var classicLabel: UILabel!
    @IBOutlet weak var classicCheckmark: UIImageView!
    
    @IBOutlet weak var tapThatLabel: UILabel!
    @IBOutlet weak var tapThatCheckmark: UIImageView!
    
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var streetCheckmark: UIImageView!
    
    @IBOutlet weak var slickLabel: UILabel!
    @IBOutlet weak var slickCheckmark: UIImageView!
    
    //MARK: Links to open
    fileprivate let BUY_BOOK_LINK = "http://www.amazon.com/Yo-Ching-Ancient-Knowledge-Streets/dp/0996462503"
    fileprivate let BOOK_INFO_LINK = "http://yoching.net"

    //Mark: Throwing Style Paths
    fileprivate let classicPath = IndexPath(row: 1, section: 0)
    fileprivate let tapThatPath = IndexPath(row: 2, section: 0)
    
    //MARK : Coin Styles
    fileprivate let streetPath = IndexPath(row: 1, section: 1)
    fileprivate let slickPath = IndexPath(row: 2, section: 1)
    
    //MARK: Info Paths
    fileprivate let getBookPath = IndexPath(row: 1, section: 2)
    fileprivate let seeStreetCredsPath = IndexPath(row: 2, section: 2)
    fileprivate let seeInfoPath = IndexPath(row: 3, section: 2)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideNavigationBarShadow()
        setSprayForBlackBackground()
        
        addSwipeGesture()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    fileprivate func addSwipeGesture() {
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.onSwipe(_:)))
        swipeGesture.direction = .left
        
        self.tableView.addGestureRecognizer(swipeGesture)
    }
    
    func onSwipe(_ gesture: UIGestureRecognizer) {
        self.exit()
    }
}

//MARK: Table View Delegates
//MARK: Throwing Style configuration
extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        setLookForCell(tableView, forIndexPath: indexPath)
        cell.backgroundColor = cell.contentView.backgroundColor
    }
    
    fileprivate func setLookForCell(_ tableView: UITableView, forIndexPath indexPath: IndexPath) {
       
        if indexPath == classicPath {
            
            if Settings.isClassicEnabled {
                
                classicCheckmark.isHidden = false
                classicLabel.textColor = UIColor.white
            }
            else {
                
                classicCheckmark.isHidden = true
                classicLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
            }
        }
        else if indexPath == tapThatPath {
            
            if Settings.isQuickEnabled {
                
                tapThatCheckmark.isHidden = false
                tapThatLabel.textColor = UIColor.white
            }
            else {
                
                tapThatCheckmark.isHidden = true
                tapThatLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
            }
        }
        else if indexPath == streetPath {
            
            if Settings.isStreetEnabled {
                
                streetCheckmark.isHidden = false
                streetLabel.textColor = UIColor.white
            }
            else {
                
                streetLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
                streetCheckmark.isHidden = true
            }
        }
        else if indexPath == slickPath {
            
            if Settings.isSlickEnabled {
                
                slickLabel.textColor = UIColor.white
                slickCheckmark.isHidden = false
            }
            else {
                
                slickLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
                slickCheckmark.isHidden = true
            }
        }
    }
}

//MARK : Segues
extension SettingsViewController {
    
    fileprivate func exit() {
        self.performSegue(withIdentifier: "unwind", sender: self)
    }
    
    fileprivate func goToCredits() {
        self.performSegue(withIdentifier: "ToCredits", sender: self)
    }
    
    fileprivate func goToTutorial() {
        self.performSegue(withIdentifier: "ToTutorial", sender: self)
    }
    
    @IBAction func unwindFromCredits(_ segue: UIStoryboardSegue) {
        
    }
    
}


//MARK: Opening Links
extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath == getBookPath {
            
            self.openLink(BUY_BOOK_LINK)
        }
        else if indexPath == seeInfoPath {
            
            //self.openLink(BOOK_INFO_LINK)
            self.goToTutorial()
        }
        else if indexPath == seeStreetCredsPath {
            
            AromaClient.sendLowPriorityMessage(withTitle: "Opened App Credits Page")
            self.goToCredits()
        }
        else if indexPath == classicPath || indexPath == tapThatPath {
            
            Settings.isQuickEnabled = indexPath == tapThatPath
            
            if Settings.isQuickEnabled {
                AromaClient.sendMediumPriorityMessage(withTitle: "Enabled TAP THAT Setting")
            }
            else {
                AromaClient.sendMediumPriorityMessage(withTitle: "Enabled TRUE PLAYER Setting")
            }
            
            self.setLookForCell(tableView, forIndexPath: classicPath)
            self.setLookForCell(tableView, forIndexPath: tapThatPath)
            
            tableView.deselectRow(at: classicPath, animated: true)
            tableView.deselectRow(at: tapThatPath, animated: true)
        }
        else if indexPath == streetPath || indexPath == slickPath {
            
            Settings.isSlickEnabled = indexPath == slickPath
            
            if Settings.isSlickEnabled {
                AromaClient.sendMediumPriorityMessage(withTitle: "Enabled SLICK COINS Setting")
            }
            else {
                AromaClient.sendMediumPriorityMessage(withTitle: "Enabled STREET COINS Setting")
            }
            
            self.setLookForCell(tableView, forIndexPath: streetPath)
            self.setLookForCell(tableView, forIndexPath: slickPath)
            
            tableView.deselectRow(at: streetPath, animated: true)
            tableView.deselectRow(at: slickPath, animated: true)
        }
        
        
    }
    
}
