//
//  UIImage.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 02/09/16.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import UIKit

extension UIImage {
  func resizeSquareWithWidth(_ width: CGFloat) -> UIImage? {
    let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: width))) //CGFloat(ceil(width/size.width * size.height)))))
    imageView.contentMode = .scaleAspectFill
    imageView.image = self
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    imageView.layer.render(in: context)
    guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
    UIGraphicsEndImageContext()
    return result
  }
  public func rotated(byDegrees degrees: CGFloat) -> UIImage? {
    let degreesToRadians: (CGFloat) -> CGFloat = {
      return $0 / 180.0 * CGFloat(M_PI)
    }
    // calculate the size of the rotated view's containing box for our drawing space
    let rotatedViewContainer = UIView(frame: CGRect(origin: .zero, size: size))
    rotatedViewContainer.transform = CGAffineTransform(rotationAngle: degreesToRadians(degrees))
    let rotatedSize = rotatedViewContainer.frame.size
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize)
    if let bitmap = UIGraphicsGetCurrentContext() {
      
      // Move the origin to the middle of the image so we will rotate and scale around the center.
      bitmap.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
      
      // Rotate the image context
      bitmap.rotate(by: degreesToRadians(degrees))
      
      bitmap.scaleBy(x: 1.0, y: -1.0)
      bitmap.draw(self.cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
    }
    let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return rotatedImage
  }
}
