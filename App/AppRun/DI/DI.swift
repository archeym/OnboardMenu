//
//  DI.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI

enum DI {
    @MainActor
    static func makeMenuView(merchantId: Int = 71) -> some View {
        //Currency stack
        let rates = SimpleRatesRepository()
        let convert = ConvertPrices(rates: rates)
        let curStore = UserDefaultsCurrencyStore()
        let vm = MenuViewModel(convertPrices: convert, store: curStore)

        //Networking stack
        let client = APIClient()
        let repo = RemoteMenuRepository(client: client)
        let loadMenu = LoadMenu(repo: repo)
        let netVM = MenuNetworkingViewModel(loadMenu: loadMenu)

        return MenuView(vm: vm, netVM: netVM, merchantId: merchantId)
            .environment(\.saleTypeStore, UserDefaultsSaleTypeStore())
    }
}
