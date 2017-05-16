//
//  ConfirmUser.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 5/10/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct RegisterNewUser: Mappable {
    
    var token: String?
    var expireTime: Int?
    var status: Int?
    
    init(token: String?, expireTime: Int?, status:Int?) {
        self.token = token
        self.expireTime = expireTime
        self.status = status
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        token <- map["Token"]
        expireTime <- map["ExpireTime"]
        status <- map["Status"]
    }
    
    init(map: [String: Any]) {
        token = map["Token"] as? String
        expireTime = map["ExpireTime"] as? Int
        status = map["Status"] as? Int
    }
}
