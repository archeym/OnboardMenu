//
//  DI.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI

enum DI {
    static func makeMenuView() -> some View {
        let rates = SimpleRatesRepository()
        let convert = ConvertPrices(rates: rates)
        let currencyStore = UserDefaultsCurrencyStore()
        let saleTypeStore = UserDefaultsSaleTypeStore()

        let vm = MenuViewModel(convertPrices: convert, store: currencyStore)
        return MenuView(vm: vm)
            .environment(\.saleTypeStore, saleTypeStore)
    }
}
