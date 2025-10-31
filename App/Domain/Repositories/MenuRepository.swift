//
//  MenuRepository.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 31/10/2025.
//

import SwiftUI

protocol MenuRepository {
    ///api/merchant/{id}/menu
    func loadMenu(merchantId: Int) async throws -> [Menu]
}
