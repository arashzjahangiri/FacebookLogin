//
//  ConversationsRequest.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 03/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct ConversationsRequest: Mappable {
  var conversations: [Conversation]?
  var ignore: [Int]?
  var messageDate: Int?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    conversations <- map["messages"]
    ignore <- map["ignore"]
    messageDate <- map["message_date"]
  }
}
