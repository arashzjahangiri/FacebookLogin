//
//  SettingsViewController.swift
//  LanguageManager
//
//  Created by abedalkareem omreyh on 4/9/17.
//  Copyright © 2017 abedalkareem. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func changeLanguage(_ sender: UIButton) {
        let selectedLanguage = sender.tag == 1 ? "en" : "fa"
        LanguageManger.shared.setLanguage(language: selectedLanguage)
        
        _ = self.navigationController?.popToRootViewController(animated: true)
//        UIApplication.topViewController!.dismiss(animated: true) {
//            UIApplication.topViewController!.dismiss(animated: true) {
                let delegate = UIApplication.shared.delegate as! AppDelegate
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
//                //let notifName = NSNotification.Name(rawValue: "backToSplash")
//                //NotificationCenter.default.post(name: notifName, object: nil)
//            }
//        }
    }
    

}
