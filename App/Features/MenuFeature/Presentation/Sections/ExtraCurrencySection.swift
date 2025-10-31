//
//  ExtraCurrencySection.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI

struct ExtraCurrencySection: View {
    
    let baseEURPrice: Decimal
    @Binding var selectedCurrency: Currency
    let priceDisplay: (Decimal) async -> (primary: String, extras: [String])

    @State private var extras: [String] = []
    @State private var showCurrencySheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(extras.joined(separator: " | "))
                .font(.subheadline)
                .foregroundStyle(.primary)
        }
        .contentShape(Rectangle())
        .onTapGesture { showCurrencySheet = true }
        .task {
            await recompute()
        }
        .onChange(of: selectedCurrency) { _, _ in
            Task {
                await recompute()
            }
        }
        .sheet(isPresented: $showCurrencySheet) {
            CurrencyTypeSheetBuffered(
                initial: selectedCurrency,
                onClose: {
                    showCurrencySheet = false
                },
                onCommit: { committed in
                    selectedCurrency = committed
                    showCurrencySheet = false
                }
            ).presentationDetents([.height(400), .medium])
        }
    }

    private func recompute() async {
        let display = await priceDisplay(baseEURPrice)
        extras = display.extras
    }
}
