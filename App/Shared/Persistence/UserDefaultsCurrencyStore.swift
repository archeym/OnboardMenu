//
//  UserDefaultsCurrencyStore.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI

class UserDefaultsCurrencyStore: CurrencyStore {
    
    let key = "settings.currency"
    let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var currency: Currency {
        get { readCurrency() }
        set { writeCurrency(newValue) }
    }

    func readCurrency() -> Currency {
        let raw = defaults.string(forKey: key) ?? ""
        return Currency(rawValue: raw) ?? .EUR // default
    }

    func writeCurrency(_ value: Currency) {
        defaults.setValue(value.rawValue, forKey: key)
    }
}
