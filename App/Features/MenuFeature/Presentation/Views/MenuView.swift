//
//  MenuView.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI
import NetworkMonitor

struct MenuView: View {
    
    @StateObject var vm: MenuViewModel
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    private let baseEURPrice: Decimal = Decimal(string: "3.50")!
    
    private let gridColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                VStack(spacing: 10) {
                    
                    ScrollView {
                        LazyVGrid(columns: gridColumns, spacing: 12) {
                            ForEach(ProductGrid.demo) { item in
                                ProductCard(
                                    title: item.title,
                                    imageURL: item.imageURL,
                                    priceText: item.priceText,
                                    onMinus: { print("Minus \(item.title)") },
                                    onPlus: { print("Plus \(item.title)") }
                                )
                            }
                        }
                    }
                    
                    PayButtonSection(
                        name: "PAY",
                        baseEURPrice: baseEURPrice,
                        selectedCurrency: $vm.selectedCurrency,
                        priceDisplay: {
                            await vm.recomputeExtras(for: $0)
                        },
                        onButtonPayTap: {
                            dump("onButtonPayTap")
                        }
                    )

                    ExtraCurrencySection(
                        baseEURPrice: baseEURPrice,
                        selectedCurrency: $vm.selectedCurrency,
                        priceDisplay: {
                            await vm.recomputeExtras(for: $0)
                        }
                    )
                }
                
                if !networkMonitor.isConnected {
                    OfflineBannerSection()
                        .animation(.easeInOut(duration: 0.25), value: networkMonitor.isConnected)
                }
            }
            .disabled(!networkMonitor.isConnected)
            .padding(.horizontal)
            .navigationTitle("Products")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
