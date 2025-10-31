//
//  CurrencyTypeSheetBuffered.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 31/10/2025.
//

import SwiftUI

struct CurrencyTypeSheetBuffered: View {
    
    let initial: Currency
    let onClose: () -> Void
    let onCommit: (Currency) -> Void

    @State private var tempSelected: Currency

    init(initial: Currency, onClose: @escaping () -> Void, onCommit: @escaping (Currency) -> Void) {
        self.initial = initial
        self.onClose = onClose
        self.onCommit = onCommit
        _tempSelected = State(initialValue: initial)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(Currency.allCases, id: \.self) { currency in
                    Button {
                        tempSelected = currency
                        onCommit(currency)//parent sets selectedCurrency and hides sheet
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: currency == tempSelected ? "checkmark.circle.fill" : "circle")
                                .imageScale(.large)
                            Text(currency.rawValue).font(.headline)
                            Spacer()
                        }.contentShape(Rectangle())
                    }.buttonStyle(.plain)
                }
            }
            .navigationTitle("Select Currency")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", action: onClose)
                }
            }
        }.presentationDetents([.height(150), .medium])
    }
}
