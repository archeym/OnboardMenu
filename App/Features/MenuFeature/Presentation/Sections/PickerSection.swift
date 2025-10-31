//
//  PickerSection.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI

struct PickerSection: View {
    
    @Binding var selectedCurrency: Currency

    var body: some View {
        Picker("", selection: $selectedCurrency) {
            ForEach(Currency.allCases, id: \.self) { currency in
                Text(currency.rawValue).tag(currency)
            }
        }.pickerStyle(.segmented)
    }
}

