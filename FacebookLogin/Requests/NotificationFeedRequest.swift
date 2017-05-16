//
//  NotificationFeedRequest.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 03/10/2016.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import ObjectMapper

struct NotificationFeedRequest: Mappable {
	
	var notifications: [Notification]?
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		notifications <- map["notifications"]
	}
}
