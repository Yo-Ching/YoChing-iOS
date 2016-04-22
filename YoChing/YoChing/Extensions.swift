//
//  Extensions.swift
//  YoChing
//
//  Created by SirWellington on 11/11/15.
//  Copyright © 2015 YoChing. All rights reserved.
//

import AromaSwiftClient
import Foundation
import UIKit

extension Int {

    func isEven() -> Bool {
        return self % 2 == 0
    }

    func isOdd() -> Bool {
        return !self.isEven()
    }
    
    static func random(from begin: Int, to end: Int) -> Int {
        
        guard begin < end else { return 0 }
        
        let difference = end - begin
        
        let random = arc4random_uniform(UInt32(difference))
        
        return begin + Int(random)
    }
}

//MARK: UIViewController

//Hides the Navigation Bar Lip
extension UIViewController {

    func hideNavigationBarShadow() {
        let emptyImage = UIImage()
        self.navigationController?.navigationBar.shadowImage = emptyImage
        self.navigationController?.navigationBar.setBackgroundImage(emptyImage, forBarMetrics: UIBarMetrics.Default)
    }

    var isiPhone: Bool {
        return UI_USER_INTERFACE_IDIOM() == .Phone
    }

    var isiPad: Bool {
        return UI_USER_INTERFACE_IDIOM() == .Pad
    }
}

//MARK: Opening Links
extension UIViewController {
    
    func openLink(link: String) {
        
        guard let url = link.toURL() else { return }
        
        defer {
            AromaClient.beginWithTitle("Opened Link")
                .withPriority(.MEDIUM)
                .addBody(link)
                .send()
        }
        
        let app = UIApplication.sharedApplication()
        app.openURL(url)
    }
}


//MARK: String Operations
public extension String {
    public var length: Int { return self.characters.count }

    public func toURL() -> NSURL? {
        return NSURL(string: self)
    }
}

//MARK: UITableView Controllers
extension UITableViewController {
    func reloadSection(section: Int, animation: UITableViewRowAnimation = .Automatic) {

        let section = NSIndexSet(index: section)
        self.tableView?.reloadSections(section, withRowAnimation: animation)
    }

    func setSprayForBlackBackground() {

        let imageName = "spray.galaxy.black.transparent"
        setBackground(imageName)
    }

    func setSprayForWhiteBackground() {

        let imageName = "spray.galaxy.white.transparent"
        setBackground(imageName)
    }

    private func setBackground(imageName: String) {
        guard let image = UIImage(named: imageName) else { return }
        guard let frame = self.view?.frame else { return }

       let imageView = UIImageView(frame: frame)
       imageView.backgroundColor = UIColor.clearColor()

       imageView.contentMode = .ScaleAspectFill
       imageView.image = image
       self.tableView.backgroundView = imageView

    //    self.view.backgroundColor = UIColor(patternImage: image)
    //    self.view.opaque = false
    //    self.view.layer.opaque = false
    }
}
