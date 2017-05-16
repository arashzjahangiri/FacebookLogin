//
//  Listing.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 1/05/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct Listing: Mappable {
  
  var id: Int?
  var description: String?
  var categoryId: Int?
  var location: Location?
  var price: String?
  var priceInt: Int?
  var media: String?
  private var imageUrlTemplate: String?
  var pictures: ListingPictures?
  var date: String?
  var user: User?
  var url: String?
  var type: Status = .live
  var distance: String?
  var offers: Int?
  
  enum Status: Int {
    case sold = 1
    case archive
    case pending
    case live
  }
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    description <- map["description"]
    categoryId <- map["category_id"]
    location <- map["location_data"]
    price <- map["currency_price"]
    priceInt <- map["price"]
    media <- map["media"]
    imageUrlTemplate <- map["template_image"]
    if media != nil && imageUrlTemplate != nil {
      pictures = ListingPictures(urlTemplate: imageUrlTemplate!, media: media!)
    }
    date <- map["approved_at"]
    user <- map["user"]
    url <- map["url"]
    type <- map["ad_type"]
    distance <- map["distance"]
    offers <- map["offers"]
  }
  
  init(map: [String: Any]) {
    id = map["id"] as? Int
    if map["description"] is String {
      description = map["description"] as? String
    } else {
      description = String(describing: map["description"]!)
    }
    categoryId = map["category_id"] as? Int
    
    location = Location(map: map["location_data"] as! [String: Any])
    price = map["currency_price"] as? String
    if (map["media"] as? String) != nil {
      pictures = ListingPictures(urlTemplate: map["template_image"] as! String, media: map["media"] as! String)
    } else {
      pictures = ListingPictures(urlTemplate: map["template_image"] as! String, media: String(map["media"] as! Int))
    }
    date = map["approved_at"] as? String
    user = User(map: map["user"] as! [String: AnyObject])
    url = map["url"] as? String
    if (map["ad_type"] as? Int) != nil {
      switch map["ad_type"] as! Int {
      case 1: type = .sold
      case 2: type = .archive
      case 3: type = .pending
      default: type = .live
      }
    }
    offers = map["offers"] as? Int
  }
}
