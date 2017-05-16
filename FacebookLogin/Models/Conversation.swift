//
//  Conversation.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 20/07/16.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct Conversation: Mappable {
  var id: Int?
  var read: Bool?
  var message: String?
  var date: String?
  var listing: Listing?
  var user: User?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    id			<- map["id"]
    read		<- map["read"]
    message		<- map["message"]
    date		<- map["date"]
    listing		<- map["ad"]
    user		<- map["user"]
  }
  
  init(map: [String:Any]) {
    id = map["id"] as? Int
    read = map["read"] as? Bool
    date = map["date"] as? String
    message = map["message"] as? String
    user = User(map: map["user"] as! [String: AnyObject])
    listing = (map["ad"]  as? [String: AnyObject]) != nil ? Listing(map: map["ad"]  as! [String: AnyObject]) : nil
  }
}
