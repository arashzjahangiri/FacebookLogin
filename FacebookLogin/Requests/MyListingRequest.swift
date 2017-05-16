//
//  MyListingRequest.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 04/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct MyListingRequest: Mappable {
	
	var listingData: [String:Any]?
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		listingData <- map["ad"]
	}
}
