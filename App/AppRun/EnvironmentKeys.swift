//
//  EnvironmentKeys.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI


struct SaleTypeStoreKey: EnvironmentKey {
    static let defaultValue: SaleTypeStore = UserDefaultsSaleTypeStore()
}

extension EnvironmentValues {
    var saleTypeStore: SaleTypeStore {
        get { self[SaleTypeStoreKey.self] }
        set { self[SaleTypeStoreKey.self] = newValue }
    }
}

