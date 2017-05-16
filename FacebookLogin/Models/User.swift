//
//  User.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 1/05/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct User: Mappable {
  
  var id: Double?
  var name: String?
  var photo: String = ""
  var location: Location?
  var email: String?
  var appNotifications: Bool = true
  var userNotifications: Bool = true
  var listingNumbers: [String:Int] = ["selling": 0, "sold": 0]
  var follow: [String: Int] = ["followers": 0, "following": 0]
  var blockedMe: [Int] = []
  var identity: String?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    photo <- map["photo"]
    location <- map["location_data"]
    email <- map["email"]
    appNotifications <- map["app_notifications"]
    userNotifications <- map["user_notifications"]
    listingNumbers <- map["ads"]
    follow <- map["follow"]
    blockedMe <- map["blocked"]
    identity <- map["identity"]
    
    if photo.characters.count == 0 {
      photo = Api.sharedInstance.getApiUrl() + "img/user_ph_ios.png"
    }
    
  }
  
  init(map: [String: AnyObject]) {
    id = map["id"] as? Double ?? Double(map["id"] as! String)!
    name = map["name"] as? String
    photo = map["photo"] as! String
    if photo.characters.count == 0 {
      photo = Api.sharedInstance.getApiUrl() + "img/user_ph_ios.png"
    }
    if (map["location_data"] as? [String: AnyObject]) != nil {
      location = Location(map: map["location_data"] as! [String: AnyObject])
    } else if (map["location_data"] as? Location) != nil {
      location = map["location_data"] as? Location
    }
    if (map["email"] as? String) != nil {
      email = map["email"] as? String
    }
    if (map["app_notifications"] as? Int) != nil &&
      (map["app_notifications"] as? Int) == 1{
      appNotifications = true
    } else {
      appNotifications = false
    }
    if (map["user_notifications"] as? Int) != nil &&
      (map["user_notifications"] as? Int) == 1 {
      userNotifications = true
    } else {
      userNotifications = false
    }
    if (map["ads"] as? [String:AnyObject]) != nil {
      listingNumbers["selling"] = map["ads"]!["selling"] as? Int
      listingNumbers["sold"] = map["ads"]!["sold"] as? Int
    }
    if (map["follow"] as? [String:AnyObject]) != nil {
      follow["following"] = map["follow"]!["following"] as? Int
      follow["followers"] = map["follow"]!["followers"] as? Int
    }
  }
  
}
