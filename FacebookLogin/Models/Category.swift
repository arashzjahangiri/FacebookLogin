//
//  Category.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 25/05/16.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct Category: Mappable {
  
  var id: Int?
  var name: String?
  
  init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    id			<- map["id"]
    name        <- map["name"]
  }
  
  init(map: [String: AnyObject]) {
    id = map["id"] as? Int
    name = map["name"] as? String
  }
  
}
