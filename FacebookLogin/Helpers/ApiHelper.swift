//
//  ApiHelper.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 24/05/16.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit
import Nuke

class ApiHelper {
  
  static func generateQueryString(_ data: [String: Any]?) -> String {
    if data != nil {
      let sorted = data!.sorted { $0.key < $1.key }
      var parameters:[String] = [];
      for (key, value) in sorted {
        if value is [Int] {
          for number in value as! [Int] {
            parameters.append(key + "[]=" + String(describing: number))
          }
        } else {
          if !(value is Double) {
            parameters.append(key + "=" + String(describing: value))
          } else {
            parameters.append(key + "=" + NSNumber(value: value as! Double).stringValue)
          }
        }
      }
      return parameters.joined(separator: "&")
    }
    return ""
  }
  
  static func getImage(imageUrl: String, completionHandler: @escaping (UIImage) -> Void) {
    let cts = CancellationTokenSource()
    let url = URL(string: imageUrl)!
    Loader.shared.loadImage(with: url, token: cts.token)
      .then { image in completionHandler(image) }
      .catch { error in print("catched \(error)") }
  }
  
  static func getNewPhotos(media: String, photos: [UIImage]) -> [UIImage] {
    if media.characters.count > 0 {
      let mediaArray = media.components(separatedBy: ",")
      var newPhotos = [UIImage]()
      for (index, photo) in photos.enumerated() {
        if index >= (mediaArray.count - 1) {
          newPhotos.append(photo)
        }
      }
      return newPhotos
    }
    return photos
  }
}

