//
//  RatesRepository.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI

protocol RatesRepository {
    func convert(_ money: Money, to currency: Currency) async throws -> Money
}
