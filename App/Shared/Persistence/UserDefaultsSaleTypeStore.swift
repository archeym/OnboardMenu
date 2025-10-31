//
//  UserDefaultsSaleTypeStore.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI

class UserDefaultsSaleTypeStore: SaleTypeStore {
    
    private let key = "onboard.saleType"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var saleType: SaleType {
        get { read() }
        set { write(newValue) }
    }

    private func read() -> SaleType {
        let raw = defaults.string(forKey: key)
        return SaleType(rawValue: raw ?? "") ?? .retail
    }

    private func write(_ saleType: SaleType) {
        defaults.setValue(saleType.rawValue, forKey: key)
    }
}
