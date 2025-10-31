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
        // Menu - MenuMenuCategory - MenuCategory - MenuCategoryItem
        let items: [MenuCategoryItem] = menus
            .flatMap { $0.menuMenuCategories ?? [] }
            .flatMap { $0.menuCategory.menuCategoryItems }
        
        // Map to ProductGrid and filter invalid entries
        let grids = items.compactMap { item -> ProductGrid? in
            let p = item.product
            
            //non-empty name
            guard let name = p.name?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !name.isEmpty else {
                return nil
            }
            
            //non-empty, valid photo URL
            guard
                let photoString = p.photoURL?.trimmingCharacters(in: .whitespacesAndNewlines),
                !photoString.isEmpty,
                let url = URL(string: photoString)
            else {
                return nil
            }
            
            //Require valid, non-zero price
            guard let priceDouble = p.price, priceDouble > 0 else {
                return nil
            }
            
            let priceDecimal = Decimal(priceDouble)
            
            // Format display price
            let formatted: String = {
                let money = Money(amount: priceDecimal, currency: .EUR)
                return money.symbolOnlyFormatted() // e.g. "€3.50"
            }()
            
            //Build grid item
            return ProductGrid(
                id: p.id,
                name: name,
                photoURL: url,
                price: priceDecimal,
                priceText: formatted
            )
        }
        
        //Deduplicate products by id
        var seen = Set<Int>()
        return grids.filter { seen.insert($0.id).inserted }
    }
}

