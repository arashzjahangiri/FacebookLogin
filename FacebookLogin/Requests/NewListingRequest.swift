//
//  NewListingRequest.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 05/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct NewListingRequest: Mappable {
	
	var listing: Listing?
	var ready: Bool?
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		listing <- map["post"]
		ready <- map["post.ready"]
	}
}
