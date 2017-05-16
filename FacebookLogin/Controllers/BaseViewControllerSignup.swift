//
//  File.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 5/1/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import UIKit
import SnapKit
class BaseViewControllerSignup:UIViewController{
    
    let titleLabel = UILabel()
    var bgImageView = UIImageView()
    var transparentView = UIView()
    
    func makebgImage() {
        bgImageView.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: Constants.screenHeight)
        bgImageView.image = UIImage(named: "introBG")
        self.bgImageView.contentMode = .scaleAspectFill
        self.view.addSubview(bgImageView)
        self.setupConstraints()
    }
    
    func makeTransparentView() {
        transparentView.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: Constants.screenHeight)
        transparentView.backgroundColor = Colors.theme1
        transparentView.alpha = 0.9
        self.view.addSubview(transparentView)
        self.setupConstraints()
    }
    func setTitle(titleStr:String) {
        self.navigationItem.title = titleStr;
        
    }
    
    func  setupConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.topMargin.equalTo(20)
            make.width.greaterThanOrEqualTo(20)
            make.height.equalTo(25)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        self.bgImageView.snp.makeConstraints { (make) in
            make.topMargin.equalTo(0)
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(self.view.snp.height)
        }
        
        self.transparentView.snp.makeConstraints { (make) in
            make.topMargin.equalTo(0)
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(self.view.snp.height)
        }

    }
    
    override func viewDidLayoutSubviews() {
        self.bgImageView.contentMode = .scaleAspectFill
    }

}
