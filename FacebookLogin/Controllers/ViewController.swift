//
//  ViewController.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 5/1/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    let button = UIButton()
    var heartPopup : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.theme1
        self.setTitle(titleStr:"Test language".localiz())
        let notifName = NSNotification.Name(rawValue: "backToSplash")
        NotificationCenter.default.addObserver(self, selector: #selector(back), name: notifName, object: nil)
        
        button .setTitle("push me!".localiz(), for: .normal)
        button.backgroundColor = .red
        self.view.addSubview(button)
        
        self.navigationController!.navigationBar.topItem!.title = "Back".localiz()
        
        self.heartPopup = UIImageView()
        self.heartPopup.image = UIImage(named: "heart")
        self.heartPopup.alpha = 0.0
        self.view.addSubview(self.heartPopup)
        
        self.setupConstraints()
        self.likeAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func setupConstraints() {
        button.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(150)
        }
        
        heartPopup.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(self.view.snp.width)
            make.centerY.equalTo(self.view.snp.centerY)
            make.centerX.equalTo(self.view.snp.centerX)
        }
    }
    @IBAction func changeLanguage(_ sender: UIButton) {
    /*
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let view = mainStoryboard.instantiateViewController(withIdentifier:"SettingsViewController") as! SettingsViewController
        //self.present(view, animated: true, completion: nil)
        self.navigationController?.pushViewController(view, animated: true)
        */
    }
    
    func back() {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setRTL() {
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "SplashViewController") {
//            UIApplication.shared.keyWindow?.rootViewController = vc
//        }
    }
    
    func setLTR() {
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
        //        if let vc = storyboard?.instantiateViewController(withIdentifier: "SplashViewController") {
//            UIApplication.shared.keyWindow?.rootViewController = vc
//        }
    }
    
    override func viewDidLayoutSubviews() {
        let lang = LanguageManger.shared.currentLang
        if lang == "fa"{
            self.setRTL()
        }else{
            self.setLTR()
        }

    }
    
    func likeAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
            self.heartPopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.heartPopup.alpha = 1.0
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
                self.heartPopup.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: {(_ finished: Bool) -> Void in
                UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
                    self.heartPopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    self.heartPopup.alpha = 0.0
                }, completion: {(_ finished: Bool) -> Void in
                    self.heartPopup.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            })
        })
    }

}

