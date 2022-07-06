//
//  NewProductInformation.swift
//  OpenMarket
//
//  Created by Allie on 2022/06/29.
//

import Foundation

struct NewProductInformation: Codable {
    let name: String
    let descriptions: String
    let price: Double
    let currency: Currency
    let discountedPrice: Double?
    let stock: Int?
    let secret: String
    
    enum CodingKeys: String, CodingKey {
        case name, descriptions, price, currency, stock, secret
        case discountedPrice = "discounted_price"
    }
}
