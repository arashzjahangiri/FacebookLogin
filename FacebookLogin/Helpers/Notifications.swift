//
//  Notifications.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 30/08/16.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

struct Notifications {
  
  static var sharedInstance = Notifications()
  
  var messageNotificationCount: Int? = nil
  var accountNotificationCount: Int? = nil
  var versionPrefix: String {
    get {
      return Common.sharedInstance.versionPrefix
    }
  }
  
  init() {
    let messageNotifications = UserDefaults.standard.integer(forKey: versionPrefix + "messageNotifications")
    messageNotificationCount = messageNotifications != 0 ? messageNotifications : nil
    
    let accountNotifications = UserDefaults.standard.integer(forKey: versionPrefix + "accountNotifications")
    accountNotificationCount = accountNotifications != 0 ? accountNotifications : nil
  }
  
  func update() {
    let tabBarController = UIApplication.shared.delegate!.window?!.rootViewController as! MainUITabBarController
    tabBarController.tabBar.items?[3].badgeValue = messageNotificationCount != nil ? String(messageNotificationCount!) : nil
    tabBarController.tabBar.items?[4].badgeValue = accountNotificationCount != nil ? String(accountNotificationCount!) : nil
  }
  
  mutating func updateFromApi(_ map: [String:Int]) {
    if let messageNotifications = map["message"] {
      messageNotificationCount = messageNotifications != 0 ? messageNotifications : nil
      UserDefaults.standard.set(messageNotifications, forKey: versionPrefix + "messageNotifications")
    }
    
    if let accountNotifications = map["account"] {
      accountNotificationCount = accountNotifications != 0 ? accountNotifications : nil
      UserDefaults.standard.set(accountNotifications, forKey: versionPrefix + "accountNotifications")
    }
    
    update()
  }
  
  func hasMessageNotifications() -> Bool {
    return messageNotificationCount != nil
  }
  
  func hasAccountNotifications() -> Bool {
    return accountNotificationCount != nil
  }
  
  func getMessageNotificationCount() -> Int {
    return hasMessageNotifications() ? messageNotificationCount! : 0
  }
  
  func getAccountNotificationCount() -> Int {
    return hasAccountNotifications() ? accountNotificationCount! : 0
  }
  
  mutating func parse(_ aps: [String:AnyObject]) {
    if Common.sharedInstance.debug {
      print(aps)
    }
    /*
    if UIApplication.shared.applicationState == .active {
      // send fancy notifications
      let root = UIApplication.shared.delegate!.window?!.rootViewController as! MainUITabBarController
      
      if let currentViewController = root.selectedViewController?.childViewControllers.last {
        if currentViewController.isKind(of: ConversationListViewController.self) {
          let controller = (currentViewController as! ConversationListViewController)
          controller.refreshData()
        } else {
          if let messageListViewController = root.viewControllers?[3].childViewControllers.first as? ConversationListViewController {
            if messageListViewController.viewIfLoaded != nil {
              messageListViewController.refreshData()
            }
          }
          if currentViewController.isKind(of: ConversationDetailsViewController.self) {
            (currentViewController as! ConversationDetailsViewController).loadConversation()
          }
        }
      }
    } else if (aps["type"] as? String) != nil {
      switch(aps["type"] as! String) {
      case "message":
        let tabBarController: MainUITabBarController = UIApplication.shared.delegate!.window?!.rootViewController as! MainUITabBarController
        
        tabBarController.selectedIndex = 3
        
        let conversationListViewController = tabBarController.selectedViewController?.childViewControllers.first! as! ConversationListViewController
        conversationListViewController.conversationId = aps["conversationId"] as? Int
        
        conversationListViewController.performSegue(withIdentifier: "Show Conversation Details Segue", sender: nil)
        
        break
      case "new_ad": fallthrough
      case "price": fallthrough
      case "comment":
        if aps["ad"] is [String:AnyObject] {
          let listingDetails = Listing(map: aps["ad"] as! [String : AnyObject])
          
          let tabBarController: MainUITabBarController = UIApplication.shared.delegate!.window?!.rootViewController as! MainUITabBarController
          
          tabBarController.selectedIndex = 0
          
          let homeViewController = tabBarController.selectedViewController?.childViewControllers.first! as! HomeViewController
          
          let storyboard:UIStoryboard = UIStoryboard(name: "Listings", bundle:nil)
          let nextViewController = storyboard.instantiateViewController(withIdentifier: "Listing Details View Controller") as! ListingDetailsViewController
          nextViewController.currentListing = listingDetails
          homeViewController.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
        break
      case "following":
        let tabBarController: MainUITabBarController = UIApplication.shared.delegate!.window?!.rootViewController as! MainUITabBarController
        
        tabBarController.selectedIndex = 4
        
        let meViewController = tabBarController.selectedViewController?.childViewControllers.first! as! MeViewController
        
        meViewController.performSegue(withIdentifier: "Followers List Segue", sender: nil)
      default:
        print("No notification type send!")
        break
      }
    }
    if let notifications = aps["notifications"] as? [String:Int] {
      updateFromApi(notifications)
    }
    if let appBadge = aps["badge"] as? Int {
      UIApplication.shared.applicationIconBadgeNumber = appBadge
    }
    */
  }
  
  
}



