//
//  LoginViewController.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 11/05/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController:BaseViewControllerSignup, UITextFieldDelegate{
    var backButton:UIButton!
    var topLabel:UILabel!
    var descriptionLabel:UILabel!
    var phoneLabel:UILabel!
    var horizontalLine1:UIView!
    var horizontalLine2:UIView!
    var flagImageView:UIImageView!
    var countryCodeLabel:UILabel!
    var mobileTextField:UITextField!
    var tikImageView:UIImageView!
    var nextButton:UIButton!
    
    override func viewDidLoad() {
        self.makebgImage()
        self.makeTransparentView()
        self.setupConstraints()
        self.makeUIElements()
    }
    
    //MARK: custom methods
    override func setupConstraints() {
//        self.bgImageView.snp.makeConstraints { (make) in
//            make.topMargin.equalTo(0)
//            make.width.equalTo(self.view.snp.width)
//            make.height.equalTo(self.view.snp.height)
//        }
    }
    
    func makeUIElements(){
        backButton = RoundRectButton(frame: CGRect(x: 15, y: 30, width: 30, height: 30))
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        topLabel = UILabel(frame: CGRect(x: 20, y: 80, width: Constants.screenWidth - 40, height: 50))
        topLabel.text = "Login To Your Account".localiz();
        topLabel.textColor = UIColor.white
        topLabel.font = UIFont(name: "", size: 19)
        self.view.addSubview(topLabel)
        
        descriptionLabel = UILabel(frame: CGRect(x: 20, y: 140, width: Constants.screenWidth - 40, height: 50))
        descriptionLabel.numberOfLines = 2
        descriptionLabel.text = "Please enter the phone Number you first used to register.We will text to verify your phone".localiz();
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.font = UIFont(name: "", size: 7)
        self.view.addSubview(descriptionLabel)
        
        phoneLabel = UILabel(frame: CGRect(x: 20, y: 260, width: Constants.screenWidth - 40, height: 50))
        phoneLabel.text = "PHONE NUMBER".localiz();
        phoneLabel.textColor = UIColor.white
        phoneLabel.font = UIFont(name: "", size: 15)
        self.view.addSubview(phoneLabel)
        
        flagImageView = UIImageView(frame: CGRect(x: 25, y: 320, width: 25, height: 17))
        flagImageView.image = UIImage(named: "flag")
        self.view.addSubview(flagImageView)
        
        countryCodeLabel = UILabel(frame: CGRect(x: 105, y: 320, width: 40, height: 25))
        countryCodeLabel.text = "+44"
        countryCodeLabel.textColor = UIColor.white
        countryCodeLabel.font = UIFont(name: "", size: 15)
        self.view.addSubview(countryCodeLabel)
        
        mobileTextField = UITextField(frame: CGRect(x: 145, y: 320, width: 80, height: 25))
        mobileTextField.delegate = self
        mobileTextField.textColor = UIColor.white
        mobileTextField.keyboardType = .numberPad
        self.view.addSubview(mobileTextField)
        
        tikImageView = UIImageView(frame: CGRect(x: Constants.screenWidth - 170, y: 320, width: 15, height: 15))
        tikImageView.image = UIImage(named: "tik1")
        self.view.addSubview(tikImageView)
        tikImageView.isHidden = true
        
        horizontalLine1 = UIView(frame: CGRect(x: 20, y: 345, width: 70, height: 1))
        horizontalLine1.backgroundColor = UIColor.white
        self.view.addSubview(horizontalLine1)
        
        horizontalLine2 = UIView(frame: CGRect(x: 100, y: 345, width: Constants.screenWidth - 120, height: 1))
        horizontalLine2.backgroundColor = UIColor.white
        self.view.addSubview(horizontalLine2)

        mobileTextField.becomeFirstResponder()
    }
    
    func backButtonAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
}
