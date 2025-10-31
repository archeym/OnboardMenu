//
//  ProductCard_Previews.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 31/10/2025.
//

import SwiftUI

#if DEBUG

struct ProductCard_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            GridPreview()
                .previewDisplayName("Grid 2 Columns")
        }
    }
    
    private struct GridPreview: View {
        
        private let gridColumns = [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]
        
        var body: some View {
            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: 12) {
                    ForEach(ProductGrid.demo) { item in
                        ProductCard(
                            title: item.name,
                            imageURL: item.photoURL,
                            priceText: item.priceText,
                            onMinus: { print("Minus \(item.name)") },
                            onPlus: { print("Plus \(item.name)") }
                        )
                    }
                }.padding()
            }
        }
    }
}

#endif
