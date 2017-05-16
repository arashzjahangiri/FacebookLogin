//
//  CategoryRequest.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 03/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct CategoryRequest: Mappable {
  var categories: [Category]?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    categories <- map["categories"]
  }
}
