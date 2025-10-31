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
    let price: Decimal?
    let priceText: String
}

#if DEBUG
extension ProductGrid {
    ///Demo data for previews, MenuView or offline testing
    static let demo: [ProductGrid] = [
        ProductGrid(id: 1,  name: "Latte",        photoURL: URL(string: "https://picsum.photos/400?1"),  price: nil, priceText: "€3.50"),
        ProductGrid(id: 2,  name: "Cappuccino",   photoURL: URL(string: "https://picsum.photos/400?2"),  price: nil, priceText: "€3.20"),
        ProductGrid(id: 3,  name: "Espresso",     photoURL: URL(string: "https://picsum.photos/400?3"),  price: nil, priceText: "€2.10"),
        ProductGrid(id: 4,  name: "Mocha",        photoURL: URL(string: "https://picsum.photos/400?4"),  price: nil, priceText: "€3.80"),
        ProductGrid(id: 5,  name: "Flat White",   photoURL: URL(string: "https://picsum.photos/400?5"),  price: nil, priceText: "€3.60"),
        ProductGrid(id: 6,  name: "Americano",    photoURL: URL(string: "https://picsum.photos/400?6"),  price: nil, priceText: "€2.50"),
        ProductGrid(id: 7,  name: "Espresso",     photoURL: URL(string: "https://picsum.photos/400?7"),  price: nil, priceText: "€2.10"),
        ProductGrid(id: 8,  name: "Latte",        photoURL: URL(string: "https://picsum.photos/400?8"),  price: nil, priceText: "€6.50"),
        ProductGrid(id: 9,  name: "Latte",        photoURL: URL(string: "https://picsum.photos/400?9"),  price: nil, priceText: "€3.10"),
        ProductGrid(id: 10, name: "Latte",        photoURL: URL(string: "https://picsum.photos/400?10"), price: nil, priceText: "€1.50")
    ]
}
#endif

