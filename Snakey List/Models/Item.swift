//
//  Item.swift
//  Snakey List
//
//  Created by Ali Adam on 1/26/18.
//  Copyright © 2018 Ali Adam. All rights reserved.
//

import Foundation
/// item model 
struct Item : Codable {
	let uuid : String?
	let imageUrlString : String?

	enum CodingKeys: String, CodingKey {

		case uuid = "uuid"
		case imageUrlString = "imageUrlString"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
		imageUrlString = try values.decodeIfPresent(String.self, forKey: .imageUrlString)
	}

}
