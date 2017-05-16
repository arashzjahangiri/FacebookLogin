//
//  Api.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 25/05/16.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import AlamofireObjectMapper

class Api {
    
    static let sharedInstance = Api()
    
    fileprivate struct ApiDetails {
        static let ApiUrl = "YOUR_BASE_URL"
        static let PrivateKey = "YOUR_PRIVATE_KEY"
        static let PublicKey = "YOUR_PUBLIC_KEY"
    }
    let iTunesAppUrl = ""
    
    func getApiUrl() -> String {
        return ApiDetails.ApiUrl
    }
    
    
    fileprivate func customHeaders(_ uri: String, parameters: [String : Any]?) -> [String: String] {
        let currentTimestamp = String(Int(Date().timeIntervalSince1970))
        _ = parameters != nil && parameters!.count > 0 ? "?" + ApiHelper.generateQueryString(parameters) : ""
        //let toEncode = currentTimestamp + ApiDetails.PublicKey + uri + encodedParameters
        var ret = [
            "X-PUBLIC": ApiDetails.PublicKey,
            "Timestamp": currentTimestamp
        ]
        if Common.sharedInstance.getIdentity() != nil {
            ret["X-PUBLIC"] = ret["X-PUBLIC"]! + Common.sharedInstance.getIdentity()!
        }
        return ret
    }
    
    fileprivate func request(method: Alamofire.HTTPMethod,
                             uri: String,
                             parameters: [String : Any]? = nil) -> DataRequest {
        //let headers = customHeaders(uri, parameters: parameters)
        let url = URL(string: ApiDetails.ApiUrl + uri)!
        
        let request = Alamofire.request(url, method: method, parameters: parameters, headers: nil)
        request.authenticate(user: "ARASH", password: "111111")
        if Common.sharedInstance.debug == true {
            request.responseString { (response) in
                print(response)
            }
        }
        request.responseData { dataResponse in
            if let error = dataResponse.result.error as? NSError, error.code == -1009 {
                if let controller = UIApplication.shared.keyWindow?.rootViewController {
                    if controller.presentedViewController == nil {
                        Common.sharedInstance.noInternetAlert(controller)
                    }
                }
            } else {
                if let statusCode = dataResponse.response?.statusCode {
                    switch statusCode {
                    case 401:
                        Common.sharedInstance.shouldBeLoggedIn((UIApplication.shared.keyWindow?.rootViewController)!)
                    case 403:
                        print("403 - forbidden")
                    case 405:
                        let updateAlert = UIAlertController(
                            title: Localized.aText,
                            message: Localized.aText,
                            preferredStyle: .alert
                        )
                        updateAlert.addAction(UIAlertAction(
                            title: Localized.aText,
                            style: .default)
                        { action in
                            UIApplication.shared.openURL(URL(string : self.iTunesAppUrl)!)
                        })
                        
                        UIApplication.shared.keyWindow?.rootViewController?.present(updateAlert, animated: true, completion: nil)
                        
                    case 500:
                        print("status 500")
                    default:
                        break
                    }
                }
            }
        }
        return request
    }
    
    func get(_ uri: String,
             parameters: [String: Any]? = nil) -> DataRequest {
        return request(method: .get, uri: uri, parameters: parameters)
    }
    
    func post(_ uri: String,
              parameters: [String: Any]? = nil) -> DataRequest {
        return request(method: .post, uri: uri, parameters: parameters)
    }

    func getCategories(_ fromApi: Bool? = false, _ completionHandler: @escaping ([Category]?) -> Void) {
        if !fromApi!, let categoryList = Common.sharedInstance.getCategories() {
            completionHandler(categoryList)
        } else {
            let apiRequest = get("categories")
            apiRequest.responseObject { (response: DataResponse<CategoryRequest>) in
                guard let categoryResponse = response.result.value,
                    let categories = categoryResponse.categories else {
                        print("Malformed data received from /categories")
                        completionHandler(nil)
                        return
                }
                Common.sharedInstance.setCategories(categories)
                completionHandler(categories)
            }
        }
    }
    
