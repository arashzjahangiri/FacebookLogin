//
//  ConversationDetailsRequest.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 03/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct ConversationDetailsRequest: Mappable {
  
  var messageList: [Message]?
  var users: [User]?
  var listing: Listing?
  var conversationId: Int?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    messageList <- map["messages"]
    users <- map["users"]
    listing <- map["ad"]
    conversationId <- map["conversation_id"]
  }
}
