//
//  ModelTypes.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI

enum Currency: String, Codable, CaseIterable, Sendable {
    
    case EUR, USD, GBP
    
    var symbol: String {
        switch self {
        case .EUR: "€"
        case .USD: "$"
        case .GBP: "£"
        }
    }
}

struct Money: Equatable, Codable, Sendable {
    let amount: Decimal
    let currency: Currency
    
}
