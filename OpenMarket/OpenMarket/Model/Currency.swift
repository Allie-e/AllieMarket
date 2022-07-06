//
//  Currency.swift
//  OpenMarket
//
//  Created by Allie on 2022/07/06.
//

import Foundation

enum Currency: String, CaseIterable, Codable {
    case won = "KRW"
    case dollar = "USD"
    
    var description: String {
        return rawValue
    }
}
