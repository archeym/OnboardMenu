//
//  Money.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 31/10/2025.
//

import SwiftUI

struct Money: Equatable, Codable, Sendable {
    
    let amount: Decimal
    let currency: Currency
    
    init(amount: Decimal, currency: Currency) {
        self.amount = amount
        self.currency = currency
    }

}
