//
//  Notification.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 07/07/16.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct Notification: Mappable {
  var id: Int?
  var type: Int?
  var message: String?
  var user: User?
  var listing: Listing?
  var dateAdded: String?
  var clicked: Int?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    type <- map["type"]
    message <- map["message"]
    user <- map["user"]
    listing <- map["ad"]
    dateAdded <- map["date_added"]
    clicked <- map["clicked"]
  }
  
  init(map: [String:Any]) {
    type = map["type"] as? Int
    message = map["message"] as? String
    user = (map["user"] as? [String: AnyObject]) != nil ? User(map: map["user"] as! [String:AnyObject]) : nil
    listing = (map["ad"] as? [String: AnyObject]) != nil ? Listing(map: map["ad"] as! [String:AnyObject]) : nil
    dateAdded = map["date_added"] as? String
  }
}
