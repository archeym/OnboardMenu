//
//  CurrencyStoreTests.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import Testing
@testable import OnboardMenu
import Foundation

@Suite("CurrencyStore")
struct CurrencyStoreTests {

    // isolated, fresh UserDefaults suite each run
    private func makeIsolatedDefaults() -> UserDefaults {
        let name = "test.currency.\(UUID().uuidString)"
        let suite = UserDefaults(suiteName: name)!
        // Ensure its clean
        suite.removePersistentDomain(forName: name)
        return suite
    }

    @Test("read/write round-trips the currency")
    func readWriteCurrency_roundTrips() throws {

        let defaults = makeIsolatedDefaults()
        let store = UserDefaultsCurrencyStore(defaults: defaults)


        #expect(store.currency == .EUR)

        store.currency = .USD
        
        #expect(store.currency == .USD)

        //read new persisted value
        let storeUSD = UserDefaultsCurrencyStore(defaults: defaults)
        #expect(storeUSD.currency == .USD)
    }
}
