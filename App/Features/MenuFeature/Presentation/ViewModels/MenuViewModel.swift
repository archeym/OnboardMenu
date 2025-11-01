//
//  MenuViewModel.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI
import Combine

@MainActor
class MenuViewModel: ObservableObject {
    
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

    // Example: cache[.USD] = 1.08 means 1 EUR = 1.08 USD
    @Published private(set) var eurRateCache: [Currency: Decimal] = [.EUR: 1]

    init(convertPrices: ConvertPrices, store: CurrencyStore, locale: Locale = .current) {
        self.convertPrices = convertPrices
        self.locale = locale
        self.store = store
        self.selectedCurrency = store.currency
    }
    
    ///Shared helper for PayButtonSection and ExtraCurrencySection
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
                eurRateCache[current] = money.amount / baseEURPrice
            }
        }

        // Ensure cache for selected currency
        if selectedCurrency == .EUR {
            eurRateCache[.EUR] = 1
        } else {
            // store multiplier for 1 EUR if we can infer it from primaryMoney
            if baseEURPrice != 0 {
                eurRateCache[selectedCurrency] = primaryMoney.amount / baseEURPrice
            } else {
                //fallback by converting 1 EUR
                await warmRate(for: selectedCurrency)
            }
        }

        return (primary, extras)
    }
    
    ///Ensure multiplier for 1 EUR currency populates the cache
    func warmRate(for currency: Currency) async {
        if eurRateCache[currency] != nil { return }
        let one = Money(amount: 1, currency: .EUR)
        if let converted = try? await convertPrices(one, to: currency) {
            eurRateCache[currency] = converted.amount   // 1 EUR → X currency
        }
    }

    ///Convert a EUR amount to a target currency using the cache , if missing, it warms the cache
    func convert(amountEUR: Decimal, to currency: Currency) async -> Decimal {
        if currency == .EUR { return amountEUR }
        if let mul = eurRateCache[currency] {
            return amountEUR * mul
        } else {
            await warmRate(for: currency)
            let mul = eurRateCache[currency] ?? 1
            return amountEUR * mul
        }
    }

    func format(_ amount: Decimal, in currency: Currency) -> String {
        Money(amount: amount, currency: currency).symbolOnlyFormatted(locale: locale)
    }

    /// One-shot helper for cards: EUR → selected, then format
    /// Usage from a Task/async context or precompute in a view model array
    func priceTextForCard(eurPrice: Decimal) async -> String {
        let converted = await convert(amountEUR: eurPrice, to: selectedCurrency)
        return format(converted, in: selectedCurrency)
    }

    /// Synchronous path in views:
    /// - Call await vm.warmRate(for: vm.selectedCurrency) for .task
    /// - Then use this to avoid `await` at row render-time
    func priceTextForCardSync(eurPrice: Decimal) -> String {
        let mul = eurRateCache[selectedCurrency] ?? 1
        return format(eurPrice * mul, in: selectedCurrency)
    }
}
