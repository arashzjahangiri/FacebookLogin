//
//  UITextField.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 10/05/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField:UITextField{
    var change: Bool = false {
        didSet {
            textColor = change ? .black : .blue
            backgroundColor = change ? .yellow : .red
        }
    }
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
            
            //Border
            self.layer.cornerRadius = 15.0;
            self.layer.borderWidth = 1.5
            self.layer.borderColor = UIColor.white.cgColor
            
            //Background
            self.backgroundColor = UIColor(white: 1, alpha: 0.0)
            
            //Text
            self.textColor = UIColor.white
            self.textAlignment = NSTextAlignment.center
        }
}
