//
//  Common.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 5/9/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class Common {
    
    static var sharedInstance = Common()
    
    fileprivate init() {}
    
    fileprivate var categoryList = [Category]()
    
    fileprivate var user: User?
    
    fileprivate var identity: String?
    
    fileprivate var favoriteAds: [Int] = []
    
    fileprivate var followers: [Int] = []
    
    fileprivate var following: [Int] = []
    
    var categories = [Int: String]()
    
    var debug = false
    
    let versionPrefix = "v1"
    
    var hideLogin: Bool {
        return UserDefaults.standard.bool(forKey: versionPrefix + "hideLogin")
    }
    
    var GPSLocation: Location?
    
    var deviceToken: String? {
        return UserDefaults.standard.string(forKey: versionPrefix + "token")
    }
    
    func getIdentity() -> String? {
        if identity != nil {
            return identity
        } else {
            return UserDefaults.standard.string(forKey: versionPrefix + "identity")
        }
    }
    
    func setIdentity(_ identity: String) {
        self.identity = identity
        UserDefaults.standard.set(identity, forKey: versionPrefix + "identity")
    }
    
    func getCurrentUser() -> User? {
        if user != nil {
            return user!
        } else {
            if Cache.currentUser != nil {
                return Cache.currentUser
            }
        }
        return nil
    }
    
    func updateUserDataFromApi() {
        Api.sharedInstance.getCurrentUserData { user in
            if user != nil {
                self.setCurrentUser(user!)
            }
        }
    }
    
    func setCurrentUser(_ user: User) {
        Cache.currentUser = user
        self.user = user
        //    Cache.currentUser = user
    }
    
    func updateUserData(_ user: User, completionHandler: ((Void) -> Void)? = nil) {
        setCurrentUser(user)
        Api.sharedInstance.updateUserData(user) {
            if completionHandler != nil {
                completionHandler!()
            }
        }
    }
    
    func getCategory(byId id: Int) -> Category? {
        for category in categoryList {
            if category.id == id {
                return category
            }
        }
        return nil
    }
    
    func getCategories() -> [Category]? {
        if categoryList.count > 0 {
            return categoryList
        } else {
            if let categoryList = Cache.categories {
                for category in categoryList {
                    categories[category.id!] = category.name
                }
                self.categoryList = categoryList
                return categoryList
            }
        }
        return nil
    }
    
    func setCategories(_ categories: [Category]) {
        self.categoryList = categories
        Cache.categories = categories
    }
    
    func shouldBeLoggedIn(_ controller: UIViewController, completionHandler: (() -> Void)? = nil) {
        if Common.sharedInstance.getCurrentUser() == nil {
            let storyboard = UIStoryboard(name: "SignUP", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "SignupViewController1") as! SignupViewController1
            
            loginViewController.providesPresentationContextTransitionStyle = true;
            loginViewController.definesPresentationContext = true
            loginViewController.modalPresentationStyle = .overFullScreen
            
            controller.present(loginViewController, animated: true, completion: completionHandler)
        }
    }
    
    // MARK: Favorite ads related
    
    func getFavoriteAds(fromApi: Bool = false, _ completionHandler: @escaping ([Int]?) -> Void) {
        if !fromApi && favoriteAds.count > 0 {
            completionHandler(favoriteAds)
        } else {
            // make api call to get favorites
            Api.sharedInstance.getFavoriteAds { ids in
                if ids != nil {
                    self.favoriteAds = ids!
                }
                completionHandler(ids)
            }
        }
    }
    
    func addToFavorites(_ id: Int) {
        favoriteAds.append(id)
        Api.sharedInstance.addToFavorites(id)
    }
    
    func removeFromFavorites(_ id: Int) {
        favoriteAds = favoriteAds.filter { $0 != id }
        Api.sharedInstance.removeFromFavorites(id)
    }
    
    func refreshFavoriteAds() {
        favoriteAds = []
        getFavoriteAds { ids in }
    }
    
    func isFavorite(_ id: Int) -> Bool {
        return favoriteAds.contains(id)
    }
    
    // Mark: Follow related
    
    func getFollowers(fromApi: Bool = false, _ completionHandler: @escaping ([Int]?) -> Void) {
        if !fromApi && followers.count > 0 {
            completionHandler(followers)
        } else {
            // make api call to get favorites
            Api.sharedInstance.getFollowData { ids in
                if ids != nil {
                    if ids!["followers"] != nil {
                        self.followers = ids!["followers"]!
                    }
                    if ids!["following"] != nil {
                        self.following = ids!["followers"]!
                    }
                }
                completionHandler(self.followers)
            }
        }
    }
    
    func getBlocked(fromApi: Bool = false,
                    _ completionHandler: @escaping ([User]?) -> Void) {
        Api.sharedInstance.getBlockedData { users in
            if let users = users {
                completionHandler(users)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    
    func getFollowing(fromApi: Bool = false, _ completionHandler: @escaping ([Int]?) -> Void) {
        if !fromApi && following.count > 0 {
            completionHandler(following)
        } else {
            // make api call to get favorites
            Api.sharedInstance.getFollowData { ids in
                if ids != nil {
                    if ids!["followers"] != nil {
                        self.followers = ids!["followers"]!
                    }
                    if ids!["following"] != nil {
                        self.following = ids!["following"]!
                    }
                }
                completionHandler(self.following)
            }
        }
    }
    
    // MARK: User List related
    /*
    func getUserList(_ userType: UserType, _ completionHandler: @escaping ([User]?) -> Void) {
        switch userType {
        case .follower:
            getFollowers() { userIds in
                if let userIds = userIds, userIds.count > 0 {
                    Api.sharedInstance.getUsersDetails(userIds) { users in
                        if let users = users {
                            completionHandler(users)
                        } else {
                            completionHandler(nil)
                        }
                    }
                } else {
                    completionHandler(nil)
                }
                
            }
        case .following:
            getFollowing() { userIds in
                if let userIds = userIds, userIds.count > 0 {
                    Api.sharedInstance.getUsersDetails(userIds) { users in
                        if let users = users {
                            completionHandler(users)
                        } else {
                            completionHandler(nil)
                        }
                    }
                } else {
                    completionHandler(nil)
                }
                
            }
        case .blocked:
            getBlocked(completionHandler)
        }
    }
    */
    
    func followUser(_ id: Int) {
        following.append(id)
        Api.sharedInstance.followUser(id)
    }
    
    func unfollowUser(_ id: Int) {
        following = following.filter { $0 != id }
        Api.sharedInstance.unfollowUser(id)
    }
    
    func isFollower(_ id: Int) -> Bool{
        return followers.contains(id)
    }
    
    func isFollowing(_ id: Int) -> Bool{
        return following.contains(id)
    }
    
    func showNewListingSuccessAlert(_ controller: UIViewController) {
    /*
        let messageAlert = UIAlertController(
            title: Localized.aTextnewListingSuccessAlertTitle,
            message: Localized.aTextnewListingSuccessAlertMessage,
            preferredStyle: .alert)
        
        messageAlert.addAction(UIAlertAction(
            title: Localized.aTextnewListingSuccessAlertSellActionTitle,
            style: .default)
        { action in
            let storyboard = UIStoryboard(name: "Listing", bundle: nil)
            let cameraViewController = storyboard.instantiateViewController(withIdentifier: "Camera View Controller") as! CameraViewController
            let cameraNavigationController = UINavigationController(rootViewController: cameraViewController)
            TemporaryListing.sharedInstance.reset()
            controller.present(cameraNavigationController, animated: true, completion: nil)
        })
        messageAlert.addAction(UIAlertAction(
            title: Localized.aTextok,
            style: .default)
        { action in
            TemporaryListing.sharedInstance.reset()
            let tabBarController: MainUITabBarController = UIApplication.shared.delegate!.window?!.rootViewController as! MainUITabBarController
            if let listViewController = tabBarController.selectedViewController?.childViewControllers.first! {
                if listViewController is HomeViewController {
                    (listViewController as! HomeViewController).refreshData()
                }
            }
            
        })
        TemporaryListing.sharedInstance.reset()
        controller.present(messageAlert, animated: true, completion: nil)
        */
    }
    
    func listingModifiedAlert(_ controller: UIViewController) {
        let messageAlert = UIAlertController(
            title: Localized.aText,
            message: Localized.aText,
            preferredStyle: .alert)
        messageAlert.addAction(UIAlertAction(
            title: Localized.aText,
            style: .default)
        { action in })
        
        TemporaryListing.sharedInstance.reset()
        controller.present(messageAlert, animated: true, completion: nil)
    }
    
    func showNewListingErrorAlert(_ controller: UIViewController) {
        let messageAlert = UIAlertController(
            title: Localized.aText,
            message: Localized.aText,
            preferredStyle: .alert)
        
        messageAlert.addAction(UIAlertAction(
            title: Localized.aText,
            style: .default)
        { action in })
        
        controller.present(messageAlert, animated: true, completion: nil)
    }
    
    func userBlockedAlert(_ controller: UIViewController) {
        let messageAlert = UIAlertController(
            title: nil,
            message: Localized.aText,
            preferredStyle: .alert)
        messageAlert.addAction(UIAlertAction(
            title: Localized.aText,
            style: .default)
        { action in })
        controller.present(messageAlert, animated: true, completion: nil)
    }
    
    func userReportedAlert(_ controller: UIViewController) {
        let messageAlert = UIAlertController(
            title: nil,
            message: Localized.aText,
            preferredStyle: .alert)
        messageAlert.addAction(UIAlertAction(
            title: Localized.aText,
            style: .default)
        { action in })
        controller.present(messageAlert, animated: true, completion: nil)
    }
    
    func noInternetAlert(_ controller: UIViewController) {
        let noInternetAlert = UIAlertController(
            title: Localized.aText,
            message: Localized.aText,
            preferredStyle: .alert)
        
        noInternetAlert.addAction(UIAlertAction(
            title: Localized.aText,
            style: .default) {action in })
        
        controller.present(noInternetAlert, animated: true, completion: nil)
    }
    
    func errorOccured(_ controller: UIViewController) {
        let error = UIAlertController(
            title: Localized.aText,
            message: Localized.aText,
            preferredStyle: .alert)
        
        error.addAction(UIAlertAction(
            title: Localized.aText,
            style: .default) {action in })
        
        controller.present(error, animated: true, completion: nil)
    }
    
    
    func logOut() {
        Api.sharedInstance.logOut()
        user = nil
        identity = nil
    }
    
    func shouldShowContinueNewListing(_ controller: UIViewController, completionHandler: @escaping (Void) -> Void) {
        let temp = TemporaryListing.sharedInstance
        if temp.parameters.count > 0 || temp.photos.count > 0 {
            let shouldContinueAlert = UIAlertController(
                title: Localized.aText,
                message: Localized.aText,
                preferredStyle: .alert)
            
            shouldContinueAlert.addAction(UIAlertAction(
                title: Localized.aText,
                style: .default) {action in completionHandler() })
            shouldContinueAlert.addAction(UIAlertAction(
                title: Localized.aText,
                style: .default) {action in
                    TemporaryListing.sharedInstance.reset()
                    completionHandler()
            })
            controller.present(shouldContinueAlert, animated: true)
        } else {
            completionHandler()
        }
    }
    // MARK: Invite Friends
    func inviteFriendsDialog() -> UIActivityViewController? {
        let inviteText = Localized.aText + " " + Api.sharedInstance.getApiUrl()
        let inviteActivity = UIActivityViewController(activityItems: [inviteText], applicationActivities: nil)
        inviteActivity.excludedActivityTypes = [.airDrop, .addToReadingList]
        return inviteActivity
    }
    
    //view controllers
    func home() -> HomeViewController {
        let view = HomeViewController.instantiateFromStoryboard(storyboardName: "Home")
        return view
    }
    
    func category() -> CategorySelectionViewController {
        let view = CategorySelectionViewController.instantiateFromStoryboard(storyboardName: "Category")
        return view
    }
    
    func addAds() -> AddAdsViewController {
        let view = AddAdsViewController.instantiateFromStoryboard(storyboardName: "AddAds")
        return view
    }
    
    func hotoffer() -> HotOfferViewController {
        let view = HotOfferViewController.instantiateFromStoryboard(storyboardName: "HotOffer")
        return view
    }
    
    func me() -> MeViewController {
        let view = MeViewController.instantiateFromStoryboard(storyboardName: "Me")
        return view
    }
    
    func signup() -> SignupViewController1 {
        let view = SignupViewController1.instantiateFromStoryboard(storyboardName: "SignUP")
        return view
    }
    
    func login() -> LoginViewController {
        let view = LoginViewController.instantiateFromStoryboard(storyboardName: "SignUP")
        return view
    }

    
    func tabbarMaker(){
        // Create Tab one
        let homeViewController = Common.sharedInstance.home()
        let tabOneBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home.png"), selectedImage: UIImage(named: "home_hover.png"))
        homeViewController.tabBarItem = tabOneBarItem
        let navOneController = UINavigationController(rootViewController: homeViewController)
        
        // Create Tab two
        let categoryViewController = Common.sharedInstance.category()
        let tabTwoBarItem = UITabBarItem(title: "categories", image: UIImage(named: "categories.png"), selectedImage: UIImage(named: "categories_hover.png"))
        categoryViewController.tabBarItem = tabTwoBarItem
        let navTwoController = UINavigationController(rootViewController: categoryViewController)
        
        // Create Tab three
        let addAdsViewController = Common.sharedInstance.addAds()
        let tabThreeBarItem = UITabBarItem(title: "Add Ads", image: UIImage(named: "sell.png"), selectedImage: UIImage(named: "sell_hover.png"))
        addAdsViewController.tabBarItem = tabThreeBarItem
        let navThreeController = UINavigationController(rootViewController: addAdsViewController)
        
        // Create Tab four
        let hotofferViewController = Common.sharedInstance.hotoffer()
        let tabFourBarItem = UITabBarItem(title: "Hot Offer", image: UIImage(named: "messages.png"), selectedImage: UIImage(named: "messages_hover.png"))
        hotofferViewController.tabBarItem = tabFourBarItem
        let navFourController = UINavigationController(rootViewController: hotofferViewController)
        
        // Create Tab five
        let meViewController = Common.sharedInstance.me()
        let tabFiveBarItem = UITabBarItem(title: "Me", image: UIImage(named: "account.png"), selectedImage: UIImage(named: "acount_hover.png"))
        meViewController.tabBarItem = tabFiveBarItem
        let navFiveController = UINavigationController(rootViewController: meViewController)
        
        let controllers = [navOneController, navTwoController, navThreeController, navFourController, navFiveController]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.tabBarController.viewControllers = controllers
        appDelegate.window!.backgroundColor = UIColor.white
        appDelegate.window!.rootViewController = appDelegate.tabBarController;
        //appDelegate.window?.makeKeyAndVisible()
        self.selectTabbarItem(idx: 0)
    }

    func selectTabbarItem(idx:Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.tabBarController.selectedIndex = idx;
    }
}
