//
//  ProductDetailInformation.swift
//  OpenMarket
//
//  Created by Allie on 2022/07/11.
//

import Foundation

struct ProductDetailInformation: Codable {
    let id: Int
    let vendorId: Int
    let name: String
    let description: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let images: [ProductImage]
    let vendors: Vendors?
    let createdAt: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail, currency, price, stock, images, vendors
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
