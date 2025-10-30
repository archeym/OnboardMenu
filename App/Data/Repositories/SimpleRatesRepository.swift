//
//  SimpleRatesRepository.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI

class SimpleRatesRepository: RatesRepository {
    // base: EUR
    private let eurTo: [Currency: Decimal] = [
        .EUR: 1,
        .USD: 1.10,
        .GBP: 0.85
    ]

    func convert(_ money: Money, to currency: Currency) async throws -> Money {
        //We always pass in EUR as the main currency
        guard money.currency == .EUR, let rate = eurTo[currency] else {
            return money
        }
        return Money(amount: money.amount * rate, currency: currency)
    }
}
