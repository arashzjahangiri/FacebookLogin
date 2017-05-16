//
//  ListingsDetailsRequest.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 05/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct ListingsDetailsRequest: Mappable {
	
	var listings: [Listing]?
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		listings <- map["ads"]
	}
}
