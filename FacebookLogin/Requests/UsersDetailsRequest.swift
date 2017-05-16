//
//  UsersDetailsRequest.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 03/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct UsersDetailsRequest: Mappable {
	
	var users: [User]?
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		users <- map["users"]
	}
}
