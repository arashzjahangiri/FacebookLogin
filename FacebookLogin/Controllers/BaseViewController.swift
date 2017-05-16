//
//  File.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 5/1/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import UIKit
import SnapKit
class BaseViewController:UIViewController{
    let titleLabel = UILabel()
    func setTitle(titleStr:String) {
        self.navigationItem.title = titleStr;
        
        //self.setupConstraints()
    }
    
    func  setupConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.topMargin.equalTo(20)
            make.width.greaterThanOrEqualTo(20)
            make.height.equalTo(25)
            make.centerX.equalTo(self.view.snp.centerX)
        }
    }
}
