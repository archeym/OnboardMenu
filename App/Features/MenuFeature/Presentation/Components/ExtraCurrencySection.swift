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
    var onTap: (() -> Void)? = nil
    
    @State private var extras: [String] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(extras.joined(separator: " or "))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap?()
        }
        .task { await recompute() }
        .onChange(of: selectedCurrency) { _, _ in
            Task { await recompute() }
        }
    }
    
    private func recompute() async {
        let display = await priceDisplay(baseEURPrice)
        extras = display.extras
    }
}
