//
//  TemporaryListing.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 31/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

struct TemporaryListing {
  static var sharedInstance = TemporaryListing()
  var parameters = [String:Any]()
  var id: Int? {
    didSet {
      if let newId = id {
        parameters["id"] = newId
      }
    }
  }
  var description: String? {
    didSet {
      if let newDescription = description {
        parameters["description"] = newDescription
      } else {
        parameters.removeValue(forKey: "description")
      }
    }
  }
  var category: Category? {
    didSet {
      if let newCategory = category {
        parameters["category_id"] = newCategory.id
      } else {
        parameters.removeValue(forKey: "category_id")
      }
    }
  }
  var price: String? {
    didSet {
      if let newPrice = price {
        parameters["price"] = newPrice.replacingOccurrences(of: ",", with: ".")
      } else {
        parameters.removeValue(forKey: "price")
      }
    }
  }
  var currency: String = Localized.aText
  var photos = [UIImage]()
  var location: Location? {
    didSet {
      if let newLocation = location {
        parameters["location_lat"] = NSNumber(value: newLocation.latitude!).stringValue
        parameters["location_long"] = NSNumber(value: newLocation.longitude!).stringValue
        parameters["location"] = newLocation.name
        parameters.removeValue(forKey: "location_data")
      } else {
        parameters.removeValue(forKey: "location_lat")
        parameters.removeValue(forKey: "location_long")
        parameters.removeValue(forKey: "location")
      }
    }
  }
  var media: String? {
    didSet {
      if media?.characters.contains(",") == nil {
        photos = []
      } else {
        parameters["media"] = media
      }
    }
  }
  
  mutating func map(_ map: [String:Any], completionHandler: (() -> Void)? = nil ) {
    parameters = map
    id = map["id"] as? Int
    description = map["description"] as? String
    if let categoryId = map["category_id"] as? Int {
      category = Common.sharedInstance.getCategory(byId: categoryId)
    }
    if map["price"] is Int {
      price = String(map["price"] as! Int)
    } else {
      price = map["price"] as? String
    }
    media = map["media"] as? String
    if map["location_data"] is [String:Any] {
      location = Location(map: map["location_data"] as! [String:Any])
    }
    if let imageTemplate = map["template_image"] as? String,
      let currentMedia = media {
      let photoUrls = ListingPictures(urlTemplate: imageTemplate, media: currentMedia).getAllImagesUrls()
      Api.sharedInstance.getImages(forUrls: photoUrls) { images in
        TemporaryListing.sharedInstance.photos = images
        completionHandler?()
      }
    }
  }
  
  mutating func reset() {
    TemporaryListing.sharedInstance = TemporaryListing()
  }
  
  mutating func removeImage(withIndex index: Int) {
    if media != nil && media!.characters.count > 0 {
      var images = media?.components(separatedBy: ",")
      images?.remove(at: index)
      media = images?.joined(separator: ",")
    }
    photos.remove(at: index)
  }
  
  mutating func saveListing(_ update: Bool = false, _ completionHandler: @escaping (Bool?, Listing?) -> Void) {
    let removeKeys = ["template_image", "user", "approved_at", "currency_price", "offers", "url"]
    for key in removeKeys {
      parameters.removeValue(forKey: key)
    }
    if !update {
      location = Common.sharedInstance.getCurrentUser()?.location
      Api.sharedInstance.sendNewListing { ready in
        completionHandler(ready, nil)
      }
    } else {
      Api.sharedInstance.updateListing(completionHandler)
    }
  }
}
