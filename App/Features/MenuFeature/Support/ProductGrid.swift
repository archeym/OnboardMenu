//
//  ProductGrid.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 31/10/2025.
//

import SwiftUI

struct ProductGrid: Identifiable {
    
    let id = UUID()
    let title: String
    let imageURL: URL?
    let priceText: String
    
}

#if DEBUG
extension ProductGrid {
    ///Demo data for previews, MenuView or offline testing
    static let demo: [ProductGrid] = [
        ProductGrid(title: "Latte", imageURL: URL(string: "https://picsum.photos/400?1"), priceText: "€3.50"),
        ProductGrid(title: "Cappuccino", imageURL: URL(string: "https://picsum.photos/400?2"), priceText: "€3.20"),
        ProductGrid(title: "Espresso", imageURL: URL(string: "https://picsum.photos/400?3"), priceText: "€2.10"),
        ProductGrid(title: "Mocha", imageURL: URL(string: "https://picsum.photos/400?4"), priceText: "€3.80"),
        ProductGrid(title: "Flat White", imageURL: URL(string: "https://picsum.photos/400?5"), priceText: "€3.60"),
        ProductGrid(title: "Americano", imageURL: URL(string: "https://picsum.photos/400?6"), priceText: "€2.50"),
        ProductGrid(title: "Espresso", imageURL: URL(string: "https://picsum.photos/400?7"), priceText: "€2.10"),
        ProductGrid(title: "Latte", imageURL: URL(string: "https://picsum.photos/400?8"), priceText: "€6.50"),
        ProductGrid(title: "Latte", imageURL: URL(string: "https://picsum.photos/400?9"), priceText: "€3.10"),
        ProductGrid(title: "Latte", imageURL: URL(string: "https://picsum.photos/400?10"), priceText: "€1.50")
    ]
}
#endif
