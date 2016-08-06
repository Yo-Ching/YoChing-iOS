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

        guard begin != end else { return begin }
        guard begin < end else { return 0 }

        let difference = end - begin
        let random = arc4random_uniform(UInt32(difference))

        let result = begin + Int(random)

        if result >= end {
            return end - 1
        }
        else {
            return result
        }
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

//MARK: Adds a delay() function
extension UIViewController {

    func delay(delay: Double, closure: () -> ()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
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

        // self.view.backgroundColor = UIColor(patternImage: image)
        // self.view.opaque = false
        // self.view.layer.opaque = false
    }
}

//MARK: Arrays
extension Array {

    func selectOne() -> Element? {
        guard count > 0 else { return nil }

        var index = Int.random(from: 0, to: count)

        if index >= count { index -= 1 }

        return self[index]
    }
}

// MARK: UILabel
extension UILabel {

    func readjustLabelFontSize() {
        let rect = self.frame
        self.adjustFontSizeToFitRect(rect, minFontSize: 5, maxFontSize: 100)
    }

    func adjustFontSizeToFitRect(rect: CGRect, minFontSize: Int = 5, maxFontSize: Int = 200) {

        guard let text = self.text else { return }

        frame = rect

        var right = maxFontSize
        var left = minFontSize

        let constraintSize = CGSize(width: rect.width, height: CGFloat.max)

        while (left <= right) {

            let currentSize = (left + right) / 2
            font = font.fontWithSize(CGFloat(currentSize))
            let text = NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
            let textRect = text.boundingRectWithSize(constraintSize, options: .UsesLineFragmentOrigin, context: nil)

            let labelSize = textRect.size

            if labelSize.height < frame.height && labelSize.height >= frame.height - 10 && labelSize.width < frame.width && labelSize.width >= frame.width - 10 {
                break
            }
            else if labelSize.height > frame.height || labelSize.width > frame.width {
                right = currentSize - 1
            }
            else
            {
                left = currentSize + 1
            }
        }
    }
}

//MARK: String
extension String {
    
    func stringByReplacing(string string: String, with replacement: String) -> String {
        
        let result = self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: .LiteralSearch, range: nil)
        return result
    }
    
    func stringByRemovingWhitespace() -> String {
        return self.stringByReplacing(string: " ", with: "")
    }
}
