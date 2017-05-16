//
//  WrexegramViewController.swift
//  YoChing
//
//  Created by SirWellington on 11/11/15.
//  Copyright © 2015 YoChing. All rights reserved.
//

import AromaSwiftClient
import Foundation
import LTMorphingLabel
import UIKit

class WrexagramViewController : UITableViewController {
    
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var wrexegramImage: UIImageView!
    @IBOutlet weak var wrexagramTitle: LTMorphingLabel!

    
    var wrexagramNumber: Int = -1
    var wrexagram: Wrexagram?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard wrexagramNumber > 0 else {
            
            defer {
                
                AromaClient.beginMessage(withTitle: "Invalid Logic")
                    .withPriority(.high)
                    .addBody("Loaded WrexagramViewController with bad Wrex Number").addLine(2)
                    .addBody("\(wrexagramNumber)")
                    .send()
            }
            
            self.parent?.dismiss(animated: true, completion: nil)
            return
        }
        
        if let wrexagram = self.wrexagram ?? determineWrexagramFromNumber(wrexagramNumber) {
            
            defer { self.wrexagram = wrexagram }
            
            AromaClient.sendLowPriorityMessage(withTitle: "Wrexagram Viewed", withBody: wrexagram.asString)
        }
        else {
            AromaClient.sendLowPriorityMessage(withTitle: "Wrexagram Viewed", withBody: "Wrexagram \(wrexagramNumber)")
        }
        
        setNavTitle()
        loadImage()
        delay(0.1) { self.loadTitle() }
    }
    
    fileprivate func setNavTitle() {
        navTitle.text = "WREXAGRAM \(wrexagramNumber)"
    }
    
    fileprivate func loadTitle() {
        wrexagramTitle.adjustsFontSizeToFitWidth = true
        wrexagramTitle.morphingEffect = .anvil
        wrexagramTitle.text = wrexagram?.title ?? ""
        wrexagramTitle.readjustLabelFontSize()
    }
    
    fileprivate func loadImage() {
        WrexagramLibrary.loadWrexagram(wrexagramNumber, intoImageView: wrexegramImage, useThumbnail: false)
    }
    
    
}

//MARK: Table View Data Methods
extension WrexagramViewController {
    
    private var emptyCell: UITableViewCell { return UITableViewCell() }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //One for the Body, another for the What's Up
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if row == 0 {
            return createBodyCell(tableView, forIndexPath: indexPath)
        }
        else {
            return createWhatsUpCell(tableView, forIndexPath: indexPath)
        }
    }
    
    fileprivate func createBodyCell(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BodyCell", for: indexPath) as? BodyCell
        else { return emptyCell }
        
        let body = WrexagramLibrary.bodyForWrexagram(wrexagramNumber)
        cell.textView.text = body

        return cell
    }
    
    fileprivate func createWhatsUpCell(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WhatsUpCell", for: indexPath) as? WhatsUpCell
        else { return emptyCell }
        
        let whatsUpText = wrexagram?.whatsUp ?? ""
        cell.textView.text = whatsUpText

        return cell
    }
    
    
}

//MARK : Table View Delegate Methods
extension WrexagramViewController {
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension

    }
}


//MARK: Utility Methods
extension WrexagramViewController {
    
    fileprivate func toAttributedString(_ html: String) -> NSAttributedString? {
        
        guard let data = html.data(using: String.Encoding.unicode) else { return nil }
        
        let options: [String : String] = [
            NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType
        ]
        
        guard let string = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
        else { return nil }
        
        if let font = UIFont.init(name: "Exo-Bold", size: 24) {
            
            string.addAttribute(NSFontAttributeName, value: font, range: NSRangeFromString(string.string))
            print("Font Loaded")
            
        }
        
        return string
    }
    
    fileprivate func determineWrexagramFromNumber(_ number: Int) -> Wrexagram? {
        
        let index = number - 1
        guard index < WrexagramLibrary.wrexagrams.count else { return nil }
        
        return WrexagramLibrary.wrexagrams[index]
    }
}

//MARK: Cells
class BodyCell : UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
}

class WhatsUpCell : UITableViewCell {
    
    @IBOutlet weak var whatsUpLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
}
