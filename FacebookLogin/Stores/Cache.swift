//
//  Cache.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 25/05/16.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct Cache {
  private static var versionPrefix: String { return Common.sharedInstance.versionPrefix }
  
  static var categories: [Category]? {
    get {
      if let categoryJsonString = UserDefaults.standard.string(forKey: versionPrefix + "categories") {
        if let categories = Mapper<Category>().mapArray(JSONString: categoryJsonString) {
          return categories
        }
      }
      return nil
    }
    set {
      if let categoryJsonString = newValue?.toJSONString() {
        UserDefaults.standard.set(categoryJsonString, forKey: versionPrefix + "categories")
        UserDefaults.standard.synchronize()
      }
    }
  }
  
  static var currentUser: User? {
    get {
      if let userJsonString = UserDefaults.standard.string(forKey: versionPrefix + "currentUser") {
        if let user = Mapper<User>().map(JSONString: userJsonString) {
          return user
        }
      }
      return nil
    }
    set {
      if let userJsonString = newValue?.toJSONString() {
        UserDefaults.standard.set(userJsonString, forKey: versionPrefix + "currentUser")
        UserDefaults.standard.synchronize()
      }
    }
  }
}
