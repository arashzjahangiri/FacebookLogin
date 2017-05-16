//
//  CategoryCollectionViewManager.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 08/12/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import UIKit

class CategoryCollectionViewManager: NSObject{
  
  var categories: [Category]? {
    return Common.sharedInstance.getCategories()
  }
  
}
