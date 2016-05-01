//
//  SettingsViewController.swift
//  YoChing
//
//  Created by SirWellington on 4/11/16.
//  Copyright © 2016 Yo Ching. All rights reserved.
//

import AromaSwiftClient
import Foundation

class Settings {
    
    //MARK: User Preferences
    private static let defaults = NSUserDefaults.standardUserDefaults()
    private static let CLASSIC_KEY = "YoChing.Classic"
    private static let QUICK_KEY = "YoChing.Quick"
    
    private static let COINS_STREET = "YoChing.Street"
    private static let COINS_SLICK = "YoChing.Slick"
    
    
    private(set) static var isQuickEnabled: Bool {
        get {
            return defaults.objectForKey(QUICK_KEY) as? Bool ?? false
        }
        set(newValue) {
            defaults.setObject(newValue, forKey: QUICK_KEY)
        }
    }
    
     static var isClassicEnabled: Bool {
        return !isQuickEnabled
    }
    
    private(set) static var isSlickEnabled: Bool {
        get {
            return defaults.objectForKey(COINS_SLICK) as? Bool ?? false
        }
        set(newValue) {
            defaults.setObject(newValue, forKey: COINS_SLICK)
        }
    }
    
    static var isStreetEnabled: Bool {
        return !isSlickEnabled
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
    private let BUY_BOOK_LINK = "http://www.amazon.com/Yo-Ching-Ancient-Knowledge-Streets/dp/0996462503"
    private let BOOK_INFO_LINK = "http://yoching.net"

    //Mark: Throwing Style Paths
    private let classicPath = NSIndexPath(forRow: 1, inSection: 0)
    private let tapThatPath = NSIndexPath(forRow: 2, inSection: 0)
    
    //MARK : Coin Styles
    private let streetPath = NSIndexPath(forRow: 1, inSection: 1)
    private let slickPath = NSIndexPath(forRow: 2, inSection: 1)
    
    //MARK: Info Paths
    private let getBookPath = NSIndexPath(forRow: 1, inSection: 2)
    private let seeStreetCredsPath = NSIndexPath(forRow: 2, inSection: 2)
    private let seeInfoPath = NSIndexPath(forRow: 3, inSection: 2)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideNavigationBarShadow()
        setSprayForBlackBackground()
        
        addSwipeGesture()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    private func addSwipeGesture() {
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.onSwipe(_:)))
        swipeGesture.direction = .Left
        
        self.tableView.addGestureRecognizer(swipeGesture)
    }
    
    func onSwipe(gesture: UIGestureRecognizer) {
        self.exit()
    }
}

//MARK: Table View Delegates
//MARK: Throwing Style configuration
extension SettingsViewController {
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        setLookForCell(tableView, forIndexPath: indexPath)
        cell.backgroundColor = cell.contentView.backgroundColor
    }
    
    private func setLookForCell(tableView: UITableView, forIndexPath indexPath: NSIndexPath) {
       
        if indexPath == classicPath {
            if Settings.isClassicEnabled {
                classicCheckmark.hidden = false
                classicLabel.textColor = UIColor.whiteColor()
            }
            else {
                classicCheckmark.hidden = true
                classicLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
            }
        }
        else if indexPath == tapThatPath {
            if Settings.isQuickEnabled {
                tapThatCheckmark.hidden = false
                tapThatLabel.textColor = UIColor.whiteColor()
            }
            else {
                tapThatCheckmark.hidden = true
                tapThatLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
            }
        }
        else if indexPath == streetPath {
            if Settings.isStreetEnabled {
                streetCheckmark.hidden = false
                streetLabel.textColor = UIColor.whiteColor()
            }
            else {
                streetLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
                streetCheckmark.hidden = true
            }
        }
        else if indexPath == slickPath {
            if Settings.isSlickEnabled {
                slickLabel.textColor = UIColor.whiteColor()
                slickCheckmark.hidden = false
            }
            else {
                slickLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
                slickCheckmark.hidden = true
            }
        }
    }
}

//MARK : Segues
extension SettingsViewController {
    
    private func exit() {
        self.performSegueWithIdentifier("unwind", sender: self)
    }
    
    private func goToCredits() {
        self.performSegueWithIdentifier("ToCredits", sender: self)
    }
    
    @IBAction func unwindFromCredits(segue: UIStoryboardSegue) {
        
    }
    
}


//MARK: Opening Links
extension SettingsViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if indexPath == getBookPath {
            self.openLink(BUY_BOOK_LINK)
        }
        else if indexPath == seeInfoPath {
            self.openLink(BOOK_INFO_LINK)
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
                AromaClient.sendMediumPriorityMessage(withTitle: "Enable TRUE PLAYER Setting")
            }
            
            self.setLookForCell(tableView, forIndexPath: classicPath)
            self.setLookForCell(tableView, forIndexPath: tapThatPath)
            
            tableView.deselectRowAtIndexPath(classicPath, animated: true)
            tableView.deselectRowAtIndexPath(tapThatPath, animated: true)
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
            
            tableView.deselectRowAtIndexPath(streetPath, animated: true)
            tableView.deselectRowAtIndexPath(slickPath, animated: true)
        }
        

    }

}
