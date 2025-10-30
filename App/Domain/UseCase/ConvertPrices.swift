//
//  ConvertPrices.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI

struct ConvertPrices {
    let rates: RatesRepository
    init(rates: RatesRepository) { self.rates = rates }

    func callAsFunction(_ money: Money, to currency: Currency) async throws -> Money {
        try await rates.convert(money, to: currency)
    }
}
