//
//  AppDelegate.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 24/05/16.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window:                                 UIWindow?
    var tabBarController =                      UITabBarController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Fabric.with([Crashlytics.self])
        //setFabricUserData()

        // functions that need calling when the app starts
        if Common.sharedInstance.getCurrentUser() != nil {
            Common.sharedInstance.updateUserDataFromApi()
            Common.sharedInstance.getFavoriteAds(fromApi: true) { ids in }
            Common.sharedInstance.getFollowing(fromApi: true) {ids in }
            Common.sharedInstance.tabbarMaker()
        }else{
            let view = Common.sharedInstance.signup()
            let navigationController = UINavigationController(rootViewController: view)
            self.window?.rootViewController = nil
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
            navigationController.isNavigationBarHidden = true
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled  = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return handled
        
    }

    //MARK: custom methods
    
    func setFabricUserData() {
        if let user = Common.sharedInstance.getCurrentUser() {
            Crashlytics.sharedInstance().setUserEmail(user.email)
            Crashlytics.sharedInstance().setUserIdentifier(user.id?.description)
            Crashlytics.sharedInstance().setUserName(user.name)
        }
    }
}

