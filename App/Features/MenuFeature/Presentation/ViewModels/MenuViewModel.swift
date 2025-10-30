//
//  MenuViewModel.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI
import Combine

@MainActor
final class MenuViewModel: ObservableObject {

    @Published var selectedCurrency: Currency {
        didSet {
            if oldValue != selectedCurrency {
                store.currency = selectedCurrency
            }
        }
    }

    let convertPrices: ConvertPrices
    let locale: Locale
    var store: CurrencyStore

    init( convertPrices: ConvertPrices, store: CurrencyStore, locale: Locale = .current) {
        self.convertPrices = convertPrices
        self.locale = locale
        self.store = store
        self.selectedCurrency = store.currency
    }

    // MARK: - Public API for Views

    ///Shared helper for  PayButtonSection  and ExtraCurrencySection
    func recomputeExtras(for baseEURPrice: Decimal) async -> (primary: String, extras: [String]) {
        await priceDisplay(for: baseEURPrice)
    }

    ///Converts base EUR price into the selectedCurrency
    func priceDisplay(for baseEURPrice: Decimal) async -> (primary: String, extras: [String]) {
        let eur = Money(amount: baseEURPrice, currency: .EUR)

        let primaryMoney = (try? await convertPrices(eur, to: selectedCurrency)) ?? eur
        let primary = primaryMoney.symbolOnlyFormatted(locale: locale)

        let others = Currency.allCases.filter { $0 != selectedCurrency }
        var extras: [String] = []

        for current in others {
            if let money = try? await convertPrices(eur, to: current) {
                extras.append(money.symbolOnlyFormatted(locale: locale))
            }
        }

        return (primary, extras)
    }
}
