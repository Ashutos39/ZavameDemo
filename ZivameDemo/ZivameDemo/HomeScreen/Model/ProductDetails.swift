//
//  ProductDetails.swift
//  ZivameDemo
//
//  Created by Ashutos on 9/19/21.
//

import Foundation

struct ProductDetails: Codable {
    let products: [Product]?
}

// MARK: - Product
struct Product: Codable {
    let name, price: String?
    let imageURL: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, price
        case imageURL = "image_url"
        case rating
    }
}
