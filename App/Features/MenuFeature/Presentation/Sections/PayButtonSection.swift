//
//  PayButtonSection.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI

struct PayButtonSection: View {

    // Injected via Environment DI using .environment.saleTypeStore
    @Environment(\.saleTypeStore) private var store

    let name: String
    let baseEURPrice: Decimal
    @Binding var selectedCurrency: Currency
    let priceDisplay: (Decimal) async -> (primary: String, extras: [String])
    
    var onButtonPayTap: (() -> Void)? = nil
    var onSaleTypeChange: ((SaleType) -> Void)? = nil
    
    @State private var displayText: (primary: String, extras: [String]) = ("", [])
    @State private var showTypeSheet = false
    @State private var saleType: SaleType = .retail

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                // 65% Pay button with rounded left corners
                Button(action: { onButtonPayTap?() }) {
                    HStack {
                        Text("\(name) \(displayText.primary)")
                            .font(.headline)
                            .lineLimit(1)
                            .foregroundStyle(.white)
                    }
                    .frame(width: geo.size.width * 0.65, height: 44)
                    .background(Color.accentColor)
                    .cornerRadiusStyle(radius: 20, corners: [.topLeft, .bottomLeft])
                }.buttonStyle(.plain)

                // 35% Sale type button with rounded right corners
                Button {
                    showTypeSheet = true
                } label: {
                    HStack(spacing: 8) {
                        Text(saleType.title)
                            .lineLimit(1)
                    }
                    .font(.subheadline.weight(.semibold))
                    .frame(width: geo.size.width * 0.35, height: 44)
                    .background(Color.black.opacity(0.5))
                    .foregroundStyle(Color.white)
                    .cornerRadiusStyle(radius: 20, corners: [.topRight, .bottomRight])
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $showTypeSheet) {
                    PayTypeSheet(selected: $saleType) {
                        store.saleType = saleType
                        onSaleTypeChange?(saleType)
                        showTypeSheet = false
                    }
                }
            }
        }
        .frame(height: 44)
        .padding(.bottom, 5)
        .task {
            //on the initial load read persisted saleType and recompute displayText
            saleType = store.saleType
            await recompute()
        }
        .onChange(of: selectedCurrency) { _, _ in
            Task { await recompute() }
        }
    }

    private func recompute() async {
        displayText = await priceDisplay(baseEURPrice)
    }
}
