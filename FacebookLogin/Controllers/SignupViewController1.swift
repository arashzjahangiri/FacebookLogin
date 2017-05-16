//
//  LoginViewController1.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 5/9/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import Firebase

class SignupViewController1:BaseViewController, FBSDKLoginButtonDelegate{
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var fbTitle: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbImage: UIImageView!
    
    
    override func viewDidLoad() {
        self.setupConstraints()
        //self.callSignUP()
    }
    
    //MARK: custom methods
    override func setupConstraints() {
        self.bgImageView.snp.makeConstraints { (make) in
            make.topMargin.equalTo(0)
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(self.view.snp.height)
        }
        self.logo.snp.makeConstraints { (make) in
            make.topMargin.equalTo(24)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        self.desc.snp.makeConstraints { (make) in
            make.topMargin.equalTo(189)
            make.width.equalTo(284)
            make.height.equalTo(48)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        self.fbButton.snp.makeConstraints { (make) in
            make.bottomMargin.equalTo(-120)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(42)
        }
        
        self.fbTitle.snp.makeConstraints { (make) in
            make.topMargin.equalTo(self.fbButton.snp.top).offset(18)
            make.left.equalTo(self.fbButton.snp.left).offset(58)
            make.height.equalTo(18)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.70)
        }
        
        self.fbImage.snp.makeConstraints { (make) in
            make.topMargin.equalTo(self.fbButton.snp.top).offset(17)
            make.left.equalTo(self.fbButton.snp.left).offset(40)
            make.height.width.equalTo(20)
        }
        
        self.createButton.snp.makeConstraints { (make) in
            make.topMargin.equalTo(self.fbButton.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.height.equalTo(42)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.45)
        }
        
        self.skipButton.snp.makeConstraints { (make) in
            make.topMargin.equalTo(self.fbButton.snp.bottom).offset(15)
            make.left.equalTo(self.createButton.snp.rightMargin).offset(15)
            make.height.equalTo(42)
            make.right.equalTo(self.view.snp.right).offset(-20)
        }
        
        self.loginButton.snp.makeConstraints { (make) in
            make.bottomMargin.equalTo(-27)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(42)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.bgImageView.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: Constants.screenHeight)
        self.bgImageView.contentMode = .scaleAspectFill
        self.skipButton.cornerRadius = 0.0
        self.skipButton.borderColor = UIColor.white
        self.skipButton.borderWidth = 1.0
    }
    @IBAction func fbLogin(_ sender: Any) {
        print("FB")
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil {
                print("FB login failed: \(err)")
                return
            }
            self.showEmailAddress()
        }
    }
    
    @IBAction func createAction(_ sender: Any) {
        print("create")
    }
    @IBAction func skipAction(_ sender: Any) {
        print("skip")
    }
    @IBAction func loginAction(_ sender: Any) {
        let view = Common.sharedInstance.login()
        if let navigator = navigationController {
            _ = navigator.pushViewController(view, animated: true)
        }
        print("login")
    }
    // MARK: FB Delegate
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        showEmailAddress()
    }
    
    
    func showEmailAddress() {
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something is wrong with FB user: \(error)")
            }
            
            print("successfully logged in with our user: \(user)")
            
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "email, id, name"]).start { (connection, result, err) in
            
            if err != nil {
                print("failed to login: \(err)")
                return
            }
            
            print(result ?? "")
            
            Api.sharedInstance.createNewUser(result as? Dictionary, completionHandler: { (user) in
                Common.sharedInstance.tabbarMaker()
            })
        }
    }

    func callSignUP(){
        Api.sharedInstance.signUP("aa", email: "aaa@a.com", mobile: "09121234561", location: "Teh", preNationalCode: "+98") { (token) in
            print(token!)
        }
    }
}
