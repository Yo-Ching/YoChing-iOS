//
//  AppDelegate.swift
//  YoChing
//
//  Created by SirWellington on 10/01/15.
//  Copyright © 2015 Yo Ching. All rights reserved.
//

import AromaSwiftClient
import UIKit


let app = UIApplication.shared

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
	var window: UIWindow?

    fileprivate static let buildNumber: String = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? ""

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
        
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
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}
