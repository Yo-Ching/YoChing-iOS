//
//  Extensions.swift
//  YoChing
//
//  Created by SirWellington on 11/11/15.
//  Copyright © 2015 YoChing. All rights reserved.
//

//import AromaSwiftClient
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
        self.navigationController?.navigationBar.setBackgroundImage(emptyImage, for: UIBarMetrics.default)
    }

    var isiPhone: Bool {
        return UI_USER_INTERFACE_IDIOM() == .phone
    }

    var isiPad: Bool {
        return UI_USER_INTERFACE_IDIOM() == .pad
    }
}

//MARK: Adds a delay() function
extension UIViewController {

    func delay(_ delay: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
}

//MARK: Opening Links
extension UIViewController {

    func openLink(_ link: String) {

        guard let url = link.toURL() else { return }

        defer {
         /*
            AromaClient.beginWithTitle("Opened Link")
                .withPriority(.MEDIUM)
                .addBody(link)
                .send()
    */
 }
 

        let app = UIApplication.shared
        app.openURL(url)
    }
}

//MARK: String Operations
public extension String {
    public var length: Int { return self.characters.count }

    public func toURL() -> URL? {
        return URL(string: self)
    }
}

//MARK: UITableView Controllers
extension UITableViewController {
    func reloadSection(_ section: Int, animation: UITableViewRowAnimation = .automatic) {

        let section = IndexSet(integer: section)
        self.tableView?.reloadSections(section, with: animation)
    }

    func setSprayForBlackBackground() {

        let imageName = "spray.galaxy.black.transparent"
        setBackground(imageName)
    }

    func setSprayForWhiteBackground() {

        let imageName = "spray.galaxy.white.transparent"
        setBackground(imageName)
    }

    fileprivate func setBackground(_ imageName: String) {
        guard let image = UIImage(named: imageName) else { return }
        guard let frame = self.view?.frame else { return }

        let imageView = UIImageView(frame: frame)
        imageView.backgroundColor = UIColor.clear

        imageView.contentMode = .scaleAspectFill
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

    func adjustFontSizeToFitRect(_ rect: CGRect, minFontSize: Int = 5, maxFontSize: Int = 200) {

        guard let text = self.text else { return }

        frame = rect

        var right = maxFontSize
        var left = minFontSize

        let constraintSize = CGSize(width: rect.width, height: CGFloat.greatestFiniteMagnitude)

        while (left <= right) {

            let currentSize = (left + right) / 2
            font = font.withSize(CGFloat(currentSize))
            let text = NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
            let textRect = text.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, context: nil)

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
    
    func stringByReplacing(_ string: String, with replacement: String) -> String {
        
        let result = self.replacingOccurrences(of: string, with: replacement, options: .literal, range: nil)
        return result
    }
    
    func stringByRemovingWhitespace() -> String {
        return self.stringByReplacing(" ", with: "")
    }
}
