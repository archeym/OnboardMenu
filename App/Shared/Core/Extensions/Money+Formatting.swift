//
//  Money+Formatting.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import Foundation

extension Money {
    func symbolOnlyFormatted(locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.currencyCode = currency.rawValue
        formatter.currencySymbol = currency.symbol

        return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)"
    }
}
