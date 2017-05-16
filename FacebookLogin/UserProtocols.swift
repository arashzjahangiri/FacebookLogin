//
//  User.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 07/06/16.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation

protocol BasicUserProtocol {
	var id: Int { get }
	var name: String { get set }
	var photo: String { get set }
	var follow: [String: Int] { get set }
}

protocol LoggedInUserProtocol: BasicUserProtocol {
	var location: Location? { get set }
	var email: String? { get set }
	var userNotifications: Bool { get set }
	var appNotifications: Bool { get set }
}
