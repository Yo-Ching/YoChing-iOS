//
//  AppDelegate.swift
//  YoChing
//
//  Created by SirWellington on 10/01/15.
//  Copyright © 2015 Yo Ching. All rights reserved.
//

import Archeota
import AromaSwiftClient
import Kingfisher
import UIKit


let app = UIApplication.shared

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
	var window: UIWindow?

    fileprivate static let buildNumber: String = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? ""

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
        
        LOG.enable()
        
        AromaClient.TOKEN_ID = "3e7ee9ec-9e9e-479e-a44a-24c7376d2786"
        AromaClient.maxConcurrency = 2
        AromaClient.deviceName = UIDevice.current.name
        
        AromaClient.beginMessage(withTitle: "App Launched")
            .withPriority(.low)
            .addBody("Build #\(AppDelegate.buildNumber)")
            .send()
        
        NSSetUncaughtExceptionHandler() { ex in
            
          
            AromaClient.beginMessage(withTitle: "App Crashed")
                .addBody("Device \(UIDevice.current.name)").addLine()
                .addBody("Build #\(AppDelegate.buildNumber)").addLine(2)
                .addBody("\(ex)")
                .withPriority(.high)
                .send()
 
        }
        
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		
	}

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        
        AromaClient.beginMessage(withTitle: "Memory Warning")
            .addBody("Received memory warning. Clearing Image Cache.")
            .withPriority(.medium)
            .send()
    }
}
