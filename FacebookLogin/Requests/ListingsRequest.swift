//
//  ListingsRequest.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 04/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct ListingsRequest: Mappable {
	
	var listings: [Listing]?
	var approvedAt: Int?
	var distance: Double?
	var ignore: [Int]?
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		listings <- map["ads"]
		approvedAt <- map["approved_at"]
		distance <- map["distance"]
		ignore <- map["ignore"]
	}
}
