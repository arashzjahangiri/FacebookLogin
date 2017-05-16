//
//  ListingPicture.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 03/06/16.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit
import Nuke

struct ListingPictures {
  
  fileprivate let urlTemplate: String
  fileprivate let media: String
  
  init(urlTemplate: String, media: String) {
    self.urlTemplate = urlTemplate
    self.media = media
  }
  
  func getFirstImageUrl(_ size: String = "m") -> String {
    let index = media.characters.split(separator: ",").map(String.init)[0]
    return getUrl(index, size: size)
  }
  
  func getAllImagesUrls(_ size: String = "m") -> [String] {
    if media.characters.contains(",") {
      var imageIndexes = media.characters.split(separator: ",").map(String.init)
      imageIndexes.removeLast()
      if imageIndexes.count > 0 {
        var allImagesUrls: [String] = []
        for index in imageIndexes {
          allImagesUrls.append(getUrl(index, size: size))
        }
        return allImagesUrls
      }
    }
    return []
  }
  
  func getUrl(_ index: String, size: String = "m") -> String {
    return urlTemplate.replacingOccurrences(of: "{thumb}", with: size)
      .replacingOccurrences(of: "{index}", with: index)
  }
  
  func preheat() {
    let preheater = Preheater()
    let requests = getAllImagesUrls().map {  Request(url: URL(string: $0 )!) }
    preheater.startPreheating(with: requests)
    
  }
  
  
  
  
}
