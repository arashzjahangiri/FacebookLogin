//
//  FavoriteListingsRequest.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 04/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct FavoriteListingsRequest: Mappable {
	
	var ids: [Int]?
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		ids <- map["ids"]
	}
}
