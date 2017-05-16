//
//  Message.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 20/07/16.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct Message: Mappable {
  var date: String?
  var message: String?
  var userId: Int?
  var conversationId: Int?
  
  init(map: [String:Any]) {
    date = map["date"] as? String
    if map["message"] is String {
      message = map["message"] as? String
    } else {
      message = String(map["message"] as! Int)
    }
    userId = map["user_id"] as? Int
  }
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    date     <- map["date"]
    message  <- map["message"]
    userId	 <- map["user_id"]
    conversationId <- map["conversation_id"]
  }
}
