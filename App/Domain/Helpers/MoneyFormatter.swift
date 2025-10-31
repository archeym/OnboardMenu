// MoneyFormatter.swift
// OnboardMenu

import Foundation

enum MoneyFormatter {
    ///Formats a Money value using its currency symbol and amount €3.50
    static func symbolOnly(_ money: Money, locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.currencyCode = money.currency.rawValue
        formatter.currencySymbol = money.currency.symbol
        return formatter.string(from: money.amount as NSDecimalNumber) ?? "\(money.amount)"
    }
}

extension Money {
    func symbolOnlyFormatted(locale: Locale = .current) -> String {
        MoneyFormatter.symbolOnly(self, locale: locale)
    }
}
