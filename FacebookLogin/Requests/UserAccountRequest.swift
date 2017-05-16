//
//  UserAccountRequest.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 04/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserAccountRequest: Mappable {
	
	var user: User?
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		user <- map["user"]
	}
}
