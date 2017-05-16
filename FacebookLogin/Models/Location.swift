//
//  Location.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 06/06/16.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct Location: Mappable {
  
  var name: String?
  var latitude: Double?
  var longitude: Double?
  
  init(map: [String: Any]) {
    name = map["name"] as? String
    latitude = map["latitude"] as? Double ?? Double(map["latitude"] as! String)!
    longitude = map["longitude"] as? Double ?? Double(map["longitude"] as! String)!
  }
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    name     <- map["name"]
    latitude  <- map["latitude"]
    longitude  <- map["longitude"]
  }
}