    func getListings(_ categoryId: Int? = nil, location: Location? = nil, queryParameters: [String: Any]? = nil, completionHandler: @escaping ([Listing]?, [String: Any]?) -> Void) {
        var parameters: [String:Any] = [:]
        if categoryId != nil {
            parameters["category_id"] = categoryId
        }
        if location != nil {
            parameters["location_lat"] = location!.latitude!
            parameters["location_long"] = location!.longitude!
            parameters["location"] = location!.name!
        }
        if queryParameters != nil {
            for key in queryParameters!.keys {
                parameters[key] = queryParameters![key]
            }
        }
        let apiRequest = get("ads", parameters: parameters)
        apiRequest.responseObject { (response: DataResponse<ListingsRequest>) in
            guard let listingsResponse = response.result.value,
                let listings = listingsResponse.listings,
                let approvedAt = listingsResponse.approvedAt,
                let distance = listingsResponse.distance,
                let ignore = listingsResponse.ignore else {
                    print("Malformed data received from /ads")
                    completionHandler(nil, nil)
                    return
            }
            let queryParameters: [String: Any] = [
                "approved_at": approvedAt,
                "ignore": ignore,
                "distance": distance
            ]
            completionHandler(listings, queryParameters)
        }
    }
    
    func getUserListings(_ queryParameters: [String:Any]? = nil, completionHandler: @escaping ([Listing]?, [String:Any]?, User?) -> Void) {
        var parameters: [String: Any] = [:]
        if queryParameters != nil {
            for key in queryParameters!.keys {
                parameters[key] = queryParameters![key]
            }
        }
        let apiRequest = get("account/ads", parameters: parameters)
        apiRequest.responseObject { (response: DataResponse<UserListingsRequest>) in
            guard let userListingsResponse = response.result.value,
                let listings = userListingsResponse.listings,
                let user = userListingsResponse.user,
                let approvedAt = userListingsResponse.approvedAt,
                let source = userListingsResponse.source,
                let distance = userListingsResponse.distance,
                let ignore = userListingsResponse.ignore else {
                    print("Malformed data received from account/ads")
                    completionHandler(nil, nil, nil)
                    return
            }
            let queryParameters: [String: Any] = [
                "source": source,
                "approved_at": approvedAt,
                "ignore": ignore,
                "distance": distance
            ]
            completionHandler(listings, queryParameters, user)
        }
    }
    
    func getMyListing(id: Int, completionHandler: @escaping (Bool) -> Void) {
        let apiRequest = get("ads/myad/" + String(id))
        apiRequest.responseObject { (response: DataResponse<MyListingRequest>) in
            guard let listingResponse = response.result.value,
                let data = listingResponse.listingData else {
                    print("Malformed data received from ads/myad/" + String(id))
                    completionHandler(false)
                    return
            }
            TemporaryListing.sharedInstance.map(data) {
                completionHandler(true)
            }
        }
    }
    
    func getPublicChat(for id: Int, completionHandler: @escaping ([PublicMessage]?) -> Void) {
        let apiRequest = get("comments/view/" + String(id))
        apiRequest.responseObject { (response: DataResponse<PublicChatRequest>) in
            guard let listingResponse = response.result.value,
                let messages = listingResponse.messages else {
                    print("Malformed data received from comments/view/" + String(id))
                    completionHandler(nil)
                    return
            }
            completionHandler(messages)
        }
    }
    
    func addNewPublicMessage(for id: Int, message: String, completionHandler: @escaping (Void) -> Void) {
        let parameters: [String: Any] = [
            "ad_id": id,
            "message": message
        ]
        let apiRequest = post("comments/new/", parameters: parameters)
        apiRequest.response { response in
            completionHandler()
        }
        
    }
    
    func sendDeviceId(_ token: String) {
        UserDefaults.standard.setValue(token, forKey: Common.sharedInstance.versionPrefix + "token")
        _ = post("device", parameters: ["token": token as AnyObject])
    }
    
