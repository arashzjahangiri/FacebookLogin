//
//  PublicChatRequest.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 12/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct PublicChatRequest: Mappable {
  
  var messages: [PublicMessage]?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    messages <- map["comments"]
  }
}
