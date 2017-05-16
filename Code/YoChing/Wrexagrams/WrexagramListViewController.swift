//
//  WrexagramListViewController.swift
//  YoChing
//
//  Created by SirWellington on 4/7/16.
//  Copyright © 2016 Yo Ching. All rights reserved.
//

import AromaSwiftClient
import Foundation
import UIKit

class WrexagramListViewController : UITableViewController {

    lazy var wrexagrams = WrexagramLibrary.wrexagrams
    
    fileprivate let main = OperationQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AromaClient.sendLowPriorityMessage(withTitle: "Opened Wrexagram List")
    }
}

//MARK: Segues
extension WrexagramListViewController {
    
    fileprivate func goToWrexagram(_ number: Int) {
        self.performSegue(withIdentifier: "ToPager", sender: number)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination
        
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = wrexagrams.count
        print("There are \(count) Wrexagrams")
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Wrexagram", for: indexPath) as? WrexagramListCell else {
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
        
        WrexagramLibrary.loadWrexagram(number, intoImageView: cell.wrexagramImage, useThumbnail: true)
        
        randomizeSpray(forCell: cell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    fileprivate func randomizeSpray(forCell cell: WrexagramListCell) {
        
        let factor = Int.random(from: 1, to: 6)
        
        switch factor {
            case 1 : cell.sprayBackground.contentMode = .scaleAspectFit
            case 2 : cell.sprayBackground.contentMode = .top
            case 3: cell.sprayBackground.contentMode = .bottom
            case 4 : cell.sprayBackground.contentMode = .topRight
            default : cell.sprayBackground.contentMode = .scaleToFill
        }
    }

}

//MARK: Table View Delegate Methods
extension WrexagramListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        guard row < wrexagrams.count else { return }
        
        self.goToWrexagram(row)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = cell.contentView.backgroundColor
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
