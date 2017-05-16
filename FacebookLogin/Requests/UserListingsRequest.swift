//
//  UserListingsRequest.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 04/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserListingsRequest: Mappable {
	
	var listings: [Listing]?
	var user: User?
	var approvedAt: Int?
	var source: Int?
	var distance: Double?
	var ignore: [Int]?
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		listings <- map["ads"]
		user <- map["user"]
		approvedAt <- map["approved_at"]
		source <- map["source"]
		distance <- map["distance"]
		ignore <- map["ignore"]
	}
}
