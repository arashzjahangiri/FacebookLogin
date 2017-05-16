//
//  PublicMessage.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 10/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct PublicMessage: Mappable {
  var id: Int?
  var date: String?
  var message: String?
  var user: User?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    id       <- map["id"]
    date     <- map["date"]
    message  <- map["message"]
    user	 <- map["user"]
  }
}

