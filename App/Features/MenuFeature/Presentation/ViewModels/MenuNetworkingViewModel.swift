//
//  MenuNetworkingViewModel.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 31/10/2025.
//

import SwiftUI
import Combine

@MainActor
class MenuNetworkingViewModel: ObservableObject {
    
    @Published private(set) var menuResource = NetworkResource<[Menu]>()

    let loadMenu: LoadMenu
    
    init(loadMenu: LoadMenu) {
        self.loadMenu = loadMenu
    }

    func fetch(merchantId: Int) async {
        menuResource.state = .loading(previous: menuResource.value)
        do {
            let menu = try await loadMenu(merchantId: merchantId)
            menuResource.state = .success(menu)
        } catch let api as APIError {
            menuResource.state = .error(api)
        } catch {
            menuResource.state = .error(.system(error.localizedDescription))
        }
    }

    /// Resets the resource back to idle so the user can retry after an error alert is dismissed.
    func clearError() {
        menuResource.state = .idle
    }
    
    func products(from menus: [Menu]) -> [ProductGrid] {
        let items: [MenuCategoryItem] = menus
            .flatMap { $0.menuMenuCategories ?? [] }
            .flatMap { $0.menuCategory.menuCategoryItems }

        var seen = Set<Int>()

        return items.compactMap { item -> ProductGrid? in
            let p = item.product

            // name
            guard let name = p.name?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else { return nil }

            // photo
            guard let url = p.photoURL?.asSafeURL else { return nil }

            // valid price (> 0)
            guard let price = p.price, price > 0 else { return nil }
            let eur = Decimal(price)

            // dedupe
            guard seen.insert(p.id).inserted else { return nil }

            // Build price text using MoneyFormatter with EUR
            let money = Money(amount: eur, currency: .EUR)
            let priceText = money.symbolOnlyFormatted()

            return ProductGrid(id: p.id, name: name, photoURL: url, eurPrice: eur, priceText: priceText)
        }
    }
}

