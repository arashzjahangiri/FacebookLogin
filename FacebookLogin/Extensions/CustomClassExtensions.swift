//
//  CustomClassExtensions.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 14/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import UIKit

class UITapGestureRecognizerWithUserData: UITapGestureRecognizer{
  var userData: User? = nil
}

class UIButtonWithListing: UIButton {
  var listing: Listing?
}

class CopyLabel: UILabel {
  
  override public var canBecomeFirstResponder: Bool {
    get {
      return true
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    sharedInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInit()
  }
  
  func sharedInit() {
    isUserInteractionEnabled = true
    addGestureRecognizer(UILongPressGestureRecognizer(
      target: self,
      action: #selector(showMenu(sender:))
    ))
  }
  
  override func copy(_ sender: Any?) {
    UIPasteboard.general.string = text
    UIMenuController.shared.setMenuVisible(false, animated: true)
  }
  
  func showMenu(sender: Any?) {
    becomeFirstResponder()
    let menu = UIMenuController.shared
    if !menu.isMenuVisible {
      menu.setTargetRect(bounds, in: self)
      menu.setMenuVisible(true, animated: true)
    }
  }
  
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if action == #selector(copy(_:)) {
      return true
    }
    
    return false
  }
}
  
