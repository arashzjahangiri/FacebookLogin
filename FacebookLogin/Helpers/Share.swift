//
//  Share.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 22/12/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import UIKit
import FBSDKShareKit

class Share {
  
  static let sharedInstance = Share()
  
  fileprivate enum Medium: String {
    case sms = "sms:&body="
    case telegram = "tg://msg?text="
    case whatsapp = "whatsapp://send?text="
    case twitter = "twitter://post?message="
    case facebook = ""
  }
  
  static func sms(url: String) {
    Share.sharedInstance.share(.sms, url: url)
  }
  
  static func telegram(url: String) {
    Share.sharedInstance.share(.telegram, url: url)
  }
  
  static func whatsapp(url: String) {
    Share.sharedInstance.share(.whatsapp, url: url)
  }
  
  static func twitter(url: String) {
    Share.sharedInstance.share(.twitter, url: url)
  }
  
  static func facebook(url: String, image: String?, controller: UIViewController) {
    let content = FBSDKShareLinkContent()
    content.contentURL = URL(string: url)
    FBSDKShareDialog.show(from: controller, with: content, delegate: nil)
  }
  
  fileprivate func share(_ medium: Medium, url: String) {
    let messageContent = medium.rawValue + String.localizedStringWithFormat(Localized.aText, url).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    if let url = URL(string: messageContent) {
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:]) { test in }
      } else {
        UIApplication.shared.openURL(url)
      }
    }
  }
}
