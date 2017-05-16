//
//  BlockedDataRequest.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 10/11/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct BlockedDataRequest: Mappable {
  
  var blocked: [User]?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    blocked <- map["users"]
  }
}