    func createNewUser(_ facebookUserData: [String : Any]?, completionHandler: @escaping (User?) -> Void) {
        //let userData = facebookUserData["picture"]!! as! [String:AnyObject]
        //let pictureData = userData["data"]! as! [String:AnyObject]
        //let photoUrl = pictureData["url"] as? String
        
        let parameters:[String:String] = [
            "fb_id": facebookUserData!["id"] as? String ?? "",
            "token": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "name": facebookUserData!["name"] as? String ?? "",
            "email": facebookUserData!["email"] as? String ?? "",
            //"photo": photoUrl ?? "",
            "location": Common.sharedInstance.GPSLocation?.name ?? ((facebookUserData!["location"] as? [String:AnyObject]) != nil ? (facebookUserData?["location"]! as! [String:AnyObject])["name"]! as! String : ""),
            ]
        
        let apiRequest = post("api/registerNewUser", parameters: parameters)
        apiRequest.responseObject { (response: DataResponse<User>) in
            guard let userResponse = response.result.value else {
                    print("Malformed data received from /account/new")
                    completionHandler(nil)
                    return
            }
            let user = User(JSON: facebookUserData!)
            Common.sharedInstance.setCurrentUser(user!)
            //Common.sharedInstance.setIdentity(userResponse.identity!)
            
            Common.sharedInstance.getFavoriteAds(fromApi: true) { ids in }
            Common.sharedInstance.getFollowing(fromApi: true) {ids in }
            Common.sharedInstance.updateUserDataFromApi()
            
            completionHandler(userResponse)
        }
    }
    
    func getCurrentUserData(_ completionHandler: @escaping (User?) -> Void) {
        let apiRequest = get("account")
        apiRequest.responseObject { (response: DataResponse<UserAccountRequest>) in
            guard let accountResponse = response.result.value,
                let user = accountResponse.user else {
                    print("Malformed data received from /account")
                    completionHandler(nil)
                    return
            }
            completionHandler(user)
        }
    }
    
    func updateUserData(_ user: User, completionHandler: ((Void) -> Void)? = nil) {
        var parameters:[String:Any] = [
            //"token": UIDevice.currentDevice().identifierForVendor?.UUIDString ?? "",
            //"location": facebookUserData["location"]!!["name"]!! as? String ?? "",
            "user_notifications": user.userNotifications ? 1 : 0,
            "app_notifications": user.appNotifications ? 1 : 0,
            "photo": user.photo
        ]
        if let location = user.location {
            parameters["location"] = location.name ?? ""
            parameters["location_lat"] = location.latitude ?? 0
            parameters["location_long"] = location.longitude ?? 0
        }
        let apiRequest = post("account/update", parameters: parameters)
        apiRequest.response { (response) in
            completionHandler?()
        }
    }
    
    func updateLocation() {
        guard let location = Common.sharedInstance.GPSLocation else {
            return
        }
        let parameters: [String:Any] = [
            "location": location.name ?? "Tehran",
            "location_lat": location.latitude ?? 35.7312129,
            "location_long": location.longitude ?? 51.5212737
        ]
        
        let _ = post("account/update", parameters: parameters)
    }
    
    func getFavoriteAds(_ completionHandler: @escaping ([Int]?) -> Void) {
        let apiRequest = get("ads/favorite")
        apiRequest.responseObject { (response: DataResponse<FavoriteListingsRequest>) in
            guard let favoriteResponse = response.result.value,
                let ids = favoriteResponse.ids else {
                    print("Malformed data received from /ads/favorite")
                    completionHandler(nil)
                    return
            }
            completionHandler(ids)
        }
    }
    
    func removeFromFavorites(_ id: Int) {
        _ = post("ads/favorite", parameters: ["ad_id": id, "delete": 1])
    }
    
    func addToFavorites(_ id: Int) {
        _ = post("ads/favorite", parameters: ["ad_id": id])
        
    }
    
