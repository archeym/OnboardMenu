//
//  ProductGrid.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 31/10/2025.
//

import SwiftUI

struct ProductGrid: Identifiable {
    
    let id: Int
    let name: String
    let photoURL: URL?
    let eurPrice: Decimal?
    let priceText: String
}

#if DEBUG
extension ProductGrid {
    ///Demo data for previews, MenuView or offline testing
    static let demo: [ProductGrid] = [
        ProductGrid(id: 1,  name: "Latte",        photoURL: URL(string: "https://picsum.photos/400?1"),  eurPrice: Decimal(string: "3.50")!, priceText: "€3.50"),
        ProductGrid(id: 2,  name: "Cappuccino",   photoURL: URL(string: "https://picsum.photos/400?2"),  eurPrice: Decimal(string: "3.20")!, priceText: "€3.20"),
        ProductGrid(id: 3,  name: "Espresso",     photoURL: URL(string: "https://picsum.photos/400?3"),  eurPrice: Decimal(string: "2.10")!, priceText: "€2.10"),
        ProductGrid(id: 4,  name: "Mocha",        photoURL: URL(string: "https://picsum.photos/400?4"),  eurPrice: Decimal(string: "3.80")!, priceText: "€3.80"),
        ProductGrid(id: 5,  name: "Flat White",   photoURL: URL(string: "https://picsum.photos/400?5"),  eurPrice: Decimal(string: "3.60")!, priceText: "€3.60"),
        ProductGrid(id: 6,  name: "Americano",    photoURL: URL(string: "https://picsum.photos/400?6"),  eurPrice: Decimal(string: "2.50")!, priceText: "€2.50"),
        ProductGrid(id: 7,  name: "Espresso",     photoURL: URL(string: "https://picsum.photos/400?7"),  eurPrice: Decimal(string: "2.10")!, priceText: "€2.10"),
        ProductGrid(id: 8,  name: "Latte",        photoURL: URL(string: "https://picsum.photos/400?8"),  eurPrice: Decimal(string: "6.50")!, priceText: "€6.50"),
        ProductGrid(id: 9,  name: "Latte",        photoURL: URL(string: "https://picsum.photos/400?9"),  eurPrice: Decimal(string: "3.10")!, priceText: "€3.10"),
        ProductGrid(id: 10, name: "Latte",        photoURL: URL(string: "https://picsum.photos/400?10"), eurPrice: Decimal(string: "1.50")!, priceText: "€1.50")
    ]
}
#endif
