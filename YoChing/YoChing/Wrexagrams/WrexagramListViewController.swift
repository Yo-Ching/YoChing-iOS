//
//  WrexagramListViewController.swift
//  YoChing
//
//  Created by SirWellington on 4/7/16.
//  Copyright © 2016 Gary.com. All rights reserved.
//

import Foundation
import UIKit

class WrexagramListViewController : UITableViewController {

    lazy var wrexagrams = WrexagramLibrary.wrexagrams
    
    private let main = NSOperationQueue.mainQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setSprayForWhiteBackground()
    }
}

//MARK: Segues
extension WrexagramListViewController {
    
    private func goToWrexagram(number: Int) {
        self.performSegueWithIdentifier("ToPager", sender: number)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destination = segue.destinationViewController
        
        if let viewController = destination as? WrexagramViewController, let number = sender as? Int {
            viewController.wrexagramNumber = number + 1
            let wrexagram = wrexagrams[number]
            viewController.wrexagram = wrexagram
        }
        
        if let viewController = destination as? WrexagramPagerViewController, let number = sender as? Int {
            viewController.initialIndex = number
            viewController.wrexagrams = self.wrexagrams
        }
    }
}


//MARK: Table View Data Methods
extension WrexagramListViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = wrexagrams.count
        print("There are \(count) Wrexagrams")
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("Wrexagram", forIndexPath: indexPath) as? WrexagramListCell else {
            return UITableViewCell()
        }
        
        let row = indexPath.row
        
        guard row < wrexagrams.count else { return cell }
        
        let wrexagram = wrexagrams[row]
        
        let number = wrexagram.number ?? row + 1
        
        cell.numberLabel.text = "\(number)"
        cell.title.text = wrexagram.title
        cell.subtitle?.text = wrexagram.subtitle
        cell.wrexagramImage?.image = nil
        
        WrexagramLibrary.loadWrexagram(number: number, intoImageView: cell.wrexagramImage, useHaneke: true)
        
        randomizeSpray(forCell: cell)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    private func randomizeSpray(forCell cell: WrexagramListCell) {
        
        let factor = Int.random(from: 1, to: 6)
        
        switch factor {
            case 1 : cell.sprayBackground.contentMode = .ScaleAspectFit
            case 2 : cell.sprayBackground.contentMode = .Top
            case 3: cell.sprayBackground.contentMode = .Bottom
            case 4 : cell.sprayBackground.contentMode = .TopRight
            default : cell.sprayBackground.contentMode = .ScaleToFill
        }
    }

}

//MARK: Table View Delegate Methods
extension WrexagramListViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = indexPath.row
        
        guard row < wrexagrams.count else { return }
        
        self.goToWrexagram(row)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = cell.contentView.backgroundColor
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? WrexagramListCell else { return }
        cell.imageView?.image = nil
    }
}

class WrexagramListCell : UITableViewCell {
    
    @IBOutlet weak var sprayBackground: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var wrexagramImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    
}
