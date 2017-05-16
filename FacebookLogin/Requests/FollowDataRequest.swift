//
//  FollowDataRequest.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 03/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct FollowDataRequest: Mappable {
	
	var following: [Int]?
	var followers: [Int]?
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		followers <- map["followers"]
		following <- map["following"]
	}
}
