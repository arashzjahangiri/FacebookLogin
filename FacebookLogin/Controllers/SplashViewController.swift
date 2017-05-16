//
//  SplashViewController.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 5/1/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import UIKit
class SplashViewController: BaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.pushToNextView()
        }

    }
    func pushToNextView(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let view = mainStoryboard.instantiateViewController(withIdentifier:"ViewController") as! ViewController
        self.navigationController?.pushViewController(view, animated: true)
        //self.present(view, animated: true, completion: nil)
    }
    
    func setRTL() {
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SplashViewController") {
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
    
    func setLTR() {
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SplashViewController") {
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }

}
