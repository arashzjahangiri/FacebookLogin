//
//  MainUITabBarController.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 30/05/16.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import UIKit

class MainUITabBarController: UITabBarController, UITabBarControllerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    // Do any additional setup after loading the view.
  }
  
  var pushedHome: Bool = false
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
    func home() -> HomeViewController {
       let view = HomeViewController.instantiateFromStoryboard(storyboardName: "Main")
        return view;
    }
    
    func category() -> CategorySelectionViewController {
        let view = CategorySelectionViewController.instantiateFromStoryboard(storyboardName: "Main")
        return view;
    }
    
    func addAds() -> AddAdsViewController {
        let view = AddAdsViewController.instantiateFromStoryboard(storyboardName: "Main")
        return view;
    }
    
    func hotoffer() -> HotOfferViewController {
        let view = HotOfferViewController.instantiateFromStoryboard(storyboardName: "Main")
        return view;
    }
    
    func me() -> MeViewController {
        let view = MeViewController.instantiateFromStoryboard(storyboardName: "Main")
        return view;
    }
}
