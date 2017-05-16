//
//  UIImageView.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 02/09/16.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import UIKit
import Nuke

extension UIImageView{
  func blurImage()
  {
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.bounds
    
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
    
    self.addSubview(blurEffectView)
  }
  
  func nukeImage(withUrl url: String?) {
    if url != nil {
      Nuke.loadImage(with: URL(string: url!)!, into: self)
    }
  }
}
