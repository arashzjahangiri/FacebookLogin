//
//  ConfirmCode.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 5/10/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct ConfirmCode: Mappable {
    
    var status: Int?
    
    init(token: String?, expireTime: String?, status:Int?) {
        self.status = status
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        status <- map["Status"]
    }
    
    init(map: [String: Any]) {
        status = map["Status"] as? Int
    }
}
