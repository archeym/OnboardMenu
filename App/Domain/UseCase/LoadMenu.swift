//
//  LoadMenu..swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 31/10/2025.
//

import Foundation

struct LoadMenu {
    let repo: MenuRepository
    init(repo: MenuRepository) { self.repo = repo }

    func callAsFunction(merchantId: Int) async throws -> [Menu] {
        try await repo.loadMenu(merchantId: merchantId)
    }
}
