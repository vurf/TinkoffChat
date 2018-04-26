//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by rangemotions on 2/25/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let rootAssembly = RootAssembly()
    
    var window: UIWindow?
    let activeState = "active"
    let inactiveState = "inactive"
    let notRunningState = "not running"
    let backgroundState = "background"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.log(previous: notRunningState, current: inactiveState, function: #function)
        
        AppDelegate.rootAssembly.presentationAssembly.communicationFacade.start()
        AppDelegate.rootAssembly.presentationAssembly.themeFacade.retriveAndApplyTheme();
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        self.log(previous: activeState, current: inactiveState, function: #function)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.log(previous: inactiveState, current: backgroundState, function: #function)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        self.log(previous: backgroundState, current: inactiveState, function: #function)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.log(previous: inactiveState, current: activeState, function: #function)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.log(previous: backgroundState, current: notRunningState, function: #function)
    }
    
    func log(previous: String, current: String, function: String){
        print("\n\nApplication moved from \(previous) to \(current) : \(function)")
    }
}

