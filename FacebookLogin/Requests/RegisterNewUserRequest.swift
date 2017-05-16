//
//  RegisterNewUserRequest.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 5/10/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper
struct RegisterNewUserRequest:Mappable {
    var token: String?
    var expireTime: Int?
    var status: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        token <- map["Token"]
        expireTime <- map["ExpireTime"]
        status <- map["Status"]
    }

}
