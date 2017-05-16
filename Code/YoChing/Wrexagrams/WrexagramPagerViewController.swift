//
//  WrexagramPagerViewController.swift
//  YoChing
//
//  Created by SirWellington on 4/11/16.
//  Copyright © 2016 Yo Ching. All rights reserved.
//

import AromaSwiftClient
import Foundation
import Social
import UIKit

class WrexagramPagerViewController : UIPageViewController {
    
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var wrexagrams: [Wrexagram] = []
    var initialIndex: Int = 0
    
    fileprivate var currentWrexagram: Wrexagram?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let initiallViewController = self.viewControllerAtIndex(initialIndex) else { return }
        self.setViewControllers([initiallViewController], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
        self.delegate = self
        
        self.setNavTitle(toWrexagramNumber: initialIndex + 1)
        currentWrexagram = wrexagrams[initialIndex]
    }
    
    fileprivate func setNavTitle(toWrexagramNumber wrexagramNumber: Int) {
        self.navTitle?.text = "WREXAGRAM \(wrexagramNumber)"
    }
}

//MARK: Pager Data Source Methods
extension WrexagramPagerViewController : UIPageViewControllerDataSource {
    
    fileprivate func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "WrexagramViewController") as? WrexagramViewController
        else { return nil }
        
        guard index >= 0 && index < wrexagrams.count else {
            return nil
        }
        
        viewController.wrexagramNumber = index + 1
        viewController.wrexagram = wrexagrams[index]
        
        return viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let wrexagram = viewController as? WrexagramViewController else { return nil }
        
        let index = wrexagram.wrexagramNumber - 1
        
        return self.viewControllerAtIndex(index + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let wrexagram = viewController as? WrexagramViewController else { return nil }
        
        let index = wrexagram.wrexagramNumber - 1
        
        return self.viewControllerAtIndex(index - 1)
    }
}

//MARK: Pager Delegate Methods
extension WrexagramPagerViewController : UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        guard let first = pendingViewControllers.first as? WrexagramViewController else { return }
        
        let wrexagramNumber = first.wrexagramNumber
        self.setNavTitle(toWrexagramNumber: wrexagramNumber)
        
        let index = wrexagramNumber - 1
        guard index > 0 && index < wrexagrams.count else { return }
        self.currentWrexagram = wrexagrams[index]
    }
}

//MARK: Social Media Sharing
extension WrexagramPagerViewController {
    
    @IBAction func onShare(_ sender: AnyObject) {
        
        let wrexagram = self.currentWrexagram ?? wrexagrams[initialIndex]
        AromaClient.sendLowPriorityMessage(withTitle: "Share Button Hit", withBody: "\(wrexagram)")
        
        guard let controller = createShareController() else { return }
        
        if isiPhone {
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
        else if isiPad {
            // Change Rect to position Popover
            controller.modalPresentationStyle = .popover
            
            guard let popover = controller.popoverPresentationController else { return }
            popover.permittedArrowDirections = .any
            popover.barButtonItem = self.shareButton
            
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
            
        
    }
    
    fileprivate func createShareController() -> UIActivityViewController? {

        guard let wrexagram = currentWrexagram,
              let wrexagramNumber = wrexagram.number,
              let image = WrexagramLibrary.wrexPost(forWrexagram: wrexagramNumber)
        else { return nil }
        
        let strippedTitle = wrexagram.title.stringByRemovingWhitespace()
        let text = "#YoChing #\(strippedTitle)"

        
        // let's add a String and an NSURL
        let activityViewController = UIActivityViewController(
            activityItems: [text, image],
            applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            
            let activity =  activity ?? UIActivityType(rawValue: "")
            
            if success {
                
                AromaClient.beginMessage(withTitle: "Wrexagram Shared")
                    .withPriority(.high)
                    .addBody("Wrexagram \(wrexagramNumber)").addLine(2)
                    .addBody("\(wrexagram)").addLine(2)
                    .addBody("To Activity: ").addLine()
                    .addBody("\(activity)")
                    .send()
            }
            else if let error = error {
                
                AromaClient.beginMessage(withTitle: "Wrexagram Share Failed")
                    .withPriority(.high)
                    .addBody("Wrexagram \(wrexagramNumber)").addLine()
                    .addBody("\(wrexagram)").addLine(2)
                    .addBody("\(error)")
                    .send()
            }
            else {
                
                AromaClient.beginMessage(withTitle: "Wrexagram Share Canceled")
                    .withPriority(.low)
                    .addBody("Wrexagram \(wrexagramNumber)").addLine(2)
                    .addBody("\(String(describing: error))")
                    .send()
            }
        }
        
        return activityViewController
    }
    
}