    func getFollowData(_ completionHandler: @escaping ([String:[Int]]?) -> Void) {
        
        let apiRequest = get("account/follow")
        apiRequest.responseObject { (response: DataResponse<FollowDataRequest>) in
            guard let followResponse = response.result.value,
                let followers = followResponse.followers,
                let following = followResponse.following else {
                    print("Malformed data received from /account/follow")
                    completionHandler(nil)
                    return
            }
            completionHandler(["followers": followers, "following": following])
        }
    }
    
    func getBlockedData(_ completionHandler: @escaping ([User]?) -> Void) {
        
        let apiRequest = get("account/blocked")
        apiRequest.responseObject { (response: DataResponse<BlockedDataRequest>) in
            guard let followResponse = response.result.value,
                let blocked = followResponse.blocked else {
                    print("Malformed data received from /account/blocked")
                    completionHandler(nil)
                    return
            }
            completionHandler(blocked)
        }
    }
    
    func followUser(_ id: Int) {
        _ = post("account/follow", parameters: ["user_id": id])
    }
    
    func unfollowUser(_ id: Int) {
        _ = post("account/follow", parameters: ["user_id": id, "delete": 1])
    }
    
    func reportListing(_ id: Int) {
        _ = post("ads/report", parameters: ["ad_id": id])
    }
    
    func reportComment(_ id: Int?) {
        if id != nil {
            _ = get("report/comment/" + String(id!))
        }
    }
    
    func deleteComment(_ id: Int?) {
        if id != nil {
            _ = get("comments/delete/" + String(id!))
        }
    }
    
    // Mark: Me section
    
    func getUserNotificationFeed(_ completionHandler: @escaping ([Notification]?) -> Void ) {
        let apiRequest = get("notifications")
        apiRequest.responseObject { (response: DataResponse<NotificationFeedRequest>) in
            guard let notificationResponse = response.result.value,
                let notifications = notificationResponse.notifications else {
                    print("Malformed data received from /notifications")
                    completionHandler(nil)
                    return
            }
            completionHandler(notifications)
        }
    }
    
    func getListingsDetails(_ ids: [Int], completionHandler: @escaping ([Listing]?) -> Void ) {
        if ids.count > 0 {
            let apiRequest = get("ads/view", parameters: ["ids": ids])
            apiRequest.responseObject { (response: DataResponse<ListingsDetailsRequest>) in
                guard let dataResponse = response.result.value,
                    let listings = dataResponse.listings else {
                        print("Malformed data received from ads/view")
                        completionHandler(nil)
                        return
                }
                completionHandler(listings)
            }
        } else {
            completionHandler(nil)
        }
    }
    
    func getUsersDetails(_ ids: [Int], completionHandler: @escaping ([User]?) -> Void ) {
        let apiRequest = get("account/users", parameters: ["ids": ids])
        apiRequest.responseObject { (response: DataResponse<UsersDetailsRequest>) in
            guard let usersResponse = response.result.value,
                let users = usersResponse.users else {
                    print("Malformed data received from /account/users")
                    completionHandler(nil)
                    return
            }
            completionHandler(users)
        }
    }
    
    func makeOffer(_ offerData: [String: Any], completionHandler: @escaping (Int?) -> Void) {
        let request = post("messages/offer", parameters: offerData)
        request.responseObject { (response: DataResponse<ConversationDetailsRequest>) in
            guard let conversationsResponse = response.result.value,
                let messages = conversationsResponse.messageList,
                let conversationId = messages.first?.conversationId else {
                    print("Malformed data received from /messages/offer")
                    completionHandler(nil)
                    return
            }
            completionHandler(conversationId)
        }
    }
    
    // MARK: Message related
    func sendMessage(_ messageData: [String: Any]) {
        _ = post("messages/new", parameters: messageData)
    }
    
