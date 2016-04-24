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
            self.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        if let wrexagram = self.wrexagram ?? determineWrexagramFromNumber(wrexagramNumber) {
            
            defer { self.wrexagram = wrexagram }
            
            AromaClient.beginWithTitle("Wrexagram Viewed")
                .addBody("\(wrexagram.asString)")
                .addLine().addLine()
                .addBody("By \(UIDevice.currentDevice().name)")
                .withPriority(.LOW)
                .send()
        }
        else {
            AromaClient.beginWithTitle("Wrexagram Viewed")
                .addBody("Wrexagram \(wrexagramNumber)")
                .addLine().addLine()
                .addBody("By \(UIDevice.currentDevice().name)")
                .withPriority(.LOW)
                .send()
        }
        
        setNavTitle()
        loadImage()
        delay(0.1) { self.loadTitle() }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//       loadTitle()

    }
    
    private func setNavTitle() {
        
        navTitle.text = "WREXAGRAM \(wrexagramNumber)"
    }
    
    private func loadTitle()
    {
        wrexagramTitle.adjustsFontSizeToFitWidth = true
        wrexagramTitle.morphingEffect = .Anvil
        wrexagramTitle.text = wrexagram?.title ?? ""
        wrexagramTitle.readjustLabelFontSize()
    }
    
    private func loadImage() {
        WrexagramLibrary.loadWrexagram(number: wrexagramNumber, intoImageView: wrexegramImage, useHaneke: false)
    }
    
    
}

//MARK: Table View Data Methods
extension WrexagramViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //One for the Body, another for the What's Up
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if row == 0 {
            return createBodyCell(tableView, forIndexPath: indexPath)
        }
        else {
            return createWhatsUpCell(tableView, forIndexPath: indexPath)
        }
    }
    
    private func createBodyCell(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("BodyCell", forIndexPath: indexPath) as? BodyCell
        else {
              return UITableViewCell()
        }
        
        let body = WrexagramLibrary.bodyForWrexagram(wrexagramNumber)
        cell.textView.text = body

        return cell
    }
    
    private func createWhatsUpCell(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("WhatsUpCell", forIndexPath: indexPath) as? WhatsUpCell
        else {
            return UITableViewCell()
        }
        
        let whatsUpText = wrexagram?.whatsUp ?? ""
        cell.textView.text = whatsUpText

        return cell
    }
    
    
}

//MARK : Table View Delegate Methods
extension WrexagramViewController {
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension

    }
}


//MARK: Utility Methods
extension WrexagramViewController {
    
    private func toAttributedString(html: String) -> NSAttributedString? {
        
        guard let data = html.dataUsingEncoding(NSUnicodeStringEncoding) else { return nil }
        
        let options: [String : String] = [
            NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType
        ]
        
        guard let string = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) else { return nil }
        
        if let font = UIFont.init(name: "Exo-Bold", size: 24) {
            string.addAttribute(NSFontAttributeName, value: font, range: NSRangeFromString(string.string))
            print("Font Loaded")
            
        }
        
        return string
    }
    
    private func determineWrexagramFromNumber(number: Int) -> Wrexagram? {
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