    func getConversationList(_ conversationData: [String: Any]? = nil, completionHandler: @escaping ([Conversation]?, [String: Any]?) -> Void) {
        let apiRequest = get("messages", parameters: conversationData)
        apiRequest.responseObject { (response: DataResponse<ConversationsRequest>) in
            guard let conversationsResponse = response.result.value,
                let conversations = conversationsResponse.conversations,
                let ignore = conversationsResponse.ignore,
                let messageDate = conversationsResponse.messageDate else {
                    print("Malformed data received from /messages")
                    completionHandler(nil, nil)
                    return
            }
            let queryParameters: [String: Any] = [
                "ignore": ignore,
                "message_date": messageDate
            ]
            completionHandler(conversations, queryParameters)
        }
    }
    
    func getConversationDetails(_ conversationId: Int, completionHandler: @escaping ([Message]?, Listing?, [User]?) -> Void) {
        if Common.sharedInstance.debug {
            print("get conversation \(conversationId)")
        }
        let apiRequest = get("messages/view/" + String(conversationId))
        apiRequest.responseObject { (response: DataResponse<ConversationDetailsRequest>) in
            guard let conversationResponse = response.result.value,
                let messageList = conversationResponse.messageList,
                let users = conversationResponse.users else {
                    print("Malformed data received from /messages/view/" + String(conversationId))
                    completionHandler(nil, nil, nil)
                    return
            }
            guard let listing = conversationResponse.listing else {
                completionHandler(messageList, nil, users)
                return
            }
            completionHandler(messageList, listing, users)
        }
    }
    
    func getConversationDetails(adId: Int, completionHandler: @escaping ([Message]?, Listing?, [User]?, Int?) -> Void) {
        if Common.sharedInstance.debug {
            print("get conversation for \(adId)")
        }
        let apiRequest = post("messages/view/", parameters: ["ad_id": adId])
        apiRequest.responseObject { (response: DataResponse<ConversationDetailsRequest>) in
            guard let conversationResponse = response.result.value,
                let messageList = conversationResponse.messageList,
                let users = conversationResponse.users,
                let listing = conversationResponse.listing,
                let conversationId = conversationResponse.conversationId else {
                    //                    print("Malformed data received from /messages/view/ for " + String(adId))
                    completionHandler(nil, nil, nil, 0)
                    return
            }
            completionHandler(messageList, listing, users, conversationId)
        }
    }
    
    func unblockUser(with id: Int?) {
        if let id = id {
            _ = get("messages/unblock/\(id)")
        }
    }
    
    func blockUser(with id: Int?) {
        if let id = id {
            _ = get("messages/block/\(id)")
        }
    }
    
    func reportUser(withConversationId id: Int?) {
        if let id = id {
            _ = get("report/message/\(id)")
        }
    }
    
    
    func sendNewListing(_ completionHandler: @escaping (Bool?) -> Void) {
        if Common.sharedInstance.debug == true {
            print(TemporaryListing.sharedInstance.parameters)
        }
        let apiRequest = post("ads/new", parameters: TemporaryListing.sharedInstance.parameters)
        apiRequest.responseJSON { response in
            guard let value = response.result.value as? [String: Any],
                let post = value["post"] as? [String:Any],
                let id = post["id"] as? Int else {
                    print("Malformed data received from /ads/new")
                    completionHandler(nil)
                    return
            }
            TemporaryListing.sharedInstance.id = id
            completionHandler(true)
            Api.sharedInstance.uploadListingPhotos()
        }
    }
    
    func uploadListingPhotos(_ isEdit: Bool = false, completionHandler: ((Listing?) -> Void)? = nil ) {
        TemporaryListing.sharedInstance.parameters["ready"] = true
        let parameters = TemporaryListing.sharedInstance.parameters
        var uri = "ads/new"
        if isEdit && parameters["id"] is Int {
            uri = "ads/update/" + String(describing: parameters["id"] as! Int)
        }
        let headers = customHeaders(uri, parameters: parameters)
        let url = URL(string: ApiDetails.ApiUrl + uri)!
        let newPhotos = ApiHelper.getNewPhotos(media: TemporaryListing.sharedInstance.media ?? "", photos: TemporaryListing.sharedInstance.photos)
        if newPhotos.count > 0 {
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    var index = 0
                    for photo in TemporaryListing.sharedInstance.photos {
                        if let imageData = UIImageJPEGRepresentation(photo, 100) {
                            let name = "file" + String(index)
                            index += 1
                            multipartFormData.append(imageData, withName: name, fileName: name + ".jpg", mimeType: "image/jpeg")
                        }
                    }
                    let sorted = parameters.sorted { $0.key < $1.key }
                    for (key, value) in sorted {
                        if (value as? [String:Any]) != nil {
                            for (internalKey, internalValue) in value as! [String:Any] {
                                if let data = (internalValue as! String).data(using: String.Encoding.utf8) {
                                    multipartFormData.append(data, withName: internalKey)
                                }
                            }
                        } else {
                            if let data = String(describing: value).data(using: String.Encoding.utf8) {
                                multipartFormData.append(data, withName: key)
                            }
                        }
                    }
            },
                to: url,
                headers: headers,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        if Common.sharedInstance.debug {
                            upload.responseString { response in
                                print(response)
                            }
                        }
                        upload.responseJSON { response in
                            if Common.sharedInstance.debug == true {
                                print(response.result.value!)
                            }
                            guard let value = response.result.value as? [String: Any],
                                let parameters = value["post"] as? [String: Any] else {
                                    print("Malformed data received from " + uri)
                                    return
                            }
                            if Common.sharedInstance.debug == true {
                                print(parameters)
                            }
                            TemporaryListing.sharedInstance.map(parameters)
                            completionHandler?(Listing(map: parameters))
                            
                        }
                    case .failure( _):
                        print("something wrong happened when we uploaded a picture", parameters)
                        break
                    }
            }
            )
        }
    }
    
    func updateListing(_ completionHandler: @escaping (Bool?, Listing?) -> Void) {
        if Common.sharedInstance.debug == true {
            print(TemporaryListing.sharedInstance.parameters)
        }
        if !shouldUploadPhotos() {
            TemporaryListing.sharedInstance.parameters["ready"] = 1
        }
        let apiRequest = post("ads/update/" + String(describing: TemporaryListing.sharedInstance.id!), parameters: TemporaryListing.sharedInstance.parameters)
        apiRequest.responseObject { (response: DataResponse<NewListingRequest>) in
            guard let newListingResponse = response.result.value,
                let listing = newListingResponse.listing else {
                    print("Malformed data received from /ads/update/" + String(describing: TemporaryListing.sharedInstance.id!))
                    completionHandler(nil, nil)
                    return
            }
            if !self.shouldUploadPhotos() {
                completionHandler(true, listing)
            } else {
                Api.sharedInstance.uploadListingPhotos(true) { listing in
                    completionHandler(true, listing)
                }
            }
        }
    }
    
    func shouldUploadPhotos() -> Bool {
        let mediaCount = TemporaryListing.sharedInstance.media!.components(separatedBy: ",").count - 1
        let photoCount = TemporaryListing.sharedInstance.photos.count
        if mediaCount < photoCount {
            print("should upload photos")
            return true
        }
        print("should not upload photos")
        return false
    }
    
    // Delete listing
    func archiveListing(_ listingId: Int, completionHandler: @escaping (String?) -> Void) {
        let apiRequest = get("/ads/archive/" + String(listingId))
        apiRequest.responseJSON { response in
            guard let value = response.result.value as? [String: AnyObject],
                let message = value["message"] as? String else {
                    print("Malformed data received from /ads/archive/" + String(listingId))
                    completionHandler(nil)
                    return
            }
            completionHandler(message)
        }
    }
    
    func markListingAsSold(_ listingId: Int, completionHandler: @escaping (String?) -> Void) {
        let apiRequest = get("/ads/sold/" + String(listingId))
        apiRequest.responseJSON { response in
            guard let value = response.result.value as? [String: AnyObject],
                let message = value["message"] as? String else {
                    print("Malformed data received from /ads/sold/" + String(listingId))
                    completionHandler(nil)
                    return
            }
            completionHandler(message)
        }
    }
    
    func markListingAsUnsold(_ listingId: Int, completionHandler: @escaping (String?) -> Void) {
        let apiRequest = get("/ads/unsold/" + String(listingId))
        apiRequest.responseJSON { response in
            guard let value = response.result.value as? [String: AnyObject],
                let message = value["message"] as? String else {
                    print("Malformed data received from /ads/sold/" + String(listingId))
                    completionHandler(nil)
                    return
            }
            completionHandler(message)
        }
    }
    
    func logOut() {
        let token = UserDefaults.standard.object(forKey: Common.sharedInstance.versionPrefix + "token")
        if token != nil {
            _ = post("devices/logout", parameters: ["token": token!])
        }
    }
    
    // MARK: Upload images
    func uploadNewPhoto(_ image: UIImage, parameters: [String: Any], isEdit: Bool = false, completionHandler: @escaping () -> Void) {
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        var uri = "ads/new"
        if isEdit && parameters["id"] is Int {
            uri = "ads/update/" + String(describing: parameters["id"] as! Int)
        }
        let headers = customHeaders(uri, parameters: parameters)
        let url = URL(string: ApiDetails.ApiUrl + uri)!
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "imagefile", fileName: "image.jpg", mimeType: "image/jpeg")
                let sorted = parameters.sorted { $0.key < $1.key }
                for (key, value) in sorted {
                    if (value as? [String:Any]) != nil {
                        for (internalKey, internalValue) in value as! [String:Any] {
                            if let data = (internalValue as! String).data(using: String.Encoding.utf8) {
                                multipartFormData.append(data, withName: internalKey)
                            }
                        }
                    } else {
                        if let data = String(describing: value).data(using: String.Encoding.utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                }
        },
            to: url,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    if Common.sharedInstance.debug {
                        upload.responseString { response in
                            print(response)
                        }
                    }
                    upload.responseJSON { response in
                        if Common.sharedInstance.debug == true {
                            print(response.result.value!)
                        }
                        guard let value = response.result.value as? [String: Any],
                            let parameters = value["post"] as? [String: Any] else {
                                print("Malformed data received from " + uri)
                                completionHandler()
                                return
                        }
                        if Common.sharedInstance.debug == true {
                            print(parameters)
                        }
                        TemporaryListing.sharedInstance.map(parameters) {
                            completionHandler()
                        }
                        
                    }
                case .failure( _):
                    print("something wrong happened when we uploaded a picture", parameters)
                    break
                }
        }
        )
    }
    
    func deleteConversation(_ conversationId: Int) {
        _ = get("messages/delete/" + String(conversationId))
    }
    
    func getImages(forUrls imageUrls: [String], completionHandler: @escaping ([UIImage]) -> Void) {
        var photos = [Int:UIImage]() {
            didSet {
                if photos.count == imageUrls.count {
                    let sorted = Array(photos).sorted { $0.0 < $1.0 }.map { $0.value }
                    completionHandler(sorted)
                }
            }
        }
        for (index, imageUrl) in imageUrls.enumerated() {
            ApiHelper.getImage(imageUrl: imageUrl) { image in
                photos[index] = image
            }
        }
    }
    
    // MARK: Instagram
    func getInstagramUser(_ code: String, completionHandler: @escaping (Bool) -> Void) {
        var params:[String:Any] = [
            "code": code,
            "token": Common.sharedInstance.deviceToken ?? "",
            ]
        if let location = Common.sharedInstance.GPSLocation {
            params["location"] = location.name
            params["location_lat"] = location.latitude
            params["location_long"] = location.longitude
        }
        let request = post("account/instagram", parameters: params)
        request.responseObject { (response: DataResponse<UserAccountRequest>) in
            guard let userResponse = response.result.value,
                let user = userResponse.user else {
                    print("Malformed data received from /account/instagram with code \(code)")
                    completionHandler(false)
                    return
            }
            
            Common.sharedInstance.setCurrentUser(user)
            Common.sharedInstance.setIdentity(user.identity!)
            
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "userLoggedIn"), object: nil)
            
            Common.sharedInstance.getFavoriteAds(fromApi: true) { ids in }
            Common.sharedInstance.getFollowing(fromApi: true) {ids in }
            Common.sharedInstance.updateUserDataFromApi()
            
            completionHandler(true)
        }
    }
    
    // MARK: Telegram
    func sendTelegramNumber(_ phone: String) {
        var params:[String:Any] = [
            "phone": phone,
            "token": Common.sharedInstance.deviceToken ?? "",
            ]
        if let location = Common.sharedInstance.GPSLocation {
            params["location"] = location.name
            params["location_lat"] = location.latitude
            params["location_long"] = location.longitude
        }
        let _ = post("account/telegram", parameters: params)
    }
    
    func sendTelegramCode(_ phone: String, _ code: String, completionHandler: @escaping (Bool) -> Void) {
        var params:[String:Any] = [
            "phone": phone,
            "code": code
        ]
        if let location = Common.sharedInstance.GPSLocation {
            params["location"] = location.name
            params["location_lat"] = location.latitude
            params["location_long"] = location.longitude
        }
        let request = post("account/confirmCode", parameters: params)
        request.responseObject { (response: DataResponse<UserAccountRequest>) in
            guard let userResponse = response.result.value,
                let user = userResponse.user else {
                    print("Malformed data received from /account/telegram with code \(code)")
                    completionHandler(false)
                    return
            }
            Common.sharedInstance.setCurrentUser(user)
            Common.sharedInstance.setIdentity(user.identity!)
            
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "userLoggedIn"), object: nil)
            
            Common.sharedInstance.getFavoriteAds(fromApi: true) { ids in }
            Common.sharedInstance.getFollowing(fromApi: true) {ids in }
            Common.sharedInstance.updateUserDataFromApi()
            
            completionHandler(true)
        }
    }
    
    func markNotificationAsRead(_ notification: Notification) {
        if let notificationId = notification.id {
            _ = get("/notifications/read/\(notificationId)")
        }
    }
    
    func updateUserPhoto(image: UIImage, completionHandler: @escaping (Bool, String?) -> Void) {
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        let uri = "upload/userphoto"
        
        let parameters = [
            "user_id": Common.sharedInstance.getCurrentUser()!.id!
        ]
        
        let headers = customHeaders(uri, parameters: parameters)
        let url = URL(string: ApiDetails.ApiUrl + uri)!
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "imagefile", fileName: "image.jpg", mimeType: "image/jpeg")
                let sorted = parameters.sorted { $0.key < $1.key }
                for (key, value) in sorted {
                    if let data = String(describing: value).data(using: String.Encoding.utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
        },
            to: url,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    if Common.sharedInstance.debug {
                        upload.responseString { response in
                            print(response)
                        }
                    }
                    upload.responseJSON { response in
                        guard let value = response.result.value as? [String: Any],
                            let url = value["url"] as? String,
                            let _ = value["status"] as? String else {
                                print("Malformed data received from " + uri)
                                completionHandler(false, nil)
                                return
                        }
                        completionHandler(true, url)
                    }
                case .failure( _):
                    print("something wrong happened when we uploaded a picture", parameters)
                    break
                }
        }
        )
    }
    
    //MARK: signup
    func signUP(_ username: String, email:String, mobile:String, location:String, preNationalCode:String, completionHandler: @escaping (String?) -> Void) {
        if Common.sharedInstance.debug {
            print("username: \(username)")
        }
        var params:[String:Any] = [
            "Username": username,
            "Email": email,
            "mobile": mobile,
            "preNationalCode": preNationalCode
        ]
        if let location = Common.sharedInstance.GPSLocation {
            params["Location"] = location.name
            params["location_lat"] = location.latitude
            params["location_long"] = location.longitude
        }
        let request = post("api/registerNewUser", parameters: params)
        request.responseObject { (response: DataResponse<RegisterNewUserRequest>) in
            guard let userresponse = response.result.value,
                let token = userresponse.token else {
                    print("no token catched from server")
                    completionHandler(nil)
                    return
            }
            completionHandler(token)
        }
    }
    
}
